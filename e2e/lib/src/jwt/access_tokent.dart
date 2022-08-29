import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'grants.dart' show ClaimGrants, VideoGrant;

// 6 hours
const int defaultTTL = 6 * 60 * 60;

class AccessTokenOptions {
  ///  amount of time before expiration
  ///  expressed in seconds or a string describing a time span zeit/ms.
  ///  eg: '2 days', '10h', or seconds as numeric value
  dynamic ttl;

  /// display name for the participant, available as `Participant.name`
  String? name;

  /// identity of the user, required for room join tokens
  String? identity;

  /// custom metadata to be passed to participants
  String? metadata;

  AccessTokenOptions({this.ttl, this.name, this.identity, this.metadata});
}

class AccessToken {
  String apiKey;
  String apiSecret;
  ClaimGrants? grants;
  String? identity;
  dynamic ttl;
  AccessTokenOptions? options;

  AccessToken(this.apiKey, this.apiSecret,
      {this.identity, this.ttl = defaultTTL, this.options, this.grants}) {
    if (grants == null) {
      this.grants = ClaimGrants();
    }
    this.identity = options?.identity;
    this.ttl = options?.ttl ?? defaultTTL;
    if (options?.metadata != null) {
      this.metadata = options?.metadata;
    }
    if (options?.name != null) {
      this.name = options?.name;
    }
  }

  /**
   * Adds a video grant to this token.
   * @param grant
   */
  void addGrant(VideoGrant grant) {
    this.grants!.video = grant;
  }

  /**
   * Set metadata to be passed to the Participant, used only when joining the room
   */
  set metadata(String? md) {
    this.grants?.metadata = md;
  }

  set name(String? name) {
    this.grants?.name = name;
  }

  String? get sha256 => this.grants?.sha256;

  set sha256(String? sha) {
    this.grants?.sha256 = sha;
  }

  //// JWT encoded token
  String toJwt() {
    // Create a json web token
    final jwt = JWT(
      grants!.toJson(),
      issuer: this.apiKey,
      subject: this.identity,
      jwtId: this.identity,
    );

    if (this.identity != null) {
      jwt.subject = this.identity;
      jwt.jwtId = this.identity;
    } else if (grants?.video?.roomJoin == true) {
      throw Exception('identity is required for join but not set');
    }

    /// Sign it (default with HS256 algorithm)
    final token = jwt.sign(SecretKey(this.apiSecret),
        notBefore: Duration(seconds: 0),
        expiresIn: Duration(seconds: this.ttl));

    //print('Signed token: $token\n');

    return token;
  }
}

class TokenVerifier {
  String apiKey;
  String apiSecret;
  TokenVerifier(this.apiKey, this.apiSecret);
  ClaimGrants? verify(String token) {
    try {
      // Verify a token
      final jwt =
          JWT.verify(token, SecretKey(this.apiSecret), issuer: this.apiKey);

      //print('Payload: ${jwt.payload}');

      Map<String, dynamic> decoded = jwt.payload as Map<String, dynamic>;
      return ClaimGrants.fromJson(decoded);
    } on JWTExpiredError {
      print('jwt expired');
    } on JWTError catch (ex) {
      print(ex.message); // ex: invalid signature
    }
    return null;
  }
}
