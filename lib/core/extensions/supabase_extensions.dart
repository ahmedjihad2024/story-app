import 'package:supabase_flutter/supabase_flutter.dart';

extension RowsParsing on Object? {
  List<T> toRows<T>(T Function(Map<String, dynamic>) from) {
    if (this is! List) return const [];
    final list = this as List;
    final results = <T>[];
    for (final item in list) {
      if (item is Map) {
        results.add(from(Map<String, dynamic>.from(item)));
      }
    }
    return results;
  }
}

extension SupabaseAuthUserExtension on SupabaseClient {
  String requireUserId() {
    final userId = auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('User not signed in.');
    }
    return userId;
  }
}
