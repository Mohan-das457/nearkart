import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_delivery/core/theme/app_colors.dart';
import 'package:nearkart_delivery/core/state/delivery_provider.dart';
import 'package:nearkart_delivery/core/models/delivery_order_model.dart';
import 'package:nearkart_delivery/widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            title: const Text('NearKart Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    Text(
                      provider.isOnline ? 'Online' : 'Offline',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                    Switch(
                      value: provider.isOnline,
                      onChanged: (_) => provider.toggleOnline(),
                      activeThumbColor: AppColors.white,
                      activeTrackColor: AppColors.success,
                      inactiveThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.textLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              _StatsBar(provider: provider),
              Expanded(
                child: provider.active.isEmpty
                    ? _EmptyState(isOnline: provider.isOnline)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.active.length,
                        itemBuilder: (context, i) =>
                            _OrderCard(order: provider.active[i]),
                      ),
              ),
            ],
          ),
          bottomNavigationBar: const DeliveryBottomNav(index: 0),
        );
      },
    );
  }
}

class _StatsBar extends StatelessWidget {
  final DeliveryProvider provider;
  const _StatsBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Stat(label: 'Today', value: '${provider.todayDeliveries} orders'),
          _divider(),
          _Stat(label: 'Earned', value: '₹${provider.todayEarnings.toStringAsFixed(0)}'),
          _divider(),
          _Stat(label: 'Distance', value: '${provider.totalDistance.toStringAsFixed(1)} km'),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 32, color: AppColors.background);
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isOnline;
  const _EmptyState({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isOnline ? Icons.inbox_outlined : Icons.wifi_off_rounded,
              size: 64, color: AppColors.textLight),
          const SizedBox(height: 12),
          Text(
            isOnline ? 'No active orders' : 'You are offline',
            style: const TextStyle(fontSize: 16, color: AppColors.textLight),
          ),
          if (!isOnline) ...[
            const SizedBox(height: 6),
            const Text('Go online to receive orders', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
          ],
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final DeliveryOrder order;
  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case DeliveryStatus.assigned: return AppColors.secondary;
      case DeliveryStatus.pickedUp: return Colors.blue;
      case DeliveryStatus.onTheWay: return AppColors.primary;
      default: return AppColors.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/order/${order.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(order.statusLabel,
                        style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _AddressRow(icon: Icons.store_outlined, label: order.pickupAddress),
              const SizedBox(height: 6),
              _AddressRow(icon: Icons.location_on_outlined, label: order.deliveryAddress),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                      style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                  Text('${order.distance} km', style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                  Text('₹${order.earnings.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AddressRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}


