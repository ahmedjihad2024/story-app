import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../model/cart_item_model.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemModel>>> getCart();
  Future<Either<Failure, int>> addToCart({
    required String productId,
    int count = 1,
  });
  Future<Either<Failure, int>> updateItemCount({
    required String productId,
    required int count,
  });
  Future<Either<Failure, Unit>> removeFromCart(String productId);
  Future<Either<Failure, Unit>> clearCart();
}

