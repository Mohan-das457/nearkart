class AdminOrder {
  final String id, customer, store, status, paymentMethod;
  final double total;
  final DateTime createdAt;
  const AdminOrder({
    required this.id, required this.customer, required this.store,
    required this.status, required this.paymentMethod,
    required this.total, required this.createdAt,
  });
}

class AdminStore {
  final String id, name, category, owner, address;
  final bool isActive;
  final double rating;
  const AdminStore({
    required this.id, required this.name, required this.category,
    required this.owner, required this.address,
    required this.isActive, required this.rating,
  });
}

class AdminUser {
  final String id, name, phone;
  final bool isActive;
  final int orderCount;
  const AdminUser({
    required this.id, required this.name, required this.phone,
    required this.isActive, required this.orderCount,
  });
}

class AdminAgent {
  final String id, name, phone, vehicleNumber;
  final bool isActive, isOnline;
  final int deliveries;
  final double earnings, rating;
  const AdminAgent({
    required this.id, required this.name, required this.phone,
    required this.vehicleNumber, required this.isActive,
    required this.isOnline, required this.deliveries,
    required this.earnings, required this.rating,
  });
}

class DummyData {
  static final orders = [
    AdminOrder(id: 'NK10023', customer: 'Priya S.', store: 'Fresh Mart', status: 'pending',          paymentMethod: 'COD', total: 245, createdAt: DateTime.now().subtract(const Duration(minutes: 5))),
    AdminOrder(id: 'NK10022', customer: 'Rahul M.', store: 'Fresh Mart', status: 'preparing',        paymentMethod: 'UPI', total: 180, createdAt: DateTime.now().subtract(const Duration(minutes: 22))),
    AdminOrder(id: 'NK10021', customer: 'Ananya K.', store: 'Green Basket', status: 'out_for_delivery', paymentMethod: 'UPI', total: 320, createdAt: DateTime.now().subtract(const Duration(hours: 1))),
    AdminOrder(id: 'NK10020', customer: 'Vikram R.', store: 'Daily Needs', status: 'delivered',      paymentMethod: 'Card', total: 410, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    AdminOrder(id: 'NK10019', customer: 'Deepa N.', store: 'Organic Hub', status: 'cancelled',       paymentMethod: 'COD', total: 150, createdAt: DateTime.now().subtract(const Duration(hours: 4))),
  ];

  static final stores = [
    const AdminStore(id: 's1', name: 'Fresh Mart',   category: 'Grocery',  owner: '+91 98765 00001', address: 'MG Road, Koramangala', isActive: true,  rating: 4.5),
    const AdminStore(id: 's2', name: 'Green Basket', category: 'Organic',  owner: '+91 98765 00002', address: 'HSR Layout',           isActive: true,  rating: 4.7),
    const AdminStore(id: 's3', name: 'Daily Needs',  category: 'Grocery',  owner: '+91 98765 00003', address: 'BTM Layout',           isActive: true,  rating: 4.2),
    const AdminStore(id: 's4', name: 'Organic Hub',  category: 'Organic',  owner: '+91 98765 00004', address: 'Whitefield',           isActive: false, rating: 4.0),
  ];

  static final users = [
    const AdminUser(id: 'u1', name: 'Priya S.',  phone: '+91 98765 43210', isActive: true,  orderCount: 12),
    const AdminUser(id: 'u2', name: 'Rahul M.',  phone: '+91 91234 56789', isActive: true,  orderCount: 7),
    const AdminUser(id: 'u3', name: 'Ananya K.', phone: '+91 87654 32109', isActive: true,  orderCount: 23),
    const AdminUser(id: 'u4', name: 'Vikram R.', phone: '+91 76543 21098', isActive: false, orderCount: 3),
  ];

  static final agents = [
    const AdminAgent(id: 'a1', name: 'Ravi Kumar',  phone: '+91 98765 43210', vehicleNumber: 'KA 05 AB 1234', isActive: true,  isOnline: true,  deliveries: 142, earnings: 4260, rating: 4.8),
    const AdminAgent(id: 'a2', name: 'Suresh P.',   phone: '+91 91234 56789', vehicleNumber: 'KA 01 CD 5678', isActive: true,  isOnline: false, deliveries: 98,  earnings: 2940, rating: 4.6),
    const AdminAgent(id: 'a3', name: 'Mohan Das',   phone: '+91 87654 32109', vehicleNumber: 'KA 03 EF 9012', isActive: true,  isOnline: true,  deliveries: 210, earnings: 6300, rating: 4.9),
    const AdminAgent(id: 'a4', name: 'Kiran Raj',   phone: '+91 76543 21098', vehicleNumber: 'KA 02 GH 3456', isActive: false, isOnline: false, deliveries: 45,  earnings: 1350, rating: 4.3),
  ];
}
