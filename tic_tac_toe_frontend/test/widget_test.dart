import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('Shows TicTacToeScreen game UI', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    expect(find.text('Tic Tac Toe'), findsOneWidget);

    // Initial game status
    expect(find.text('Turn: X'), findsOneWidget);

    // Controls
    expect(find.text('New game'), findsOneWidget);
    expect(find.text('Reset score'), findsOneWidget);

    // Score header labels
    expect(find.text('X'), findsOneWidget);
    expect(find.text('O'), findsOneWidget);
    expect(find.text('Draws'), findsOneWidget);
  });
}
