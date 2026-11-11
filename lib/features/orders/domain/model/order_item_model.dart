class OrderItemModel {
  final String productId;
  final String name;
  final String brand;
  final String? imageUrl;
  final int count;
  final double priceAtPurchase;

  const OrderItemModel({
    required this.productId,
    required this.name,
    required this.brand,
    this.imageUrl,
    required this.count,
    required this.priceAtPurchase,
  });

  double get totalPrice =>
      double.parse((priceAtPurchase * count).toStringAsFixed(2));

  OrderItemModel copyWith({
    String? productId,
    String? name,
    String? brand,
    String? imageUrl,
    bool clearImageUrl = false,
    int? count,
    double? priceAtPurchase,
  }) {
    return OrderItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      count: count ?? this.count,
      priceAtPurchase: priceAtPurchase ?? this.priceAtPurchase,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemModel &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          name == other.name &&
          brand == other.brand &&
          imageUrl == other.imageUrl &&
          count == other.count &&
          priceAtPurchase == other.priceAtPurchase;

  @override
  int get hashCode =>
      productId.hashCode ^
      name.hashCode ^
      brand.hashCode ^
      imageUrl.hashCode ^
      count.hashCode ^
      priceAtPurchase.hashCode;

  @override
  String toString() =>
      'OrderItemModel(productId: $productId, name: $name, count: $count, priceAtPurchase: $priceAtPurchase)';
}

