import 'package:supabase_flutter/supabase_flutter.dart';
import '../request/login_request.dart';
import '../request/register_request.dart';
import '../response/login_response.dart';
import '../response/register_response.dart';

abstract class AuthApiService {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<void> signOut();
  User? getCurrentUser();
}

class AuthApiServiceImpl implements AuthApiService {
  final SupabaseClient _supabaseClient;

  AuthApiServiceImpl(this._supabaseClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: request.email,
      password: request.password,
    );
    return LoginResponse.fromAuthResponse(response);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _supabaseClient.auth.signUp(
      email: request.email,
      password: request.password,
      data: {
        'first_name': request.firstName,
        'last_name': request.lastName,
      },
    );
    return RegisterResponse.fromAuthResponse(response);
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  @override
  User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }
}

