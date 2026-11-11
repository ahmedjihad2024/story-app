import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/error_handler.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../../domain/model/order_model.dart';
import '../../domain/repository/orders_repository.dart';
import '../data_source/orders_remote_data_source.dart';
import '../mapper/orders_mapper.dart';
import '../request/get_orders_request.dart';
import '../response/order_response.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  const OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders([
    GetOrdersRequest request = const GetOrdersRequest(),
  ]) {
    return fastHandler<List<OrderResponse>, List<OrderModel>>(
      request: () => _remoteDataSource.getOrders(request),
      mapper: (responses) => responses.map((r) => r.toDomain()).toList(),
    );
  }
}

