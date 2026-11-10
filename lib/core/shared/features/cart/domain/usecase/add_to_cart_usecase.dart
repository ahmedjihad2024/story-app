import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../repository/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository _repository;

  const AddToCartUseCase(this._repository);

  Future<Either<Failure, int>> call({
    required String productId,
    int count = 1,
  }) {
    return _repository.addToCart(productId: productId, count: count);
  }
}

