import 'package:flutter_test/flutter_test.dart';
import 'package:nearkart_customer/main.dart';

void main() {
  testWidgets('NearKartApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NearKartApp());
    expect(find.byType(NearKartApp), findsOneWidget);
  });
}
