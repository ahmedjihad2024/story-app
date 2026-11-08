import 'package:supabase_flutter/supabase_flutter.dart';
import '../api/auth_api_service.dart';
import '../request/login_request.dart';
import '../request/register_request.dart';
import '../response/login_response.dart';
import '../response/register_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<void> signOut();
  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<LoginResponse> login(LoginRequest request) {
    return _apiService.login(request);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) {
    return _apiService.register(request);
  }

  @override
  Future<void> signOut() {
    return _apiService.signOut();
  }

  @override
  User? getCurrentUser() {
    return _apiService.getCurrentUser();
  }
}
