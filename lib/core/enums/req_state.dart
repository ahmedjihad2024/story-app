enum ReqState {
  loading,
  empty,
  error,
  success,
  idle;

  bool get isLoading => this == ReqState.loading;
  bool get isEmpty => this == ReqState.empty;
  bool get isError => this == ReqState.error;
  bool get isSuccess => this == ReqState.success;
  bool get isIdle => this == ReqState.idle;
}

