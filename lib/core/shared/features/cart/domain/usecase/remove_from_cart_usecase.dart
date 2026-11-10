import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../repository/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository _repository;

  const RemoveFromCartUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String productId) {
    return _repository.removeFromCart(productId);
  }
}

