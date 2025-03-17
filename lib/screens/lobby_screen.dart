import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_mobile_app/screens/game1_screen.dart';
import 'package:ttt_mobile_app/screens/game_screen.dart';
import '../providers/lobby_provider.dart';

class LobbyScreen extends StatelessWidget {
  final TextEditingController joinController = TextEditingController();

  LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lobby')),
      body: Consumer<LobbyProvider>(
        builder: (context, lobbyProvider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => GameScreen()));
                    lobbyProvider.createLobby();
                  },
                  child: Text('Create Lobby'),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: joinController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Lobby Code',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final code = joinController.text.trim();
                    if (code.isNotEmpty) {
                      bool success = await lobbyProvider.joinLobby(code);
                      if (success) {
                        // Navigate to waiting screen (which shows "Game started!")
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => GameScreen()));
                      }
                    }
                  },
                  child: Text('Join Lobby'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
