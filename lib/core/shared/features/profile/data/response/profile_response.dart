import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? imageUrl;

  const ProfileResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.imageUrl,
  });

  factory ProfileResponse.fromUser(User user) {
    final metadata = user.userMetadata;
    final rawImageUrl = metadata['image_url'] as String?;

    return ProfileResponse(
      id: user.id,
      firstName: metadata['first_name'] as String? ?? '',
      lastName: metadata['last_name'] as String? ?? '',
      email: user.email ?? '',
      imageUrl: rawImageUrl != null && rawImageUrl.isNotEmpty
          ? rawImageUrl
          : null,
    );
  }
}

