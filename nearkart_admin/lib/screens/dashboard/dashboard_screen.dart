import 'package:flutter/material.dart';
import 'package:nearkart_admin/core/theme/app_colors.dart';
import 'package:nearkart_admin/core/models/dummy_data.dart';
import 'package:nearkart_admin/screens/dashboard/admin_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Dashboard',
      selectedIndex: 0,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _StatsGrid(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _RecentOrders()),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _RevenueChart()),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final _stats = const [
    (Icons.receipt_long, 'Total Orders',   '128',    AppColors.primary),
    (Icons.pending_outlined, 'Pending',    '14',     AppColors.warning),
    (Icons.store,        'Stores',         '12',     Colors.teal),
    (Icons.delivery_dining, 'Agents',      '8',      Colors.indigo),
    (Icons.people,       'Users',          '340',    Colors.pink),
    (Icons.currency_rupee, 'Revenue',      '₹48,250',AppColors.success),
  ];

  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 900 ? 6 : constraints.maxWidth > 600 ? 3 : 2;
      return Wrap(
        spacing: 16, runSpacing: 16,
        children: _stats.map((s) {
          final (icon, label, value, color) = s;
          final w = (constraints.maxWidth - (cols - 1) * 16) / cols;
          return SizedBox(
            width: w,
            child: _StatCard(icon: icon, label: label, value: value, color: color),
          );
        }).toList(),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrders extends StatelessWidget {
  const _RecentOrders();

  Color _statusColor(String s) {
    switch (s) {
      case 'pending':          return AppColors.warning;
      case 'preparing':        return Colors.blue;
      case 'out_for_delivery': return AppColors.primary;
      case 'delivered':        return AppColors.success;
      case 'cancelled':        return AppColors.error;
      default:                 return AppColors.textLight;
    }
  }

  String _statusLabel(String s) => s.replaceAll('_', ' ').split(' ')
      .map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text('Recent Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1.2),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(color: AppColors.background),
                children: ['Order ID', 'Customer', 'Store', 'Total', 'Status']
                    .map((h) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(h,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                        ))
                    .toList(),
              ),
              ...DummyData.orders.map((o) => TableRow(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.background))),
                    children: [
                      _cell(o.id, bold: true),
                      _cell(o.customer),
                      _cell(o.store),
                      _cell('₹${o.total.toStringAsFixed(0)}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(o.status).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(_statusLabel(o.status),
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _statusColor(o.status))),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(text,
            style: TextStyle(
                fontSize: 13,
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal)),
      );
}

class _RevenueChart extends StatelessWidget {
  const _RevenueChart();

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _values = [3200.0, 4100.0, 2800.0, 5600.0, 4800.0, 7200.0, 3900.0];

  @override
  Widget build(BuildContext context) {
    final maxVal = _values.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Revenue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_days.length, (i) {
                final ratio = _values[i] / maxVal;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('₹${(_values[i] / 1000).toStringAsFixed(1)}k',
                        style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
                    const SizedBox(height: 4),
                    Container(
                      width: 24,
                      height: 120 * ratio,
                      decoration: BoxDecoration(
                        color: i == 5 ? AppColors.primary : AppColors.primary.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(_days[i], style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
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
