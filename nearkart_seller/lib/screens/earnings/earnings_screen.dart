import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_seller/core/models/order_model.dart';
import 'package:nearkart_seller/core/state/orders_provider.dart';
import 'package:nearkart_seller/core/theme/app_colors.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  static const _weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _weekValues = [320.0, 540.0, 210.0, 780.0, 430.0, 920.0, 660.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark, size: 20),
          onPressed: () => context.go('/dashboard'),
        ),
        title: const Text('Earnings',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
      ),
      body: Consumer<OrdersProvider>(
        builder: (context, orders, _) {
          final delivered = orders.all
              .where((o) => o.status == OrderStatus.delivered)
              .toList();
          final total = delivered.fold<double>(0, (s, o) => s + o.total);
          final today = delivered
              .where((o) => o.placedAt.day == DateTime.now().day)
              .fold<double>(0, (s, o) => s + o.total);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary cards
              Row(
                children: [
                  _EarnCard(
                      label: "Today",
                      value: '₹${today.toInt()}',
                      icon: Icons.today_rounded,
                      color: AppColors.primary),
                  const SizedBox(width: 12),
                  _EarnCard(
                      label: 'Total',
                      value: '₹${total.toInt()}',
                      icon: Icons.account_balance_wallet_rounded,
                      color: AppColors.success),
                ],
              ),
              const SizedBox(height: 16),
              // Weekly bar chart
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('This Week',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 140,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(_weekLabels.length, (i) {
                          final max = _weekValues.reduce(
                              (a, b) => a > b ? a : b);
                          final h = (_weekValues[i] / max) * 110;
                          final isToday = i == DateTime.now().weekday - 1;
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('₹${_weekValues[i].toInt()}',
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: isToday
                                            ? AppColors.primary
                                            : AppColors.textLight,
                                        fontWeight: isToday
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                const SizedBox(height: 4),
                                Container(
                                  height: h,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? AppColors.primary
                                        : AppColors.primary
                                            .withValues(alpha: 0.2),
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6)),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(_weekLabels[i],
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: isToday
                                            ? AppColors.primary
                                            : AppColors.textLight,
                                        fontWeight: isToday
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Transactions
              const Text('Recent Transactions',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 10),
              ...delivered.map((o) => _TransactionTile(order: o)),
              if (delivered.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('No transactions yet',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight
                                .withValues(alpha: 0.7))),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EarnCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _EarnCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text(label,
                    style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final SellerOrder order;
  const _TransactionTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_downward_rounded,
                color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('#${order.id}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                Text(order.customerName,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          Text('+₹${order.total.toInt()}',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success)),
        ],
      ),
    );
  }
}
