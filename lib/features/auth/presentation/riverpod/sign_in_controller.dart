import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storey_app/core/di/dependency_injection.dart';
import 'package:storey_app/features/auth/domain/model/auth_user_model.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/network/failure_message.dart';
import '../../data/request/login_request.dart';


class SignInState {
  final ReqState reqState;
  final String? errorMessage;
  final AuthUserModel? user;
  final bool rememberMe;

  const SignInState({
    this.reqState = ReqState.idle,
    this.errorMessage,
    this.user,
    this.rememberMe = false,
  });

  SignInState copyWith({
    ReqState? reqState,
    String? errorMessage,
    AuthUserModel? user,
    bool? rememberMe,
  }) {
    return SignInState(
      reqState: reqState ?? this.reqState,
      errorMessage: errorMessage,
      user: user ?? this.user,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}


class SignInController extends Notifier<SignInState> {
  @override
  SignInState build() => const SignInState();

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      reqState: ReqState.loading,
      errorMessage: null,
    );

    final loginUseCase = ref.read(DI.loginUseCaseProvider);
    final result = await loginUseCase(
      LoginRequest(
        email: email.trim(),
        password: password,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          reqState: ReqState.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(
          reqState: ReqState.success,
          user: user,
          errorMessage: null,
        );
        return true;
      },
    );
  }
}

final signInControllerProvider =
    NotifierProvider.autoDispose<SignInController, SignInState>(
  SignInController.new,
);

