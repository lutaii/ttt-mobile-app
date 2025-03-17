import 'package:flutter/material.dart';

class FourInARowLimitedModel extends ChangeNotifier {
  // 16 cells for a 4×4 board
  late List<String> board;

  // Keep track of positions each player has placed (in order)
  final List<int> _xPositions = [];
  final List<int> _oPositions = [];

  late String currentPlayer;
  String? winner;

  FourInARowLimitedModel() {
    resetGame();
  }

  /// Reset the board and state for a new game
  void resetGame() {
    board = List.filled(16, '');
    _xPositions.clear();
    _oPositions.clear();
    currentPlayer = 'X';
    winner = null;
    notifyListeners();
  }

  /// Place a piece on the board. If a player already has 4 pieces,
  /// remove the oldest one before placing a new piece.
  void makeMove(int index) {
    // Only place a marker if the cell is empty and there's no winner yet
    if (board[index] == '' && winner == null) {
      board[index] = currentPlayer;

      // Track positions for the current player
      if (currentPlayer == 'X') {
        _xPositions.add(index);
        // If player X has more than 4 pieces, remove the oldest one
        if (_xPositions.length > 4) {
          final removedIndex = _xPositions.removeAt(0);
          board[removedIndex] = '';
        }
      } else {
        _oPositions.add(index);
        // If player O has more than 4 pieces, remove the oldest one
        if (_oPositions.length > 4) {
          final removedIndex = _oPositions.removeAt(0);
          board[removedIndex] = '';
        }
      }

      // Check for a winner or a draw
      if (_checkWinner(currentPlayer)) {
        winner = currentPlayer;
      } else if (!board.contains('')) {
        winner = 'Draw';
      } else {
        // Switch turns
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      }

      notifyListeners();
    }
  }

  /// Checks if the given player has formed 4 in a row
  bool _checkWinner(String player) {
    // All possible 4-in-a-row combos on a 4×4 board
    // (4 in a row horizontally, vertically, or diagonally)
    final winningCombinations = [
      // Rows
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 13, 14, 15],
      // Columns
      [0, 4, 8, 12],
      [1, 5, 9, 13],
      [2, 6, 10, 14],
      [3, 7, 11, 15],
      // Diagonals
      [0, 5, 10, 15],
      [3, 6, 9, 12],
    ];

    for (var combo in winningCombinations) {
      if (board[combo[0]] == player &&
          board[combo[1]] == player &&
          board[combo[2]] == player &&
          board[combo[3]] == player) {
        return true;
      }
    }
    return false;
  }
}
