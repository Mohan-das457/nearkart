enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered, cancelled }

class SellerOrder {
  final String id;
  final String customerName;
  final String address;
  final List<OrderItem> items;
  final double total;
  final OrderStatus status;
  final DateTime placedAt;
  final String paymentMethod;

  const SellerOrder({
    required this.id,
    required this.customerName,
    required this.address,
    required this.items,
    required this.total,
    required this.status,
    required this.placedAt,
    required this.paymentMethod,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:       return 'Pending';
      case OrderStatus.confirmed:     return 'Confirmed';
      case OrderStatus.preparing:     return 'Preparing';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered:     return 'Delivered';
      case OrderStatus.cancelled:     return 'Cancelled';
    }
  }
}

class OrderItem {
  final String name;
  final int qty;
  final double price;
  const OrderItem({required this.name, required this.qty, required this.price});
}
