import '../../../home/domain/model/product_model.dart';

class OrderDetailsItemModel {
  final int count;
  final double priceAtPurchase;
  final ProductModel product;

  const OrderDetailsItemModel({
    required this.count,
    required this.priceAtPurchase,
    required this.product,
  });

  double get totalPrice =>
      double.parse((priceAtPurchase * count).toStringAsFixed(2));

  OrderDetailsItemModel copyWith({
    int? count,
    double? priceAtPurchase,
    ProductModel? product,
  }) {
    return OrderDetailsItemModel(
      count: count ?? this.count,
      priceAtPurchase: priceAtPurchase ?? this.priceAtPurchase,
      product: product ?? this.product,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailsItemModel &&
          runtimeType == other.runtimeType &&
          count == other.count &&
          priceAtPurchase == other.priceAtPurchase &&
          product == other.product;

  @override
  int get hashCode =>
      count.hashCode ^ priceAtPurchase.hashCode ^ product.hashCode;

  @override
  String toString() =>
      'OrderDetailsItemModel(productId: ${product.id}, count: $count, priceAtPurchase: $priceAtPurchase)';
}

