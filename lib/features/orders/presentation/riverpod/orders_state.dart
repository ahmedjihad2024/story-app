import '../../../../core/enums/order_status.dart';
import '../../../../core/enums/req_state.dart';
import '../../domain/model/order_model.dart';

class OrdersState {
  final ReqState reqState;
  final List<OrderModel> orders;
  final OrderStatus? selectedStatus;
  final String? errorMessage;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const OrdersState({
    this.reqState = ReqState.idle,
    this.orders = const [],
    this.selectedStatus,
    this.errorMessage,
    this.page = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  OrdersState copyWith({
    ReqState? reqState,
    List<OrderModel>? orders,
    OrderStatus? selectedStatus,
    bool clearStatus = false,
    String? errorMessage,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return OrdersState(
      reqState: reqState ?? this.reqState,
      orders: orders ?? this.orders,
      selectedStatus: clearStatus
          ? null
          : (selectedStatus ?? this.selectedStatus),
      errorMessage: errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get isLoading => reqState.isLoading;
  bool get isSuccess => reqState.isSuccess;
  bool get isError => reqState.isError;
  bool get isEmpty => reqState.isEmpty;
  bool get isIdle => reqState.isIdle;
}

