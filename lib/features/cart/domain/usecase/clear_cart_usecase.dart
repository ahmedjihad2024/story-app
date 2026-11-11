import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../repository/cart_screen_repository.dart';

class ClearCartUseCase {
  final CartScreenRepository _repository;

  const ClearCartUseCase(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.clearCart();
  }
}

