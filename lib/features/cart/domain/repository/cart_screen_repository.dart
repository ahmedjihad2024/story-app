import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../model/cart_item_model.dart';
import '../model/order_id_model.dart';

abstract class CartScreenRepository {
  Future<Either<Failure, List<CartItemModel>>> getCart();
  Future<Either<Failure, Unit>> clearCart();
  Future<Either<Failure, OrderIdModel>> checkout();
}

