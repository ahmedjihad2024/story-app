import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/error_handler.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../../domain/model/cart_item_model.dart';
import '../../domain/model/order_id_model.dart';
import '../../domain/repository/cart_screen_repository.dart';
import '../data_source/cart_screen_remote_data_source.dart';
import '../mapper/cart_mapper.dart';
import '../response/cart_item_response.dart';
import '../response/order_id_response.dart';

class CartScreenRepositoryImpl implements CartScreenRepository {
  final CartScreenRemoteDataSource _remoteDataSource;

  const CartScreenRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CartItemModel>>> getCart() {
    return fastHandler<List<CartItemResponse>, List<CartItemModel>>(
      request: _remoteDataSource.getCart,
      mapper: (responses) => responses.map((r) => r.toDomain()).toList(),
    );
  }

  @override
  Future<Either<Failure, Unit>> clearCart() {
    return fastHandler<void, Unit>(
      request: _remoteDataSource.clearCart,
      mapper: (_) => unit,
    );
  }

  @override
  Future<Either<Failure, OrderIdModel>> checkout() {
    return fastHandler<OrderIdResponse, OrderIdModel>(
      request: _remoteDataSource.checkout,
      mapper: (response) => response.toDomain(),
    );
  }
}

