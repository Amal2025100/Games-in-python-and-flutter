import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_ai/main.dart';

void main() {
  testWidgets("Tic Tac Toe App Loads", (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(TicTacToeApp());

    // Check title exists
    expect(find.text("Tic Tac Toe vs AI"), findsOneWidget);

    // Check restart button exists
    expect(find.text("Restart Game"), findsOneWidget);
  });
}
