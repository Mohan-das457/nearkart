import 'package:go_router/go_router.dart';
import 'package:nearkart_seller/screens/splash/splash_screen.dart';
import 'package:nearkart_seller/screens/auth/login_screen.dart';
import 'package:nearkart_seller/screens/auth/otp_screen.dart';
import 'package:nearkart_seller/screens/dashboard/dashboard_screen.dart';
import 'package:nearkart_seller/screens/orders/orders_screen.dart';
import 'package:nearkart_seller/screens/products/products_screen.dart';
import 'package:nearkart_seller/screens/inventory/inventory_screen.dart';
import 'package:nearkart_seller/screens/earnings/earnings_screen.dart';
import 'package:nearkart_seller/screens/profile/profile_screen.dart';

final sellerRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',          builder: (c, s) => const SellerSplashScreen()),
    GoRoute(path: '/login',     builder: (c, s) => const SellerLoginScreen()),
    GoRoute(path: '/otp',       builder: (c, s) => SellerOtpScreen(phone: s.extra as String)),
    GoRoute(path: '/dashboard', builder: (c, s) => const DashboardScreen()),
    GoRoute(path: '/orders',    builder: (c, s) => const OrdersScreen()),
    GoRoute(path: '/products',  builder: (c, s) => const ProductsScreen()),
    GoRoute(path: '/inventory', builder: (c, s) => const InventoryScreen()),
    GoRoute(path: '/earnings',  builder: (c, s) => const EarningsScreen()),
    GoRoute(path: '/profile',   builder: (c, s) => const SellerProfileScreen()),
  ],
);
