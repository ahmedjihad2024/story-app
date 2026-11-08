import '../../domain/model/auth_user_model.dart';
import '../response/register_response.dart';

extension RegisterResponseMapper on RegisterResponse {
  AuthUserModel toDomain() {
    final metadata = user?.userMetadata;
    return AuthUserModel(
      id: user?.id ?? '',
      email: user?.email ?? '',
      firstName: metadata?['first_name'] as String?,
      lastName: metadata?['last_name'] as String?,
      accessToken: session?.accessToken,
    );
  }
}

