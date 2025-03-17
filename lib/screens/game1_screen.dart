import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_mobile_app/models/tic_tie_toe_model.dart';

class Game1Screen extends StatelessWidget {
  const Game1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TicTacToeModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display current game status: current player's turn, winner, or draw.
            Text(
              model.winner != null
                  ? (model.winner == 'Draw'
                      ? "It's a Draw!"
                      : "Winner: ${model.winner}")
                  : "Current Player: ${model.currentPlayer}",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Game board grid
            SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: model.board.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => model.makeMove(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          model.board[index],
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Reset button to start a new game
            ElevatedButton(
              onPressed: () => model.resetGame(),
              child: Text("Reset Game"),
            ),
          ],
        ),
      ),
    );
  }
}
