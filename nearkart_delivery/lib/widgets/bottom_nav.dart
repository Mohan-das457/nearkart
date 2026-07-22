import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearkart_delivery/core/theme/app_colors.dart';

class DeliveryBottomNav extends StatelessWidget {
  final int index;
  const DeliveryBottomNav({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight,
      onTap: (i) {
        switch (i) {
          case 0: context.go('/home'); break;
          case 1: context.go('/history'); break;
          case 2: context.go('/earnings'); break;
          case 3: context.go('/profile'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Earnings'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
