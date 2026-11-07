import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class Env {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get supabaseUrl => _get('SUPABASE_URL');
  static String get supabasePublishableKey => _get('SUPABASE_PUBLISHABLE_KEY');

  static String _get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing $key in .env');
    }
    return value;
  }
}