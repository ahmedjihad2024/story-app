import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/error_handler.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:storey_app/features/home/data/mapper/home_mapper.dart';
import 'package:storey_app/features/home/domain/model/product_model.dart';
import '../../domain/model/favorite_status.dart';
import '../../domain/repository/favorite_repository.dart';
import '../datasource/favorite_remote_data_source.dart';
import '../mapper/favorite_mapper.dart';
import '../request/get_favorites_request.dart';
import '../response/favorite_status_response.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource _remoteDataSource;

  const FavoriteRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, FavoriteStatus>> addToFavorite(String productId) {
    return fastHandler<FavoriteStatusResponse, FavoriteStatus>(
      request: () => _remoteDataSource.addToFavorite(productId),
      mapper: (response) => response.toDomain(),
    );
  }

  @override
  Future<Either<Failure, FavoriteStatus>> removeFromFavorite(String productId) {
    return fastHandler<FavoriteStatusResponse, FavoriteStatus>(
      request: () => _remoteDataSource.removeFromFavorite(productId),
      mapper: (response) => response.toDomain(),
    );
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getFavorites([
    GetFavoritesRequest request = const GetFavoritesRequest(),
  ]) {
    return fastHandler<List<ProductsRow>, List<ProductModel>>(
      request: () => _remoteDataSource.getFavorites(request),
      mapper: (rows) => rows
          .map((row) => row.toDomain().copyWith(isWishlisted: true))
          .toList(),
    );
  }
}

