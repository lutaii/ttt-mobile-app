import 'dart:convert';
import 'package:ttt_mobile_app/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LobbySocketService {
  final String lobbyCode;
  final Function(Map<String, dynamic>) onLobbyUpdated;
  final Function(String) onDisconnected;
  late WebSocketChannel channel;
  final String? firebaseUid;

  LobbySocketService(
    this.lobbyCode, {
    required this.onLobbyUpdated,
    required this.onDisconnected,
    required this.firebaseUid,
  }) {
    // Connect to your backend WebSocket endpoint.
    // Make sure your backend supports WebSocket connections at this URL.
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3000/ws'));

    // Send a message to join the lobby room.
    final joinMessage = jsonEncode({
      'action': 'joinLobbyRoom',
      'lobbyCode': lobbyCode,
      'uid': firebaseUid, // Make sure firebaseUid is obtained from FirebaseAuth
    });
    channel.sink.add(joinMessage);
    logger.d('Sent join message: $joinMessage');

    // Listen for messages from the backend.
    channel.stream.listen(
      (message) {
        logger.d('Received message: $message');
        try {
          final data = jsonDecode(message);
          if (data['event'] == 'lobbyUpdated') {
            // Update lobby state from the data.
            onLobbyUpdated(data['lobby']);
            if (data.containsKey('disconnectMessage')) {
              // Update the UI to show the disconnect message.
              onDisconnected(data['disconnectMessage']);
            }
          }
          if (data['event'] == 'lobbyClosed') {
            onDisconnected(data['message']);
            // Optionally add more logic to navigate away.
          }
        } catch (e) {
          logger.d('Error parsing message: $e');
        }
      },
      onError: (error) {
        logger.d('WebSocket error: $error');
        onDisconnected('Connection error: $error');
      },
      onDone: () {
        logger.d('WebSocket connection closed');
        onDisconnected('Disconnected from lobby');
      },
    );
  }

  void dispose() {
    channel.sink.close();
  }
}
