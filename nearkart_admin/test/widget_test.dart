import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_admin/core/state/admin_provider.dart';
import 'package:nearkart_admin/main.dart';

void main() {
  testWidgets('Admin app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AdminProvider(),
        child: const AdminApp(),
      ),
    );

    // Verify the app renders without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
