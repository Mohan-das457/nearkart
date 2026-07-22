import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearkart_delivery/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _a = CurvedAnimation(parent: _c, curve: Curves.easeIn);
    _c.forward();
    Future.delayed(const Duration(seconds: 3),
        () { if (mounted) context.go('/auth'); });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FadeTransition(
        opacity: _a,
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
                child: const Icon(Icons.delivery_dining_rounded,
                    size: 60, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text('NearKart Delivery',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 1.2)),
              const SizedBox(height: 8),
              const Text('Deliver fast. Earn more.',
                  style: TextStyle(fontSize: 14, color: AppColors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
