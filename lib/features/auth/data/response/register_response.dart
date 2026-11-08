import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterResponse {
  final User? user;
  final Session? session;

  const RegisterResponse({
    this.user,
    this.session,
  });

  factory RegisterResponse.fromAuthResponse(AuthResponse response) {
    return RegisterResponse(
      user: response.user,
      session: response.session,
    );
  }
}

