import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/error_handler.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../../domain/model/cart_item_model.dart';
import '../../domain/repository/cart_repository.dart';
import '../datasource/cart_remote_data_source.dart';
import '../mapper/cart_mapper.dart';
import '../response/cart_item_response.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  const CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CartItemModel>>> getCart() {
    return fastHandler<List<CartItemResponse>, List<CartItemModel>>(
      request: _remoteDataSource.getCart,
      mapper: (responses) => responses.map((r) => r.toDomain()).toList(),
    );
  }

  @override
  Future<Either<Failure, int>> addToCart({
    required String productId,
    int count = 1,
  }) {
    return fastHandler<int, int>(
      request: () => _remoteDataSource.addToCart(
        productId: productId,
        count: count,
      ),
      mapper: (updatedCount) => updatedCount,
    );
  }

  @override
  Future<Either<Failure, int>> updateItemCount({
    required String productId,
    required int count,
  }) {
    return fastHandler<int, int>(
      request: () => _remoteDataSource.updateItemCount(
        productId: productId,
        count: count,
      ),
      mapper: (updatedCount) => updatedCount,
    );
  }

  @override
  Future<Either<Failure, Unit>> removeFromCart(String productId) {
    return fastHandler<void, Unit>(
      request: () => _remoteDataSource.removeFromCart(productId),
      mapper: (_) => unit,
    );
  }

  @override
  Future<Either<Failure, Unit>> clearCart() {
    return fastHandler<void, Unit>(
      request: _remoteDataSource.clearCart,
      mapper: (_) => unit,
    );
  }
}

