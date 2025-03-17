// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ttt_mobile_app/services/auth_service.dart';
import 'package:ttt_mobile_app/services/lobby_service.dart';

class LobbyProvider extends ChangeNotifier {
  String? firebaseUid;
  String? lobbyCode;
  String? message;

  LobbyProvider() {
    init();
  }

  Future<void> init() async {
    firebaseUid = await AuthService.getFirebaseUid();
    notifyListeners();
  }

  Future<void> createLobby() async {
    if (firebaseUid == null) {
      message = 'Failed to create a lobby';
      notifyListeners();
      return;
    }
    final result = await LobbyService.createLobby(firebaseUid!);
    if (result != null && result.containsKey('code')) {
      lobbyCode = result['code'];
      message = 'Lobby created with code: $lobbyCode';
    } else {
      message = 'Failed to create a lobby';
    }
    notifyListeners();
  }

  Future<void> joinLobby(String code) async {
    if (firebaseUid == null) {
      message = 'Failed to create a lobby';
      notifyListeners();
      return;
    }
    final result = await LobbyService.joinLobby(code, firebaseUid!);
    if (result != null) {
      lobbyCode = code;
      message = 'Joined lobby: $code';
    } else {
      message = 'Failed to join room';
    }
    notifyListeners();
  }
}
