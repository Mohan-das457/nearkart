import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_delivery/core/state/delivery_provider.dart';
import 'package:nearkart_delivery/main.dart';

void main() {
  testWidgets('Delivery app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => DeliveryProvider(),
        child: const DeliveryApp(),
      ),
    );

    // Verify the app renders without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
