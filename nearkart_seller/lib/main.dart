import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_seller/core/routes/app_routes.dart';
import 'package:nearkart_seller/core/state/orders_provider.dart';
import 'package:nearkart_seller/core/theme/app_colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => OrdersProvider(),
      child: const SellerApp(),
    ),
  );
}

class SellerApp extends StatelessWidget {
  const SellerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NearKart Seller',
      debugShowCheckedModeBanner: false,
      routerConfig: sellerRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
    );
  }
}
