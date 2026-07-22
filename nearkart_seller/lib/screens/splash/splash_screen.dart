import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearkart_seller/core/theme/app_colors.dart';

class SellerSplashScreen extends StatefulWidget {
  const SellerSplashScreen({super.key});

  @override
  State<SellerSplashScreen> createState() => _SellerSplashScreenState();
}

class _SellerSplashScreenState extends State<SellerSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Future.delayed(const Duration(seconds: 3),
        () { if (mounted) context.go('/login'); });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.storefront_rounded,
                    size: 60, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text('NearKart Seller',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 1.2)),
              const SizedBox(height: 8),
              const Text('Manage your store, grow your business',
                  style: TextStyle(fontSize: 14, color: AppColors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
