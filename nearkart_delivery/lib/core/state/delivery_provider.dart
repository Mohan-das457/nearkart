import 'package:flutter/material.dart';
import 'package:nearkart_delivery/core/models/delivery_order_model.dart';
import 'package:nearkart_delivery/core/models/dummy_data.dart';

class DeliveryProvider extends ChangeNotifier {
  final List<DeliveryOrder> _orders = List.from(DeliveryDummyData.orders);
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  List<DeliveryOrder> get all => List.unmodifiable(_orders);

  List<DeliveryOrder> get active => _orders
      .where((o) =>
          o.status == DeliveryStatus.assigned ||
          o.status == DeliveryStatus.pickedUp ||
          o.status == DeliveryStatus.onTheWay)
      .toList();

  List<DeliveryOrder> get history => _orders
      .where((o) =>
          o.status == DeliveryStatus.delivered ||
          o.status == DeliveryStatus.failed)
      .toList();

  int get todayDeliveries => _orders
      .where((o) =>
          o.status == DeliveryStatus.delivered &&
          o.assignedAt.day == DateTime.now().day)
      .length;

  double get todayEarnings => _orders
      .where((o) =>
          o.status == DeliveryStatus.delivered &&
          o.assignedAt.day == DateTime.now().day)
      .fold(0, (sum, o) => sum + o.earnings);

  double get totalEarnings => _orders
      .where((o) => o.status == DeliveryStatus.delivered)
      .fold(0, (sum, o) => sum + o.earnings);

  double get totalDistance => _orders
      .where((o) => o.status == DeliveryStatus.delivered)
      .fold(0, (sum, o) => sum + o.distance);

  void toggleOnline() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  void updateStatus(String id, DeliveryStatus status) {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx < 0) return;
    final o = _orders[idx];
    _orders[idx] = DeliveryOrder(
      id: o.id,
      customerName: o.customerName,
      customerPhone: o.customerPhone,
      pickupAddress: o.pickupAddress,
      deliveryAddress: o.deliveryAddress,
      distance: o.distance,
      earnings: o.earnings,
      items: o.items,
      status: status,
      assignedAt: o.assignedAt,
      paymentMethod: o.paymentMethod,
    );
    notifyListeners();
  }
}
