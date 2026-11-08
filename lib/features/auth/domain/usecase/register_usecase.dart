import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../data/request/register_request.dart';
import '../model/auth_user_model.dart';
import '../repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, AuthUserModel>> call(RegisterRequest request) {
    return _repository.register(request);
  }
}

