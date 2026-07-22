enum DeliveryStatus { assigned, pickedUp, onTheWay, delivered, failed }

class DeliveryOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String pickupAddress;
  final String deliveryAddress;
  final double distance;
  final double earnings;
  final List<String> items;
  final DeliveryStatus status;
  final DateTime assignedAt;
  final String paymentMethod;

  const DeliveryOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.distance,
    required this.earnings,
    required this.items,
    required this.status,
    required this.assignedAt,
    required this.paymentMethod,
  });

  String get statusLabel {
    switch (status) {
      case DeliveryStatus.assigned:  return 'Assigned';
      case DeliveryStatus.pickedUp:  return 'Picked Up';
      case DeliveryStatus.onTheWay:  return 'On the Way';
      case DeliveryStatus.delivered: return 'Delivered';
      case DeliveryStatus.failed:    return 'Failed';
    }
  }
}
