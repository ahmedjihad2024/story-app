import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../data/request/login_request.dart';
import '../../data/request/register_request.dart';
import '../model/auth_user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserModel>> login(LoginRequest request);
  Future<Either<Failure, AuthUserModel>> register(RegisterRequest request);
  Future<void> signOut();
  AuthUserModel? getCurrentUser();
}

