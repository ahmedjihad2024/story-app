import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../model/cart_item_model.dart';
import '../repository/cart_repository.dart';

class GetCartUseCase {
  final CartRepository _repository;

  const GetCartUseCase(this._repository);

  Future<Either<Failure, List<CartItemModel>>> call() {
    return _repository.getCart();
  }
}

