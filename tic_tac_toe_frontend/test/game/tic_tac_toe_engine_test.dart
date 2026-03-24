import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/game/tic_tac_toe_engine.dart';

void main() {
  group('TicTacToeEngine.applyMove', () {
    test('initial state: board empty, X to play', () {
      final state = TicTacToeState.initial();
      expect(state.board.length, 9);
      expect(state.board.where((c) => c != Cell.empty), isEmpty);
      expect(state.currentPlayer, Player.x);
      expect(state.status, GameStatus.inProgress);
      expect(state.winner, isNull);
      expect(state.winningLine, isNull);
    });

    test('rejects move when index out of range', () {
      final state = TicTacToeState.initial();
      final outcome = TicTacToeEngine.applyMove(state: state, index: 9);
      expect(outcome.accepted, isFalse);
      expect(outcome.rejectionReason, 'index_out_of_range');
      expect(outcome.state.board, state.board);
    });

    test('accepts a valid move and switches player', () {
      final state = TicTacToeState.initial();
      final outcome = TicTacToeEngine.applyMove(state: state, index: 0);

      expect(outcome.accepted, isTrue);
      expect(outcome.state.board[0], Cell.x);
      expect(outcome.state.currentPlayer, Player.o);
      expect(outcome.state.status, GameStatus.inProgress);
      expect(outcome.state.winner, isNull);
      expect(outcome.state.winningLine, isNull);
    });

    test('rejects move on occupied cell', () {
      final state1 = TicTacToeState.initial();
      final s2 = TicTacToeEngine.applyMove(state: state1, index: 0).state;

      final outcome = TicTacToeEngine.applyMove(state: s2, index: 0);
      expect(outcome.accepted, isFalse);
      expect(outcome.rejectionReason, 'cell_already_occupied');
      expect(outcome.state.board[0], Cell.x);
    });

    test('detects win and returns winning line indices (row 0)', () {
      // X:0, O:3, X:1, O:4, X:2 => X wins on [0,1,2]
      var state = TicTacToeState.initial();

      state = TicTacToeEngine.applyMove(state: state, index: 0).state; // X
      state = TicTacToeEngine.applyMove(state: state, index: 3).state; // O
      state = TicTacToeEngine.applyMove(state: state, index: 1).state; // X
      state = TicTacToeEngine.applyMove(state: state, index: 4).state; // O

      final outcome = TicTacToeEngine.applyMove(state: state, index: 2); // X wins
      expect(outcome.accepted, isTrue);
      expect(outcome.state.status, GameStatus.won);
      expect(outcome.state.winner, Player.x);
      expect(outcome.state.winningLine, <int>[0, 1, 2]);
    });

    test('detects win and returns winning line indices (diagonal)', () {
      // X:0, O:1, X:4, O:2, X:8 => X wins on [0,4,8]
      var state = TicTacToeState.initial();

      state = TicTacToeEngine.applyMove(state: state, index: 0).state; // X
      state = TicTacToeEngine.applyMove(state: state, index: 1).state; // O
      state = TicTacToeEngine.applyMove(state: state, index: 4).state; // X
      state = TicTacToeEngine.applyMove(state: state, index: 2).state; // O

      final outcome = TicTacToeEngine.applyMove(state: state, index: 8); // X wins
      expect(outcome.state.status, GameStatus.won);
      expect(outcome.state.winner, Player.x);
      expect(outcome.state.winningLine, <int>[0, 4, 8]);
    });

    test('detects draw with no winning line', () {
      // A known draw sequence:
      // X O X
      // X X O
      // O X O
      final moves = <int>[0, 1, 2, 5, 3, 8, 6, 4, 7];

      var state = TicTacToeState.initial();
      for (var i = 0; i < moves.length; i++) {
        final outcome = TicTacToeEngine.applyMove(state: state, index: moves[i]);
        expect(outcome.accepted, isTrue);
        state = outcome.state;
      }

      expect(state.status, GameStatus.draw);
      expect(state.winner, isNull);
      expect(state.winningLine, isNull);
      expect(state.isGameOver, isTrue);
    });

    test('rejects further moves after game is won', () {
      // Win quickly for X on top row.
      var state = TicTacToeState.initial();
      state = TicTacToeEngine.applyMove(state: state, index: 0).state; // X
      state = TicTacToeEngine.applyMove(state: state, index: 3).state; // O
      state = TicTacToeEngine.applyMove(state: state, index: 1).state; // X
      state = TicTacToeEngine.applyMove(state: state, index: 4).state; // O
      state = TicTacToeEngine.applyMove(state: state, index: 2).state; // X wins

      final outcome = TicTacToeEngine.applyMove(state: state, index: 5);
      expect(outcome.accepted, isFalse);
      expect(outcome.rejectionReason, 'game_already_over');
    });
  });
}
