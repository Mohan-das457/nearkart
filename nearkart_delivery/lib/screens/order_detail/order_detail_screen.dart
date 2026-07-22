import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_delivery/core/theme/app_colors.dart';
import 'package:nearkart_delivery/core/state/delivery_provider.dart';
import 'package:nearkart_delivery/core/models/delivery_order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, provider, _) {
        final order = provider.all.firstWhere((o) => o.id == orderId);
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            title: Text('Order ${order.id}'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MapPlaceholder(order: order),
              const SizedBox(height: 16),
              _StatusStepper(status: order.status),
              const SizedBox(height: 16),
              _AddressCard(order: order),
              const SizedBox(height: 12),
              _ItemsCard(order: order),
              const SizedBox(height: 12),
              _CustomerCard(order: order),
              const SizedBox(height: 80),
            ],
          ),
          bottomSheet: _ActionBar(order: order, provider: provider),
        );
      },
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final DeliveryOrder order;
  const _MapPlaceholder({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(
        painter: _MapPainter(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, size: 40, color: AppColors.primary),
              const SizedBox(height: 6),
              Text('${order.distance} km away',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final routePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width * 0.8, size.height * 0.4);
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _StatusStepper extends StatelessWidget {
  final DeliveryStatus status;
  const _StatusStepper({required this.status});

  static const _steps = [
    (DeliveryStatus.assigned, Icons.assignment_outlined, 'Assigned'),
    (DeliveryStatus.pickedUp, Icons.store_outlined, 'Picked Up'),
    (DeliveryStatus.onTheWay, Icons.delivery_dining, 'On the Way'),
    (DeliveryStatus.delivered, Icons.check_circle_outline, 'Delivered'),
  ];

  int get _currentIndex {
    switch (status) {
      case DeliveryStatus.assigned: return 0;
      case DeliveryStatus.pickedUp: return 1;
      case DeliveryStatus.onTheWay: return 2;
      case DeliveryStatus.delivered: return 3;
      case DeliveryStatus.failed: return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == DeliveryStatus.failed) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error),
            SizedBox(width: 8),
            Text('Delivery Failed', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: List.generate(_steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              final stepIndex = i ~/ 2;
              final done = stepIndex < _currentIndex;
              return Expanded(
                child: Container(
                  height: 2,
                  color: done ? AppColors.primary : AppColors.background,
                ),
              );
            }
            final stepIndex = i ~/ 2;
            final done = stepIndex <= _currentIndex;
            final (_, icon, label) = _steps[stepIndex];
            return Column(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: done ? AppColors.primary : AppColors.background,
                  child: Icon(icon, size: 16, color: done ? AppColors.white : AppColors.textLight),
                ),
                const SizedBox(height: 4),
                Text(label,
                    style: TextStyle(
                      fontSize: 10,
                      color: done ? AppColors.primary : AppColors.textLight,
                      fontWeight: done ? FontWeight.bold : FontWeight.normal,
                    )),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final DeliveryOrder order;
  const _AddressCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _AddressRow(
              icon: Icons.store_outlined,
              color: Colors.blue,
              title: 'Pickup',
              address: order.pickupAddress,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: SizedBox(height: 16, child: VerticalDivider(width: 1)),
            ),
            _AddressRow(
              icon: Icons.location_on_outlined,
              color: AppColors.primary,
              title: 'Deliver to',
              address: order.deliveryAddress,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, address;
  const _AddressRow({required this.icon, required this.color, required this.title, required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
              Text(address, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final DeliveryOrder order;
  const _ItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 6, color: AppColors.textLight),
                      const SizedBox(width: 8),
                      Text(item, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                )),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.paymentMethod,
                    style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
                Text('₹${order.earnings.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final DeliveryOrder order;
  const _CustomerCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(Icons.person_outline, color: AppColors.textLight),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(order.customerPhone, style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call_outlined, color: AppColors.primary),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final DeliveryOrder order;
  final DeliveryProvider provider;
  const _ActionBar({required this.order, required this.provider});

  (String, DeliveryStatus)? get _nextAction {
    switch (order.status) {
      case DeliveryStatus.assigned: return ('Picked Up from Store', DeliveryStatus.pickedUp);
      case DeliveryStatus.pickedUp: return ('On the Way', DeliveryStatus.onTheWay);
      case DeliveryStatus.onTheWay: return ('Mark Delivered', DeliveryStatus.delivered);
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final action = _nextAction;
    if (action == null) return const SizedBox.shrink();
    final (label, nextStatus) = action;
    final isDeliver = nextStatus == DeliveryStatus.delivered;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        children: [
          if (!isDeliver)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  provider.updateStatus(order.id, DeliveryStatus.failed);
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Failed'),
              ),
            ),
          if (!isDeliver) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                provider.updateStatus(order.id, nextStatus);
                if (isDeliver) context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDeliver ? AppColors.success : AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
