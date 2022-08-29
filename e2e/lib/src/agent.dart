import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class AgentOptions {
  String? url;
  String? token;
  String? apiKey;
  String? apiSecret;

  RTCVideoRenderer? renderer;
}

class Agent {
  final String name;
  final String roomName;
  final String identity;
  final AgentOptions options;
  late Room room;

  Agent(
      {required this.name,
      required this.roomName,
      required this.identity,
      required this.options}) {
    //create new room
    room = Room();

    // Create a Listener before connecting
    final listener = room.createListener();

    listener
      ..on<TrackSubscribedEvent>((_) {})
      ..on<TrackUnsubscribedEvent>((_) {})
      ..on<TrackMutedEvent>((_) {})
      ..on<TrackUnmutedEvent>((_) {})
      ..on<ParticipantConnectedEvent>((_) {})
      ..on<ParticipantDisconnectedEvent>((_) {})
      ..on<LocalTrackPublishedEvent>((_) {})
      ..on<LocalTrackUnpublishedEvent>((_) => {})
      ..on<DataReceivedEvent>((event) {})
      ..on<RoomDisconnectedEvent>((_) {});

    room.connect(options.url!, options.token!);
  }

  LocalParticipant? get localParticipant => room.localParticipant;
}
