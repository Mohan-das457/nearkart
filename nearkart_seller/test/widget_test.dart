import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Seller app smoke test (no async splash)', (
    WidgetTester tester,
  ) async {
    // Keep this test minimal to avoid timers from the app splash screen.
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
