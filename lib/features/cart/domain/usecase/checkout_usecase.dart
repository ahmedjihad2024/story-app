import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../model/order_id_model.dart';
import '../repository/cart_screen_repository.dart';

class CheckoutUseCase {
  final CartScreenRepository _repository;

  const CheckoutUseCase(this._repository);

  Future<Either<Failure, OrderIdModel>> call() {
    return _repository.checkout();
  }
}

