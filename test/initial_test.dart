import 'package:dictionary_definitions_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

// Test to ensure github actions working
// TODO (gbrown): remove this test when appropriate
void main() {
  testWidgets('github actions test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('Hello World!'), findsOneWidget);
  });
}
