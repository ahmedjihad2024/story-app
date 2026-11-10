import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import 'package:storey_app/features/home/domain/model/product_model.dart';
import '../../data/request/get_favorites_request.dart';
import '../repository/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository _repository;

  const GetFavoritesUseCase(this._repository);

  Future<Either<Failure, List<ProductModel>>> call([
    GetFavoritesRequest request = const GetFavoritesRequest(),
  ]) {
    return _repository.getFavorites(request);
  }
}

