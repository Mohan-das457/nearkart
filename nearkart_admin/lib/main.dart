import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_admin/core/routes/app_routes.dart';
import 'package:nearkart_admin/core/state/admin_provider.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminProvider(),
      child: MaterialApp.router(
        title: 'NearKart Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF4527A0),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
