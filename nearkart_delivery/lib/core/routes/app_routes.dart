import 'package:go_router/go_router.dart';
import 'package:nearkart_delivery/screens/splash/splash_screen.dart';
import 'package:nearkart_delivery/screens/auth/auth_screen.dart';
import 'package:nearkart_delivery/screens/home/home_screen.dart';
import 'package:nearkart_delivery/screens/order_detail/order_detail_screen.dart';
import 'package:nearkart_delivery/screens/history/history_screen.dart';
import 'package:nearkart_delivery/screens/earnings/earnings_screen.dart';
import 'package:nearkart_delivery/screens/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',        builder: (_, s) => const SplashScreen()),
    GoRoute(path: '/auth',    builder: (_, s) => const AuthScreen()),
    GoRoute(path: '/home',    builder: (_, s) => const HomeScreen()),
    GoRoute(path: '/history', builder: (_, s) => const HistoryScreen()),
    GoRoute(path: '/earnings',builder: (_, s) => const EarningsScreen()),
    GoRoute(path: '/profile', builder: (_, s) => const ProfileScreen()),
    GoRoute(
      path: '/order/:id',
      builder: (_, state) => OrderDetailScreen(orderId: state.pathParameters['id']!),
    ),
  ],
);
