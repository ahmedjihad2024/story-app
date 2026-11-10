import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/events/app_event_bus.dart';
import '../../../../core/events/event_bus_mixin.dart';
import '../../../../core/network/failure_message.dart';
import 'profile_state.dart';

class ProfileController extends Notifier<ProfileState> with EventBusMixin {
  @override
  ProfileState build() {
    subscribe<ProfileUpdated>(_onProfileUpdated);
    Future.microtask(getUserData);
    return const ProfileState();
  }

  void _onProfileUpdated(ProfileUpdated event) {
    final profile = event.profile;
    state = state.copyWith(
      reqState: ReqState.success,
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
      imageUrl: profile.imageUrl,
      clearImageUrl: profile.imageUrl == null,
      clearImage: true,
      errorMessage: null,
    );
  }

  Future<bool> getUserData({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(
        reqState: ReqState.loading,
        errorMessage: null,
      );
    }

    final useCase = ref.read(DI.getProfileUseCaseProvider);
    final result = await useCase();

    if (!ref.mounted) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(
          reqState: state.isSuccess ? ReqState.success : ReqState.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (profile) {
        state = state.copyWith(
          reqState: ReqState.success,
          firstName: profile.firstName,
          lastName: profile.lastName,
          email: profile.email,
          imageUrl: profile.imageUrl,
          clearImageUrl: profile.imageUrl == null,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<bool> refresh() => getUserData(showLoading: !state.isSuccess);

  void clearSignOutError() {
    if (state.signOutError == null) return;
    state = state.copyWith(
      clearSignOutError: true,
      errorMessage: state.errorMessage,
    );
  }

  Future<bool> signOut() async {
    if (state.isSigningOut) return false;

    state = state.copyWith(
      isSigningOut: true,
      clearSignOutError: true,
      errorMessage: state.errorMessage,
    );

    final useCase = ref.read(DI.signOutUseCaseProvider);
    final result = await useCase();

    if (!ref.mounted) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSigningOut: false,
          signOutError: failure.message,
          errorMessage: state.errorMessage,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isSigningOut: false,
          clearSignOutError: true,
          errorMessage: state.errorMessage,
        );
        return true;
      },
    );
  }
}

final profileControllerProvider =
    NotifierProvider.autoDispose<ProfileController, ProfileState>(
      ProfileController.new,
    );
