import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../model/order_details_model.dart';
import '../repository/order_details_repository.dart';

class GetOrderByIdUseCase {
  final OrderDetailsRepository _repository;

  const GetOrderByIdUseCase(this._repository);

  Future<Either<Failure, OrderDetailsModel>> call(String orderId) {
    return _repository.getOrderById(orderId);
  }
}

