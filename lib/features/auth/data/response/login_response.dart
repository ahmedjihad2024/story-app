import 'package:supabase_flutter/supabase_flutter.dart';

class LoginResponse {
  final Session? session;

  const LoginResponse({
    this.session,
  });

  factory LoginResponse.fromAuthResponse(Session session) {
    return LoginResponse(
      session: session,
    );
  }
}

