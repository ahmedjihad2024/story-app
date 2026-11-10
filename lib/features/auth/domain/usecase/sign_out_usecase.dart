import 'package:dartz/dartz.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.signOut();
  }
}

