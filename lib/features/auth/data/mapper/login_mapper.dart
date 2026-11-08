import '../../domain/model/auth_user_model.dart';
import '../response/login_response.dart';

extension LoginResponseMapper on LoginResponse {
  AuthUserModel toDomain() {
    final metadata = session?.user.userMetadata;
    return AuthUserModel(
      id: session?.user.id ?? '',
      email: session?.user.email ?? '',
      firstName: metadata?['first_name'] as String?,
      lastName: metadata?['last_name'] as String?,
      accessToken: session?.accessToken,
    );
  }
}

