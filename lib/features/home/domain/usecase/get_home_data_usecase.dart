import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository _repository;

  GetHomeDataUseCase(this._repository);

  Future<Either<Failure, HomeModel>> call() {
    return _repository.getHomeData();
  }
}

