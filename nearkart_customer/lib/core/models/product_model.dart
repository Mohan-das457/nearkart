class ProductModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final List<String> images;
  final double price;
  final double originalPrice;
  final String unit;
  final List<String> unitOptions;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> benefits;
  final String storeId;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    this.images = const [],
    required this.price,
    required this.originalPrice,
    required this.unit,
    this.unitOptions = const [],
    required this.rating,
    this.reviewCount = 0,
    this.description = '',
    this.benefits = const [],
    this.storeId = '1',
  });

  int get discountPercent =>
      ((originalPrice - price) / originalPrice * 100).round();
}
