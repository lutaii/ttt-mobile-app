import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lobby_provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Consumer<LobbyProvider>(
        builder: (context, lobbyProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Lobby Waiting Room'),
              leading: IconButton(
                onPressed: () async {
                  Provider.of<LobbyProvider>(
                    context,
                    listen: false,
                  ).disconnect();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (lobbyProvider.lobbyCode != null)
                    Text(
                      'Lobby Code: ${lobbyProvider.lobbyCode}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 30),
                  Text(
                    lobbyProvider.message ?? '',
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
