import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../model/favorite_status.dart';
import '../repository/favorite_repository.dart';

class AddToFavoriteUseCase {
  final FavoriteRepository _repository;

  const AddToFavoriteUseCase(this._repository);

  Future<Either<Failure, FavoriteStatus>> call(String productId) {
    return _repository.addToFavorite(productId);
  }
}

