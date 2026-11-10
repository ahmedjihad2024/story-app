import '../../domain/model/cart_item_model.dart';
import '../response/cart_item_response.dart';

extension CartItemResponseMapper on CartItemResponse {
  CartItemModel toDomain() {
    final original = (discountPercentage > 0 && discountPercentage < 100)
        ? double.parse(
            (price / (1 - (discountPercentage / 100))).toStringAsFixed(2),
          )
        : price;

    return CartItemModel(
      productId: productId,
      name: name,
      brand: brand,
      imageUrl: imageUrl,
      price: price,
      originalPrice: original,
      discountPercentage: discountPercentage,
      count: count,
      isInFavorites: isInFavorites,
    );
  }
}

