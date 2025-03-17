import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_mobile_app/models/four_in_a_row_model.dart';

class FourInARowLimitedScreen extends StatelessWidget {
  const FourInARowLimitedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FourInARowLimitedModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tic-Tac-Toe: 4 in a Row (Limited Pieces)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show game status
            Text(
              model.winner != null
                  ? (model.winner == 'Draw'
                      ? "It's a Draw!"
                      : "Winner: ${model.winner}")
                  : "Current Player: ${model.currentPlayer}",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // 4×4 board
            SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
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
            // Reset button
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
