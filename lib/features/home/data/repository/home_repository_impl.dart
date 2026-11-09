import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/error_handler.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../domain/model/home_model.dart';
import '../../domain/repository/home_repository.dart';
import '../data_source/home_remote_data_source.dart';
import '../mapper/home_mapper.dart';
import '../response/home_response.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, HomeModel>> getHomeData() {
    return fastHandler<HomeData, HomeModel>(
      request: () => _remoteDataSource.getHomeData(),
      mapper: (response) => response.toDomain(),
    );
  }
}
