class CartItemModel {
  final String productId;
  final String name;
  final String brand;
  final String? imageUrl;
  final double price;
  final double originalPrice;
  final int discountPercentage;
  final int count;
  final bool isInFavorites;

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.brand,
    this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.count,
    this.isInFavorites = false,
  });

  bool get hasDiscount => discountPercentage > 0;
  String get formattedDiscount => hasDiscount ? '-$discountPercentage%' : '';
  double get totalPrice => double.parse((price * count).toStringAsFixed(2));
  double get totalOriginalPrice =>
      double.parse((originalPrice * count).toStringAsFixed(2));

  CartItemModel copyWith({
    String? productId,
    String? name,
    String? brand,
    String? imageUrl,
    bool clearImageUrl = false,
    double? price,
    double? originalPrice,
    int? discountPercentage,
    int? count,
    bool? isInFavorites,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      count: count ?? this.count,
      isInFavorites: isInFavorites ?? this.isInFavorites,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModel &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          name == other.name &&
          brand == other.brand &&
          imageUrl == other.imageUrl &&
          price == other.price &&
          originalPrice == other.originalPrice &&
          discountPercentage == other.discountPercentage &&
          count == other.count &&
          isInFavorites == other.isInFavorites;

  @override
  int get hashCode =>
      productId.hashCode ^
      name.hashCode ^
      brand.hashCode ^
      imageUrl.hashCode ^
      price.hashCode ^
      originalPrice.hashCode ^
      discountPercentage.hashCode ^
      count.hashCode ^
      isInFavorites.hashCode;

  @override
  String toString() =>
      'CartItemModel(productId: $productId, name: $name, count: $count, price: $price)';
}

