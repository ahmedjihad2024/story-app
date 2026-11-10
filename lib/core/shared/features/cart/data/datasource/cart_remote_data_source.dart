import '../api/cart_api_service.dart';
import '../response/cart_item_response.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemResponse>> getCart();
  Future<int> addToCart({required String productId, int count = 1});
  Future<int> updateItemCount({required String productId, required int count});
  Future<void> removeFromCart(String productId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final CartApiService _apiService;

  const CartRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<CartItemResponse>> getCart() {
    return _apiService.getCart();
  }

  @override
  Future<int> addToCart({required String productId, int count = 1}) {
    return _apiService.addToCart(productId: productId, count: count);
  }

  @override
  Future<int> updateItemCount({
    required String productId,
    required int count,
  }) {
    return _apiService.updateItemCount(productId: productId, count: count);
  }

  @override
  Future<void> removeFromCart(String productId) {
    return _apiService.removeFromCart(productId);
  }

  @override
  Future<void> clearCart() {
    return _apiService.clearCart();
  }
}

