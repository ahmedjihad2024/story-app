import '../../domain/model/profile_model.dart';
import '../response/profile_response.dart';

extension ProfileResponseMapper on ProfileResponse {
  ProfileModel toDomain() {
    return ProfileModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      imageUrl: imageUrl,
    );
  }
}

