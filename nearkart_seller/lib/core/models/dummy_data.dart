import 'package:nearkart_seller/core/models/order_model.dart';
import 'package:nearkart_seller/core/models/product_model.dart';

class SellerDummyData {
  static final List<SellerOrder> orders = [
    SellerOrder(
      id: 'NK10023', customerName: 'Priya S.', address: '12 MG Road, Koramangala',
      items: [
        const OrderItem(name: 'Fresh Banana', qty: 2, price: 40),
        const OrderItem(name: 'Whole Milk', qty: 1, price: 55),
      ],
      total: 135, status: OrderStatus.pending,
      placedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      paymentMethod: 'Cash on Delivery',
    ),
    SellerOrder(
      id: 'NK10022', customerName: 'Rahul M.', address: '45 Indiranagar, Bengaluru',
      items: [
        const OrderItem(name: 'Red Apple', qty: 1, price: 120),
        const OrderItem(name: 'Brown Bread', qty: 2, price: 35),
      ],
      total: 190, status: OrderStatus.preparing,
      placedAt: DateTime.now().subtract(const Duration(minutes: 18)),
      paymentMethod: 'UPI',
    ),
    SellerOrder(
      id: 'NK10021', customerName: 'Ananya K.', address: '7 HSR Layout, Bengaluru',
      items: [const OrderItem(name: 'Paneer', qty: 2, price: 80)],
      total: 160, status: OrderStatus.outForDelivery,
      placedAt: DateTime.now().subtract(const Duration(minutes: 40)),
      paymentMethod: 'UPI',
    ),
    SellerOrder(
      id: 'NK10020', customerName: 'Vikram R.', address: '3 BTM Layout, Bengaluru',
      items: [
        const OrderItem(name: 'Greek Yogurt', qty: 1, price: 70),
        const OrderItem(name: 'Orange Juice', qty: 2, price: 80),
      ],
      total: 230, status: OrderStatus.delivered,
      placedAt: DateTime.now().subtract(const Duration(hours: 2)),
      paymentMethod: 'Card',
    ),
    SellerOrder(
      id: 'NK10019', customerName: 'Deepa N.', address: '22 Whitefield, Bengaluru',
      items: [const OrderItem(name: 'Dark Chocolate', qty: 3, price: 60)],
      total: 180, status: OrderStatus.cancelled,
      placedAt: DateTime.now().subtract(const Duration(hours: 3)),
      paymentMethod: 'Cash on Delivery',
    ),
    SellerOrder(
      id: 'NK10018', customerName: 'Karthik P.', address: '9 JP Nagar, Bengaluru',
      items: [
        const OrderItem(name: 'Carrot', qty: 2, price: 35),
        const OrderItem(name: 'Spinach', qty: 1, price: 25),
        const OrderItem(name: 'Onion', qty: 1, price: 40),
      ],
      total: 135, status: OrderStatus.delivered,
      placedAt: DateTime.now().subtract(const Duration(hours: 5)),
      paymentMethod: 'UPI',
    ),
  ];

  static const List<SellerProduct> products = [
    SellerProduct(id: '1', name: 'Fresh Banana',   category: 'Fruits',     price: 40,  originalPrice: 60,  unit: '1 dozen', stock: 50, isActive: true,  image: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400'),
    SellerProduct(id: '2', name: 'Red Apple',       category: 'Fruits',     price: 120, originalPrice: 150, unit: '4 pcs',   stock: 30, isActive: true,  image: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400'),
    SellerProduct(id: '3', name: 'Sweet Mango',     category: 'Fruits',     price: 90,  originalPrice: 120, unit: '2 pcs',   stock: 4,  isActive: true,  image: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400'),
    SellerProduct(id: '4', name: 'Red Tomato',      category: 'Vegetables', price: 30,  originalPrice: 50,  unit: '500g',    stock: 0,  isActive: false, image: 'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=400'),
    SellerProduct(id: '5', name: 'Fresh Spinach',   category: 'Vegetables', price: 25,  originalPrice: 35,  unit: '250g',    stock: 20, isActive: true,  image: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400'),
    SellerProduct(id: '6', name: 'Whole Milk',      category: 'Dairy',      price: 55,  originalPrice: 65,  unit: '1 litre', stock: 3,  isActive: true,  image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400'),
    SellerProduct(id: '7', name: 'Paneer',          category: 'Dairy',      price: 80,  originalPrice: 100, unit: '200g',    stock: 15, isActive: true,  image: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400'),
    SellerProduct(id: '8', name: 'Brown Bread',     category: 'Bakery',     price: 35,  originalPrice: 45,  unit: '400g',    stock: 25, isActive: true,  image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400'),
    SellerProduct(id: '9', name: 'Orange Juice',    category: 'Beverages',  price: 80,  originalPrice: 110, unit: '1 litre', stock: 12, isActive: true,  image: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400'),
    SellerProduct(id: '10', name: 'Dark Chocolate', category: 'Snacks',     price: 60,  originalPrice: 80,  unit: '80g',     stock: 2,  isActive: true,  image: 'https://images.unsplash.com/photo-1548907040-4d42bfc3f15e?w=400'),
  ];
}
