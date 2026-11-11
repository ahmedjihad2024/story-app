import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../../data/request/get_orders_request.dart';
import '../model/order_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders([
    GetOrdersRequest request = const GetOrdersRequest(),
  ]);
}

