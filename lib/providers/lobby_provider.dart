import 'package:flutter/material.dart';
import '../services/lobby_service.dart';
import '../services/auth_service.dart';
import '../services/lobby_socket_service.dart';

class LobbyProvider extends ChangeNotifier {
  String? firebaseUid;
  String? lobbyCode;
  int _playersCount = 0;
  String? message;
  LobbySocketService? socketService;

  LobbyProvider() {
    init();
  }

  Future<void> init() async {
    firebaseUid = await AuthService.getFirebaseUid();
    notifyListeners();
  }

  int get lobbyPlayersCount => _playersCount;

  /// Create a new lobby. For host, players count starts at 1.
  Future<bool> createLobby() async {
    if (firebaseUid == null) return false;
    final result = await LobbyService.createLobby(firebaseUid!);
    if (result != null && result.containsKey('code')) {
      lobbyCode = result['code'];
      _playersCount = 1;
      message = 'Waiting for guest to join...';
      // Initialize the web socket service with both update and disconnect callbacks.
      socketService = LobbySocketService(
        lobbyCode!,
        onLobbyUpdated: updateLobbyState,
        onDisconnected: handleDisconnect,
        firebaseUid: firebaseUid,
      );
      notifyListeners();
      return true;
    }
    message = 'Failed to create lobby';
    notifyListeners();
    return false;
  }

  /// For a guest joining the lobby.
  Future<bool> joinLobby(String code) async {
    if (firebaseUid == null) return false;
    final result = await LobbyService.joinLobby(code, firebaseUid!);
    if (result != null) {
      lobbyCode = code;
      _playersCount = 2;
      message = 'Game started!';
      // A guest may optionally connect to listen for further updates.
      socketService = LobbySocketService(
        lobbyCode!,
        onLobbyUpdated: updateLobbyState,
        onDisconnected: handleDisconnect,
        firebaseUid: firebaseUid,
      );
      notifyListeners();
      return true;
    }
    message = 'Failed to join lobby';
    notifyListeners();
    return false;
  }

  /// Callback to update lobby state from socket messages.
  void updateLobbyState(Map<String, dynamic> lobbyData) {
    _playersCount = (lobbyData['players'] as List).length;
    if (_playersCount < 2) {
      message = 'Waiting for guest to join...';
    } else {
      message = 'Game started!';
    }
    notifyListeners();
  }

  /// Handle disconnections.
  void handleDisconnect(String disconnectMessage) {
    message = disconnectMessage;
    // Optionally, reset lobby state or navigate away.
    notifyListeners();
  }

  void disconnect() {
    socketService?.dispose();
    socketService = null;
    message = 'Disconnected from lobby';
    notifyListeners();
  }

  @override
  void dispose() {
    socketService?.dispose();
    super.dispose();
  }
}
