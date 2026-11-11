import '../api/cart_screen_api_service.dart';
import '../response/cart_item_response.dart';
import '../response/order_id_response.dart';

abstract class CartScreenRemoteDataSource {
  Future<List<CartItemResponse>> getCart();
  Future<void> clearCart();
  Future<OrderIdResponse> checkout();
}

class CartScreenRemoteDataSourceImpl implements CartScreenRemoteDataSource {
  final CartScreenApiService _apiService;

  const CartScreenRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<CartItemResponse>> getCart() {
    return _apiService.getCart();
  }

  @override
  Future<void> clearCart() {
    return _apiService.clearCart();
  }

  @override
  Future<OrderIdResponse> checkout() {
    return _apiService.checkout();
  }
}

