import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_delivery/core/routes/app_routes.dart';
import 'package:nearkart_delivery/core/state/delivery_provider.dart';

void main() {
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeliveryProvider(),
      child: MaterialApp.router(
        title: 'NearKart Delivery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFE65100),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
