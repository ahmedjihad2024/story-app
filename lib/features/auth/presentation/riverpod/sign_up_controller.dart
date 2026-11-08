import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/network/failure_message.dart';
import '../../data/request/register_request.dart';
import '../../domain/model/auth_user_model.dart';

class SignUpState {
  final ReqState reqState;
  final String? errorMessage;
  final AuthUserModel? user;

  const SignUpState({
    this.reqState = ReqState.idle,
    this.errorMessage,
    this.user,
  });

  SignUpState copyWith({
    ReqState? reqState,
    String? errorMessage,
    AuthUserModel? user,
  }) {
    return SignUpState(
      reqState: reqState ?? this.reqState,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class SignUpController extends Notifier<SignUpState> {
  @override
  SignUpState build() => const SignUpState();

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      reqState: ReqState.loading,
      errorMessage: null,
    );

    final registerUseCase = ref.read(DI.registerUseCaseProvider);
    final result = await registerUseCase(
      RegisterRequest(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
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

final signUpControllerProvider =
    NotifierProvider.autoDispose<SignUpController, SignUpState>(
  SignUpController.new,
);
