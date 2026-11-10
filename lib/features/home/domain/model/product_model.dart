class ProductModel {
  final String id;
  final String brand;
  final String title;
  final double rating;
  final double price;
  final double originalPrice;
  final String discountPercentage;
  final String imageAsset;
  final String? imageUrl;
  final String? description;
  final int? salesCount;
  final bool isWishlisted;

  const ProductModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.rating,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.imageAsset,
    this.imageUrl,
    this.description,
    this.salesCount,
    this.isWishlisted = false,
  });

  ProductModel copyWith({
    String? id,
    String? brand,
    String? title,
    double? rating,
    double? price,
    double? originalPrice,
    String? discountPercentage,
    String? imageAsset,
    String? imageUrl,
    String? description,
    int? salesCount,
    bool? isWishlisted,
  }) {
    return ProductModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      salesCount: salesCount ?? this.salesCount,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }
}
