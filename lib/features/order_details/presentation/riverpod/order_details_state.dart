import '../../../../core/enums/req_state.dart';
import '../../domain/model/order_details_model.dart';

class OrderDetailsState {
  final ReqState reqState;
  final OrderDetailsModel? order;
  final String? errorMessage;

  const OrderDetailsState({
    this.reqState = ReqState.idle,
    this.order,
    this.errorMessage,
  });

  OrderDetailsState copyWith({
    ReqState? reqState,
    OrderDetailsModel? order,
    String? errorMessage,
  }) {
    return OrderDetailsState(
      reqState: reqState ?? this.reqState,
      order: order ?? this.order,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => reqState.isLoading;
  bool get isSuccess => reqState.isSuccess;
  bool get isError => reqState.isError;
  bool get isEmpty => reqState.isEmpty;
  bool get isIdle => reqState.isIdle;
}

