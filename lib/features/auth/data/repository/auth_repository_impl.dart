import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/error_handler.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../domain/model/auth_user_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';
import '../mapper/login_mapper.dart';
import '../mapper/register_mapper.dart';
import '../request/login_request.dart';
import '../request/register_request.dart';
import '../response/login_response.dart';
import '../response/register_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AuthUserModel>> login(LoginRequest request) {
    return fastHandler<LoginResponse, AuthUserModel>(
      request: () => _remoteDataSource.login(request),
      mapper: (response) => response.toDomain(),
    );
  }

  @override
  Future<Either<Failure, AuthUserModel>> register(RegisterRequest request) {
    return fastHandler<RegisterResponse, AuthUserModel>(
      request: () => _remoteDataSource.register(request),
      mapper: (response) => response.toDomain(),
    );
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  AuthUserModel? getCurrentUser() {
    final user = _remoteDataSource.getCurrentUser();
    if (user == null) return null;
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      firstName: user.userMetadata['first_name'] as String?,
      lastName: user.userMetadata['last_name'] as String?,
    );
  }
}

