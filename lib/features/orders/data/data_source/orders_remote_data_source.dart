import '../api/orders_api_services.dart';
import '../request/get_orders_request.dart';
import '../response/order_response.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderResponse>> getOrders([
    GetOrdersRequest request = const GetOrdersRequest(),
  ]);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final OrdersApiServices _apiService;

  const OrdersRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<OrderResponse>> getOrders([
    GetOrdersRequest request = const GetOrdersRequest(),
  ]) {
    return _apiService.getOrders(request);
  }
}

