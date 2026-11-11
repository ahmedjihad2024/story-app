import '../api/order_details_api_services.dart';
import '../response/order_details_response.dart';

abstract class OrderDetailsRemoteDataSource {
  Future<OrderDetailsResponse> getOrderById(String orderId);
}

class OrderDetailsRemoteDataSourceImpl implements OrderDetailsRemoteDataSource {
  final OrderDetailsApiServices _apiService;

  const OrderDetailsRemoteDataSourceImpl(this._apiService);

  @override
  Future<OrderDetailsResponse> getOrderById(String orderId) {
    return _apiService.getOrderById(orderId);
  }
}

