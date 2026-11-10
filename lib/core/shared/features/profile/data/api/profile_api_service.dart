import 'package:image_picker/image_picker.dart';
import 'package:storey_app/core/extensions/xfile_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../request/update_profile_request.dart';
import '../response/profile_response.dart';

abstract class ProfileApiService {
  Future<ProfileResponse> getProfile();
  Future<ProfileResponse> updateProfile(UpdateProfileRequest request);
}

class ProfileApiServiceImpl implements ProfileApiService {
  final SupabaseClient _sb;
  final String _avatarBucket;

  ProfileApiServiceImpl([
    SupabaseClient? client,
    this._avatarBucket = 'ProfileImages',
  ]) : _sb = client ?? Supabase.instance.client;

  @override
  Future<ProfileResponse> getProfile() async {
    final userResponse = await _sb.auth.getUser();
    final user = userResponse.user ?? _sb.auth.currentUser;
    if (user == null) {
      throw const AuthException('User not signed in.');
    }
    return ProfileResponse.fromUser(user);
  }

  @override
  Future<ProfileResponse> updateProfile(UpdateProfileRequest request) async {
    final currentUser = _sb.auth.currentUser;
    if (currentUser == null) {
      throw const AuthException('User not signed in.');
    }

    if (request.isEmpty) {
      return ProfileResponse.fromUser(currentUser);
    }

    final previousImageUrl = currentUser.userMetadata['image_url'] as String?;

    ({String url, String filePath})? uploadedAvatar;
    if (request.image != null) {
      uploadedAvatar = await _uploadAvatar(
        userId: currentUser.id,
        file: request.image!,
      );
    }

    final metadata = <String, dynamic>{
      if (request.firstName != null) 'first_name': request.firstName,
      if (request.lastName != null) 'last_name': request.lastName,
      if (uploadedAvatar != null) 'image_url': uploadedAvatar.url,
    };

    final trimmedEmail = request.email?.trim();
    final newEmail =
        trimmedEmail != null &&
            trimmedEmail.isNotEmpty &&
            trimmedEmail != currentUser.email
        ? trimmedEmail
        : null;

    if (newEmail == null && metadata.isEmpty) {
      return ProfileResponse.fromUser(currentUser);
    }

    final response = await _sb.auth.updateUser(
      UserAttributes(
        email: newEmail,
        data: metadata.isEmpty ? null : metadata,
      ),
    );

    if (uploadedAvatar != null) {
      await _removeOldAvatars(
        userId: currentUser.id,
        previousImageUrl: previousImageUrl,
        currentFilePath: uploadedAvatar.filePath,
      );
    }

    final updatedUser = response.user ?? _sb.auth.currentUser ?? currentUser;
    return ProfileResponse.fromUser(updatedUser);
  }

  Future<({String url, String filePath})> _uploadAvatar({
    required String userId,
    required XFile file,
  }) async {
    final ext = file.imageExtension;
    final contentType = file.imageContentType;
    final filePath = '$userId/profile_image.$ext';
    final bytes = await file.readAsBytes();

    final storage = _sb.storage.from(_avatarBucket);
    await storage.uploadBinary(
      filePath,
      bytes,
      fileOptions: FileOptions(
        upsert: true,
        contentType: contentType,
      ),
    );

    return (
      url: storage.getPublicUrl(filePath),
      filePath: filePath,
    );
  }

  Future<void> _removeOldAvatars({
    required String userId,
    required String? previousImageUrl,
    required String currentFilePath,
  }) async {
    try {
      final storage = _sb.storage.from(_avatarBucket);
      final pathsToRemove = <String>{};

      final oldPath = _extractStoragePath(previousImageUrl);
      if (oldPath != null && oldPath != currentFilePath) {
        pathsToRemove.add(oldPath);
      }

      try {
        final objects = await storage.list(path: userId);
        for (final obj in objects) {
          if (obj.name.startsWith('profile_image')) {
            final candidatePath = '$userId/${obj.name}';
            if (candidatePath != currentFilePath) {
              pathsToRemove.add(candidatePath);
            }
          }
        }
      } catch (_) {
        // Listing may be restricted; still attempt removing the known old path.
      }

      if (pathsToRemove.isNotEmpty) {
        await storage.remove(pathsToRemove.toList());
      }
    } catch (_) {
      // Non-fatal: the new avatar is already uploaded and linked on the user.
    }
  }

  String? _extractStoragePath(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final uri = Uri.tryParse(imageUrl);
    if (uri == null) return null;
    final segments = uri.pathSegments;
    final bucketIndex = segments.indexOf(_avatarBucket);
    if (bucketIndex == -1 || bucketIndex >= segments.length - 1) {
      return null;
    }
    return segments.sublist(bucketIndex + 1).join('/');
  }
}
