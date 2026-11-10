import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/events/app_event_bus.dart';
import '../../../../core/events/event_bus_mixin.dart';
import '../../../../core/network/failure_message.dart';
import '../../../../core/shared/features/profile/data/request/update_profile_request.dart';
import '../../../../core/shared/features/profile/domain/model/profile_model.dart';
import 'update_profile_state.dart';

class UpdateProfileController extends Notifier<UpdateProfileState>
    with EventBusMixin {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  UpdateProfileState build() => const UpdateProfileState();

  Future<void> initialize(ProfileModel? initialProfile) async {
    if (initialProfile != null) {
      state = state.copyWith(
        isInitialized: true,
        isFetchingInitial: false,
        initialFirstName: initialProfile.firstName,
        initialLastName: initialProfile.lastName,
        initialEmail: initialProfile.email,
        initialImageUrl: initialProfile.imageUrl,
        clearInitialImageUrl: initialProfile.imageUrl == null,
        errorMessage: null,
      );
      return;
    }

    await loadInitialProfile();
  }

  Future<void> loadInitialProfile() async {
    state = state.copyWith(
      isFetchingInitial: true,
      errorMessage: null,
    );

    final useCase = ref.read(DI.getProfileUseCaseProvider);
    final result = await useCase();

    if (!ref.mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          isFetchingInitial: false,
          errorMessage: failure.message,
        );
      },
      (profile) {
        state = state.copyWith(
          isInitialized: true,
          isFetchingInitial: false,
          initialFirstName: profile.firstName,
          initialLastName: profile.lastName,
          initialEmail: profile.email,
          initialImageUrl: profile.imageUrl,
          clearInitialImageUrl: profile.imageUrl == null,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null || !ref.mounted) return;

      final bytes = await picked.readAsBytes();
      if (!ref.mounted) return;

      state = state.copyWith(
        pickedImage: picked,
        pickedImageBytes: bytes,
        errorMessage: null,
      );
    } on PlatformException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        errorMessage: e.message ?? 'Unable to access selected image source.',
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(
        errorMessage: 'Failed to pick image. Please try again.',
      );
    }
  }

  void clearPickedImage() {
    state = state.copyWith(
      clearPickedImage: true,
      errorMessage: null,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final trimmedFirst = firstName.trim();
    final trimmedLast = lastName.trim();
    final trimmedEmail = email.trim();

    final request = UpdateProfileRequest(
      firstName:
          trimmedFirst != state.initialFirstName.trim() ? trimmedFirst : null,
      lastName:
          trimmedLast != state.initialLastName.trim() ? trimmedLast : null,
      email: trimmedEmail != state.initialEmail.trim() ? trimmedEmail : null,
      image: state.pickedImage,
    );

    if (request.isEmpty) {
      return false;
    }

    state = state.copyWith(
      reqState: ReqState.loading,
      emailConfirmationPending: false,
      errorMessage: null,
    );

    final previousImageUrl = state.initialImageUrl;
    final useCase = ref.read(DI.updateProfileUseCaseProvider);
    final result = await useCase(request);

    if (!ref.mounted) return false;

    return await result.fold(
      (failure) async {
        state = state.copyWith(
          reqState: ReqState.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (updatedProfile) async {
        if (request.image != null) {
          if (previousImageUrl != null && previousImageUrl.isNotEmpty) {
            await CachedNetworkImage.evictFromCache(previousImageUrl);
          }
          if (updatedProfile.imageUrl != null &&
              updatedProfile.imageUrl!.isNotEmpty) {
            await CachedNetworkImage.evictFromCache(updatedProfile.imageUrl!);
          }
        }

        if (!ref.mounted) return false;

        final isEmailPending =
            request.email != null && updatedProfile.email != trimmedEmail;

        fireEvent(ProfileUpdated(updatedProfile));

        state = state.copyWith(
          reqState: ReqState.success,
          isInitialized: true,
          initialFirstName: updatedProfile.firstName,
          initialLastName: updatedProfile.lastName,
          initialEmail: updatedProfile.email,
          initialImageUrl: updatedProfile.imageUrl,
          clearInitialImageUrl: updatedProfile.imageUrl == null,
          clearPickedImage: true,
          emailConfirmationPending: isEmailPending,
          errorMessage: null,
        );
        return true;
      },
    );
  }
}

final updateProfileControllerProvider =
    NotifierProvider.autoDispose<UpdateProfileController, UpdateProfileState>(
  UpdateProfileController.new,
);

