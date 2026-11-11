import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../../data/request/get_orders_request.dart';
import '../model/order_model.dart';
import '../repository/orders_repository.dart';

class GetOrdersUseCase {
  final OrdersRepository _repository;

  const GetOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderModel>>> call([
    GetOrdersRequest request = const GetOrdersRequest(),
  ]) {
    return _repository.getOrders(request);
  }
}

