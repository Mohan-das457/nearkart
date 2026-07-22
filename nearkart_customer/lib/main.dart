import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_customer/core/routes/app_routes.dart';
import 'package:nearkart_customer/core/state/app_state.dart';
import 'package:nearkart_customer/core/state/cart_provider.dart';
import 'package:nearkart_customer/core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const NearKartApp(),
    ),
  );
}

class NearKartApp extends StatelessWidget {
  const NearKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NearKart',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
    );
  }
}
