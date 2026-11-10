import 'package:dartz/dartz.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import '../../data/request/update_profile_request.dart';
import '../model/profile_model.dart';
import '../repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Either<Failure, ProfileModel>> call(UpdateProfileRequest request) {
    return _repository.updateProfile(request);
  }
}

