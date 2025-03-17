import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                if (lobbyProvider.message != null)
                  Text(lobbyProvider.message!, style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
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
                  onPressed: () {
                    final code = joinController.text.trim();
                    if (code.isNotEmpty) {
                      lobbyProvider.joinLobby(code);
                    }
                  },
                  child: Text('Join Lobby'),
                ),
                if (lobbyProvider.lobbyCode != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Your Lobby Code: ${lobbyProvider.lobbyCode}'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
