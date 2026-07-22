import 'package:go_router/go_router.dart';
import 'package:nearkart_customer/screens/splash/splash_screen.dart';
import 'package:nearkart_customer/screens/onboarding/onboarding_screen.dart';
import 'package:nearkart_customer/screens/auth/login_screen.dart';
import 'package:nearkart_customer/screens/auth/otp_screen.dart';
import 'package:nearkart_customer/screens/location/location_screen.dart';
import 'package:nearkart_customer/screens/home/home_screen.dart';
import 'package:nearkart_customer/screens/search/search_screen.dart';
import 'package:nearkart_customer/screens/categories/categories_screen.dart';
import 'package:nearkart_customer/screens/categories/category_products_screen.dart';
import 'package:nearkart_customer/screens/shop/shop_screen.dart';
import 'package:nearkart_customer/screens/product/product_screen.dart';
import 'package:nearkart_customer/screens/cart/cart_screen.dart';
import 'package:nearkart_customer/screens/checkout/checkout_screen.dart';
import 'package:nearkart_customer/screens/tracking/tracking_screen.dart';
import 'package:nearkart_customer/screens/profile/profile_screen.dart';
import 'package:nearkart_customer/screens/wishlist/wishlist_screen.dart';
import 'package:nearkart_customer/screens/orders/orders_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phone = state.extra;
        if (phone is! String || phone.length < 4) {
          return const LoginScreen();
        }
        return OtpScreen(phone: phone);
      },
    ),
    GoRoute(
      path: '/location',
      builder: (context, state) => const LocationScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/categories/:id',
      builder: (context, state) =>
          CategoryProductsScreen(categoryId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/shop/:id',
      builder: (context, state) =>
          ShopScreen(storeId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) =>
          ProductScreen(productId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/tracking',
      builder: (context, state) => const TrackingScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(path: '/orders', builder: (context, state) => const OrdersScreen()),
  ],
);
