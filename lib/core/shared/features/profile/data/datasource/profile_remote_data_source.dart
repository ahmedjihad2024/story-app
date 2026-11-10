import '../api/profile_api_service.dart';
import '../request/update_profile_request.dart';
import '../response/profile_response.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponse> getProfile();
  Future<ProfileResponse> updateProfile(UpdateProfileRequest request);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiService _apiService;

  const ProfileRemoteDataSourceImpl(this._apiService);

  @override
  Future<ProfileResponse> getProfile() {
    return _apiService.getProfile();
  }

  @override
  Future<ProfileResponse> updateProfile(UpdateProfileRequest request) {
    return _apiService.updateProfile(request);
  }
}
