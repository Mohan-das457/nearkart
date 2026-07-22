import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_delivery/core/theme/app_colors.dart';
import 'package:nearkart_delivery/core/state/delivery_provider.dart';
import 'package:nearkart_delivery/widgets/bottom_nav.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            title: const Text('Earnings'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatsRow(provider: provider),
              const SizedBox(height: 16),
              _WeeklyChart(provider: provider),
              const SizedBox(height: 16),
              _TransactionList(provider: provider),
            ],
          ),
          bottomNavigationBar: const DeliveryBottomNav(index: 2),
        );
      },
    );
  }
}

class _StatsRow extends StatelessWidget {
  final DeliveryProvider provider;
  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Today\'s Earnings',
            value: '₹${provider.todayEarnings.toStringAsFixed(0)}',
            icon: Icons.today_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Total Earnings',
            value: '₹${provider.totalEarnings.toStringAsFixed(0)}',
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final DeliveryProvider provider;
  const _WeeklyChart({required this.provider});

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _values = [120.0, 85.0, 200.0, 150.0, 95.0, 220.0, 65.0];

  @override
  Widget build(BuildContext context) {
    final maxVal = _values.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This Week', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_days.length, (i) {
                final ratio = _values[i] / maxVal;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('₹${_values[i].toInt()}',
                        style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400 + i * 60),
                      width: 28,
                      height: 80 * ratio,
                      decoration: BoxDecoration(
                        color: i == 5
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(_days[i], style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final DeliveryProvider provider;
  const _TransactionList({required this.provider});

  @override
  Widget build(BuildContext context) {
    final delivered = provider.history
        .where((o) => o.status.name == 'delivered')
        .toList();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          if (delivered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No transactions yet', style: TextStyle(color: AppColors.textLight)),
            )
          else
            ...delivered.map((o) => ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
                  ),
                  title: Text(o.id, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(o.customerName,
                      style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                  trailing: Text('+₹${o.earnings.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 14)),
                )),
        ],
      ),
    );
  }
}
