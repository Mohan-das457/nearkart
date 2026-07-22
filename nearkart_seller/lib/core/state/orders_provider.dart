import 'package:flutter/material.dart';
import 'package:nearkart_seller/core/models/order_model.dart';
import 'package:nearkart_seller/core/models/dummy_data.dart';

class OrdersProvider extends ChangeNotifier {
  final List<SellerOrder> _orders = List.from(SellerDummyData.orders);

  List<SellerOrder> get all => List.unmodifiable(_orders);

  List<SellerOrder> byStatus(OrderStatus status) =>
      _orders.where((o) => o.status == status).toList();

  int get pendingCount =>
      _orders.where((o) => o.status == OrderStatus.pending).length;

  double get todayEarnings => _orders
      .where((o) =>
          o.status == OrderStatus.delivered &&
          o.placedAt.day == DateTime.now().day)
      .fold(0, (sum, o) => sum + o.total);

  double get totalEarnings => _orders
      .where((o) => o.status == OrderStatus.delivered)
      .fold(0, (sum, o) => sum + o.total);

  void updateStatus(String orderId, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx < 0) return;
    _orders[idx] = SellerOrder(
      id: _orders[idx].id,
      customerName: _orders[idx].customerName,
      address: _orders[idx].address,
      items: _orders[idx].items,
      total: _orders[idx].total,
      status: status,
      placedAt: _orders[idx].placedAt,
      paymentMethod: _orders[idx].paymentMethod,
    );
    notifyListeners();
  }
}
