import 'package:flutter/material.dart';
import 'package:nearkart_customer/core/models/cart_item_model.dart';
import 'package:nearkart_customer/core/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.qty);

  double get subtotal => _items.fold(0, (sum, i) => sum + i.total);

  double deliveryFee(double minOrder) =>
      subtotal >= minOrder ? 0 : 30;

  double get discount =>
      _items.fold(0, (sum, i) =>
          sum + (i.product.originalPrice - i.product.price) * i.qty);

  double total(double minOrder) => subtotal + deliveryFee(minOrder);

  bool contains(String productId) =>
      _items.any((i) => i.product.id == productId);

  int qtyOf(String productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    return idx >= 0 ? _items[idx].qty : 0;
  }

  void add(ProductModel product, {String? unit}) {
    final idx = _items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      _items[idx].qty++;
    } else {
      _items.add(CartItem(
        product: product,
        selectedUnit: unit ?? product.unit,
      ));
    }
    notifyListeners();
  }

  void increment(String productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      _items[idx].qty++;
      notifyListeners();
    }
  }

  void decrement(String productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (_items[idx].qty <= 1) {
        _items.removeAt(idx);
      } else {
        _items[idx].qty--;
      }
      notifyListeners();
    }
  }

  void remove(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
