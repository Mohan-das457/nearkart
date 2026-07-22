import 'package:go_router/go_router.dart';
import 'package:nearkart_admin/screens/login/login_screen.dart';
import 'package:nearkart_admin/screens/dashboard/dashboard_screen.dart';
import 'package:nearkart_admin/screens/orders/orders_screen.dart';
import 'package:nearkart_admin/screens/stores/stores_screen.dart';
import 'package:nearkart_admin/screens/agents/agents_screen.dart';
import 'package:nearkart_admin/screens/users/users_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',          builder: (_, s) => const LoginScreen()),
    GoRoute(path: '/dashboard', builder: (_, s) => const DashboardScreen()),
    GoRoute(path: '/orders',    builder: (_, s) => const OrdersScreen()),
    GoRoute(path: '/stores',    builder: (_, s) => const StoresScreen()),
    GoRoute(path: '/agents',    builder: (_, s) => const AgentsScreen()),
    GoRoute(path: '/users',     builder: (_, s) => const UsersScreen()),
  ],
);
