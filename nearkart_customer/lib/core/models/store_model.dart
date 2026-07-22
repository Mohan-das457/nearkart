class StoreModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String banner;
  final double rating;
  final int reviewCount;
  final int deliveryMinutes;
  final String distance;
  final double minOrder;
  final double deliveryFee;
  final bool isOpen;
  final String openingHours;
  final List<String> tags;

  const StoreModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.banner,
    required this.rating,
    required this.reviewCount,
    required this.deliveryMinutes,
    required this.distance,
    required this.minOrder,
    required this.deliveryFee,
    required this.isOpen,
    required this.openingHours,
    required this.tags,
  });
}
