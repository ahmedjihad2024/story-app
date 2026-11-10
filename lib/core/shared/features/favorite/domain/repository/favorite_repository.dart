import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import 'package:storey_app/features/home/domain/model/product_model.dart';
import '../../data/request/get_favorites_request.dart';
import '../model/favorite_status.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, FavoriteStatus>> addToFavorite(String productId);
  Future<Either<Failure, FavoriteStatus>> removeFromFavorite(String productId);
  Future<Either<Failure, List<ProductModel>>> getFavorites([
    GetFavoritesRequest request = const GetFavoritesRequest(),
  ]);
}

