import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_delivery/core/theme/app_colors.dart';
import 'package:nearkart_delivery/core/state/delivery_provider.dart';
import 'package:nearkart_delivery/core/models/delivery_order_model.dart';
import 'package:nearkart_delivery/widgets/bottom_nav.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, provider, _) {
        final orders = provider.history;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            title: const Text('Delivery History'),
            automaticallyImplyLeading: false,
          ),
          body: orders.isEmpty
              ? const Center(
                  child: Text('No deliveries yet', style: TextStyle(color: AppColors.textLight)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, i) => _HistoryCard(order: orders[i]),
                ),
          bottomNavigationBar: const DeliveryBottomNav(index: 1),
        );
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final DeliveryOrder order;
  const _HistoryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == DeliveryStatus.delivered;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: (isDelivered ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
              child: Icon(
                isDelivered ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: isDelivered ? AppColors.success : AppColors.error,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('₹${order.earnings.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDelivered ? AppColors.primary : AppColors.textLight,
                          )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(order.deliveryAddress,
                      style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(order.statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDelivered ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w600,
                          )),
                      const Spacer(),
                      Text('${order.distance} km',
                          style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
