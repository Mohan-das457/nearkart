import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nearkart_customer/core/models/product_model.dart';

class OrderRecord {
  final String orderId;
  final DateTime placedAt;
  final List<OrderItem> items;
  final String address;
  final String payment;
  final double total;

  OrderRecord({
    required this.orderId,
    required this.placedAt,
    required this.items,
    required this.address,
    required this.payment,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'placedAt': placedAt.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
        'address': address,
        'payment': payment,
        'total': total,
      };

  factory OrderRecord.fromJson(Map<String, dynamic> j) => OrderRecord(
        orderId: j['orderId'],
        placedAt: DateTime.parse(j['placedAt']),
        items: (j['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
        address: j['address'],
        payment: j['payment'],
        total: (j['total'] as num).toDouble(),
      );
}

class OrderItem {
  final String name;
  final String unit;
  final int qty;
  final double price;

  const OrderItem({
    required this.name,
    required this.unit,
    required this.qty,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'unit': unit,
        'qty': qty,
        'price': price,
      };

  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
        name: j['name'],
        unit: j['unit'],
        qty: j['qty'],
        price: (j['price'] as num).toDouble(),
      );
}

class AppState extends ChangeNotifier {
  String _location = '';
  String _deliveryAddress = '';
  String _paymentMethod = '';
  String _lastOrderId = '';
  bool _isFirstLaunch = true;
  bool _isLoggedIn = false;
  String _phone = '';

  final Set<String> _wishlist = {};
  final List<OrderRecord> _orders = [];

  // ── Getters ────────────────────────────────────────────────────────────────

  String get location => _location;
  String get deliveryAddress => _deliveryAddress;
  String get paymentMethod => _paymentMethod;
  String get lastOrderId => _lastOrderId;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isLoggedIn => _isLoggedIn;
  String get phone => _phone;
  Set<String> get wishlist => Set.unmodifiable(_wishlist);
  List<OrderRecord> get orders => List.unmodifiable(_orders);

  // ── Init ───────────────────────────────────────────────────────────────────

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('first_launch') ?? true;
    _isLoggedIn = prefs.getBool('logged_in') ?? false;
    _phone = prefs.getString('phone') ?? '';
    _location = prefs.getString('location') ?? '';
    _wishlist.addAll(prefs.getStringList('wishlist') ?? []);

    final ordersJson = prefs.getStringList('orders') ?? [];
    _orders.addAll(
      ordersJson.map((s) => OrderRecord.fromJson(jsonDecode(s))),
    );

    notifyListeners();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'orders',
      _orders.map((o) => jsonEncode(o.toJson())).toList(),
    );
  }

  // ── Onboarding / Auth ──────────────────────────────────────────────────────

  Future<void> completeOnboarding() async {
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    notifyListeners();
  }

  Future<void> login(String phone) async {
    _isLoggedIn = true;
    _phone = phone;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);
    await prefs.setString('phone', phone);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _phone = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', false);
    await prefs.remove('phone');
    notifyListeners();
  }

  // ── Location ───────────────────────────────────────────────────────────────

  Future<void> setLocation(String location) async {
    _location = location;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', location);
    notifyListeners();
  }

  // ── Order ──────────────────────────────────────────────────────────────────

  void setOrder({required String address, required String payment}) {
    _deliveryAddress = address;
    _paymentMethod = payment;
    notifyListeners();
  }

  Future<void> addOrder({
    required String orderId,
    required List<ProductModel> products,
    required List<int> quantities,
    required List<String> units,
    required String address,
    required String payment,
    required double total,
  }) async {
    final items = List.generate(
      products.length,
      (i) => OrderItem(
        name: products[i].name,
        unit: units[i],
        qty: quantities[i],
        price: products[i].price,
      ),
    );
    _lastOrderId = orderId;
    _orders.insert(
      0,
      OrderRecord(
        orderId: orderId,
        placedAt: DateTime.now(),
        items: items,
        address: address,
        payment: payment,
        total: total,
      ),
    );
    await _saveOrders();
    notifyListeners();
  }

  // ── Wishlist ───────────────────────────────────────────────────────────────

  bool isWishlisted(String productId) => _wishlist.contains(productId);

  Future<void> toggleWishlist(String productId) async {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('wishlist', _wishlist.toList());
    notifyListeners();
  }
}
