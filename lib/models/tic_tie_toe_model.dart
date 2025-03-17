import 'package:flutter/material.dart';

class TicTacToeModel extends ChangeNotifier {
  late List<String> board;
  late String currentPlayer;
  String? winner;

  TicTacToeModel() {
    resetGame();
  }

  void resetGame() {
    board = List.filled(9, '');
    currentPlayer = 'X';
    winner = null;
    notifyListeners();
  }

  void makeMove(int index) {
    if (board[index] == '' && winner == null) {
      board[index] = currentPlayer;

      if (_checkWinner(currentPlayer)) {
        winner = currentPlayer;
      } else if (!board.contains('')) {
        winner = 'Draw';
      } else {
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      }
      notifyListeners();
    }
  }

  bool _checkWinner(String player) {
    List<List<int>> winningIndices = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combo in winningIndices) {
      if (board[combo[0]] == player &&
          board[combo[1]] == player &&
          board[combo[2]] == player) {
        return true;
      }
    }
    return false;
  }
}
