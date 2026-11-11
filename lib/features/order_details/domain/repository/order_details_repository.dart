import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../model/order_details_model.dart';

abstract class OrderDetailsRepository {
  Future<Either<Failure, OrderDetailsModel>> getOrderById(String orderId);
}

