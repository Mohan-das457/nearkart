import 'package:flutter/material.dart';
import 'package:nearkart_admin/core/theme/app_colors.dart';
import 'package:nearkart_admin/core/models/dummy_data.dart';
import 'package:nearkart_admin/screens/dashboard/admin_scaffold.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _filter = 'all';

  static const _tabs = ['all', 'pending', 'preparing', 'out_for_delivery', 'delivered', 'cancelled'];

  String _label(String s) => s == 'all' ? 'All' :
      s.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');

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

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'all'
        ? DummyData.orders
        : DummyData.orders.where((o) => o.status == _filter).toList();

    return AdminScaffold(
      title: 'Orders',
      selectedIndex: 1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tabs.map((t) {
                  final selected = t == _filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_label(t)),
                      selected: selected,
                      onSelected: (_) => setState(() => _filter = t),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                          color: selected ? AppColors.white : AppColors.textDark,
                          fontSize: 13),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No orders', style: TextStyle(color: AppColors.textLight)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final o = filtered[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(o.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _statusColor(o.status).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(_label(o.status),
                                            style: TextStyle(fontSize: 11, color: _statusColor(o.status), fontWeight: FontWeight.w600)),
                                      ),
                                    ]),
                                    const SizedBox(height: 6),
                                    Text('${o.customer} · ${o.store}',
                                        style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
                                    Text('${o.paymentMethod} · ₹${o.total.toStringAsFixed(0)}',
                                        style: const TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                              if (o.status == 'pending')
                                Row(children: [
                                  _ActionBtn(label: 'Confirm', color: AppColors.success, onTap: () {}),
                                  const SizedBox(width: 8),
                                  _ActionBtn(label: 'Cancel', color: AppColors.error, onTap: () {}),
                                ]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
