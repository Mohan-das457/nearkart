import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nearkart_seller/core/models/order_model.dart';
import 'package:nearkart_seller/core/state/orders_provider.dart';
import 'package:nearkart_seller/core/theme/app_colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = ['All', 'Pending', 'Preparing', 'Delivery', 'Done'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SellerOrder> _filter(List<SellerOrder> all, int tab) {
    switch (tab) {
      case 1: return all.where((o) => o.status == OrderStatus.pending).toList();
      case 2: return all.where((o) =>
          o.status == OrderStatus.confirmed ||
          o.status == OrderStatus.preparing).toList();
      case 3: return all.where((o) => o.status == OrderStatus.outForDelivery).toList();
      case 4: return all.where((o) =>
          o.status == OrderStatus.delivered ||
          o.status == OrderStatus.cancelled).toList();
      default: return all;
    }
  }

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
        title: const Text('Orders',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          dividerColor: Colors.transparent,
          labelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: Consumer<OrdersProvider>(
        builder: (context, provider, _) => TabBarView(
          controller: _tabController,
          children: List.generate(_tabs.length, (i) {
            final list = _filter(provider.all, i);
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 56,
                        color: AppColors.textLight.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    const Text('No orders here',
                        style: TextStyle(
                            fontSize: 15, color: AppColors.textLight)),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, j) => _OrderCard(order: list[j]),
            );
          }),
        ),
      ),
    );
  }
}

// ── Order card ────────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final SellerOrder order;
  const _OrderCard({required this.order});

  Color get _color {
    switch (order.status) {
      case OrderStatus.pending:        return AppColors.error;
      case OrderStatus.confirmed:      return AppColors.primary;
      case OrderStatus.preparing:      return AppColors.secondary;
      case OrderStatus.outForDelivery: return const Color(0xFF9C27B0);
      case OrderStatus.delivered:      return AppColors.success;
      case OrderStatus.cancelled:      return AppColors.textLight;
    }
  }

  OrderStatus? get _next {
    switch (order.status) {
      case OrderStatus.pending:        return OrderStatus.confirmed;
      case OrderStatus.confirmed:      return OrderStatus.preparing;
      case OrderStatus.preparing:      return OrderStatus.outForDelivery;
      case OrderStatus.outForDelivery: return OrderStatus.delivered;
      default:                         return null;
    }
  }

  String get _nextLabel {
    switch (order.status) {
      case OrderStatus.pending:        return 'Accept';
      case OrderStatus.confirmed:      return 'Start Preparing';
      case OrderStatus.preparing:      return 'Ready for Pickup';
      case OrderStatus.outForDelivery: return 'Mark Delivered';
      default:                         return '';
    }
  }

  String _timeAgo() {
    final diff = DateTime.now().difference(order.placedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OrdersProvider>();
    final next = _next;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('#${order.id}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(order.statusLabel,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _color)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text('${order.customerName} • ${order.address}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textLight),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹${order.total.toInt()}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                    Text(_timeAgo(),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textLight)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          // Items
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: Column(
              children: order.items
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                                width: 6, height: 6,
                                decoration: const BoxDecoration(
                                    color: AppColors.textLight,
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('${item.name} × ${item.qty}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textDark)),
                            ),
                            Text('₹${(item.price * item.qty).toInt()}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textLight)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          // Payment
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Row(
              children: [
                const Icon(Icons.payment_rounded,
                    size: 14, color: AppColors.textLight),
                const SizedBox(width: 5),
                Text(order.paymentMethod,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          // Actions
          if (next != null || order.status == OrderStatus.pending)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  if (order.status == OrderStatus.pending) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => provider.updateStatus(
                            order.id, OrderStatus.cancelled),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(
                              color:
                                  AppColors.error.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (next != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            provider.updateStatus(order.id, next),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(_nextLabel,
                            style: const TextStyle(fontSize: 13)),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
