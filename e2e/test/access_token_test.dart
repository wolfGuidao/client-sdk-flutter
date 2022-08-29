import 'package:flutter_test/flutter_test.dart';
import 'package:livekit_client_e2e_test/src/jwt/access_tokent.dart';
import 'package:livekit_client_e2e_test/src/jwt/grants.dart';

const String apiKey = 'API_KEY';
const String apiSecret = 'API_SECRET';

void main() {
  test('access token test with options and grants', () {
    final accessToken = AccessToken(apiKey, apiSecret,
        options: AccessTokenOptions(
            identity: 'identity', ttl: Duration(seconds: 1000)),
        grants:
            ClaimGrants(name: 'name', metadata: 'metadata', sha256: 'sha256'));
    expect(accessToken.apiKey, apiKey);
    expect(accessToken.apiSecret, apiSecret);
    expect(accessToken.grants!.name, 'name');
    expect(accessToken.grants!.metadata, 'metadata');
    expect(accessToken.grants!.sha256, 'sha256');
    expect(accessToken.identity, 'identity');
    expect(accessToken.ttl!.inSeconds, 1000);
  });

  test('encoded tokens are valid', () {
    final accessToken = AccessToken(apiKey, apiSecret,
        grants: ClaimGrants(
            name: 'name',
            metadata: 'metadata',
            sha256: 'sha256',
            video: VideoGrant()..room = 'myroom'));
    final encodedToken = accessToken.toJwt();
    expect(encodedToken, isNotNull);
    expect(encodedToken, isNotEmpty);
    final verifier = TokenVerifier(apiKey, apiSecret);
    final grants = verifier.verify(encodedToken);
    expect(grants, isNotNull);
    expect(grants!.name, 'name');
    expect(grants.metadata, 'metadata');
    expect(grants.video!.room, 'myroom');
  });

  test('identity is required for only join grants', () {
    final accessToken = AccessToken(apiKey, apiSecret);
    accessToken.addGrant(VideoGrant()..roomCreate = true);
    expect(accessToken.toJwt(), isNotEmpty);
  });

  test('identity is required for only join grants', () {
    final accessToken = AccessToken(apiKey, apiSecret);
    accessToken.addGrant(VideoGrant()..roomJoin = true);
    expect(() => accessToken.toJwt(), throwsA(isA<Exception>()));
  });

  test('verify token is valid', () {
    final accessToken = AccessToken(apiKey, apiSecret);
    accessToken.sha256 = 'abcdefg';
    accessToken.addGrant(VideoGrant()..roomCreate = true);
    final verifier = TokenVerifier(apiKey, apiSecret);
    final encodedToken = accessToken.toJwt();
    expect(encodedToken, isNotNull);
    final grants = verifier.verify(encodedToken);
    expect(grants, isNotNull);
    expect(grants!.sha256, 'abcdefg');
    expect(grants.video!.roomCreate, true);
  });
}
