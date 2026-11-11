import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../model/cart_item_model.dart';
import '../repository/cart_screen_repository.dart';

class GetCartUseCase {
  final CartScreenRepository _repository;

  const GetCartUseCase(this._repository);

  Future<Either<Failure, List<CartItemModel>>> call() {
    return _repository.getCart();
  }
}

