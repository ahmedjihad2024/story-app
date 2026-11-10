import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/error_handler.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../../domain/model/profile_model.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasource/profile_remote_data_source.dart';
import '../mapper/profile_mapper.dart';
import '../request/update_profile_request.dart';
import '../response/profile_response.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ProfileModel>> getProfile() {
    return fastHandler<ProfileResponse, ProfileModel>(
      request: _remoteDataSource.getProfile,
      mapper: (response) => response.toDomain(),
    );
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(
    UpdateProfileRequest request,
  ) {
    return fastHandler<ProfileResponse, ProfileModel>(
      request: () => _remoteDataSource.updateProfile(request),
      mapper: (response) => response.toDomain(),
    );
  }
}
