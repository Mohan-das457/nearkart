class SellerProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final double originalPrice;
  final String unit;
  final int stock;
  final bool isActive;
  final String image;

  const SellerProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.unit,
    required this.stock,
    required this.isActive,
    required this.image,
  });

  int get discountPercent =>
      ((originalPrice - price) / originalPrice * 100).round();

  bool get isLowStock => stock > 0 && stock <= 5;
  bool get isOutOfStock => stock == 0;
}
