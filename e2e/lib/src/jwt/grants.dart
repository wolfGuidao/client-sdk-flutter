class VideoGrant {
  /// permission to create a room
  bool? roomCreate;

  /// permission to join a room as a participant, room must be set
  bool? roomJoin;

  /// permission to list rooms
  bool? roomList;

  /// permission to start a recording
  bool? roomRecord;

  /// permission to control a specific room, room must be set
  bool? roomAdmin;

  /// name of the room, must be set for admin or join permissions
  String? room;

  /// allow participant to publish. If neither canPublish or canSubscribe is set,
  /// both publish and subscribe are enabled
  bool? canPublish;

  /// allow participant to subscribe to other tracks
  bool? canSubscribe;

  /// allow participants to publish data, defaults to true if not set
  bool? canPublishData;

  /// participant isn't visible to others
  bool? hidden;

  /// participant is recording the room, when set, allows room to indicate it's being recorded
  bool? recorder;

  VideoGrant(
      {this.roomCreate,
      this.roomJoin,
      this.roomList,
      this.roomRecord,
      this.roomAdmin,
      this.room,
      this.canPublish,
      this.canSubscribe,
      this.canPublishData,
      this.hidden,
      this.recorder});
  factory VideoGrant.fromJson(Map<String, dynamic> json) {
    return VideoGrant(
      roomCreate: json['roomCreate'] as bool?,
      roomJoin: json['roomJoin'] as bool?,
      roomList: json['roomList'] as bool?,
      roomRecord: json['roomRecord'] as bool?,
      roomAdmin: json['roomAdmin'] as bool?,
      room: json['room'] as String?,
      canPublish: json['canPublish'] as bool?,
      canSubscribe: json['canSubscribe'] as bool?,
      canPublishData: json['canPublishData'] as bool?,
      hidden: json['hidden'] as bool?,
      recorder: json['recorder'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomCreate': roomCreate,
      'roomJoin': roomJoin,
      'roomList': roomList,
      'roomRecord': roomRecord,
      'roomAdmin': roomAdmin,
      'room': room,
      'canPublish': canPublish,
      'canSubscribe': canSubscribe,
      'canPublishData': canPublishData,
      'hidden': hidden,
      'recorder': recorder,
    };
  }
}

class ClaimGrants {
  String? name;
  VideoGrant? video;
  String? metadata;
  String? sha256;

  ClaimGrants({this.name, this.video, this.metadata, this.sha256});
  factory ClaimGrants.fromJson(Map<String, dynamic> json) {
    return ClaimGrants(
      name: json['name'] as String?,
      video: json['video'] == null
          ? null
          : VideoGrant.fromJson(json['video'] as Map<String, dynamic>),
      metadata: json['metadata'] as String?,
      sha256: json['sha256'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'video': video?.toJson(),
      'metadata': metadata,
      'sha256': sha256,
    };
  }
}
