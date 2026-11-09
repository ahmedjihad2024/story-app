import '../../../../core/enums/req_state.dart';
import '../../domain/model/home_model.dart';

class HomeState {
  final ReqState reqState;
  final HomeModel? data;
  final String? errorMessage;

  const HomeState({
    this.reqState = ReqState.idle,
    this.data,
    this.errorMessage,
  });

  HomeState copyWith({
    ReqState? reqState,
    HomeModel? data,
    String? errorMessage,
  }) {
    return HomeState(
      reqState: reqState ?? this.reqState,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => reqState.isLoading;
  bool get isSuccess => reqState.isSuccess;
  bool get isError => reqState.isError;
  bool get isIdle => reqState.isIdle;
}

