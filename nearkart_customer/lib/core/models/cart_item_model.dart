import 'package:nearkart_customer/core/models/product_model.dart';

class CartItem {
  final ProductModel product;
  final String selectedUnit;
  int qty;

  CartItem({
    required this.product,
    required this.selectedUnit,
    this.qty = 1,
  });

  double get total => product.price * qty;
}
