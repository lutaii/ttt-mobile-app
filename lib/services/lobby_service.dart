import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ttt_mobile_app/main.dart';

class LobbyService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<Map<String, dynamic>?> createLobby(String firebaseUid) async {
    final url = Uri.parse('$baseUrl/lobby');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': firebaseUid}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      logger.d('Error creating lobby: ${response.body}');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> joinLobby(
    String lobbyCode,
    String firebaseUid,
  ) async {
    final url = Uri.parse('$baseUrl/lobby/$lobbyCode/join');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': firebaseUid}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      logger.d('Error joining lobby: ${response.body}');
    }
    return null;
  }
}
