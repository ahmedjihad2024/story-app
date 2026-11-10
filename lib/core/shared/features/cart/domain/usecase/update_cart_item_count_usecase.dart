import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../repository/cart_repository.dart';

class UpdateCartItemCountUseCase {
  final CartRepository _repository;

  const UpdateCartItemCountUseCase(this._repository);

  Future<Either<Failure, int>> call({
    required String productId,
    required int count,
  }) {
    return _repository.updateItemCount(productId: productId, count: count);
  }
}

