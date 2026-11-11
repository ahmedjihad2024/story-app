import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/order_status.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/network/failure_message.dart';
import '../../data/request/get_orders_request.dart';
import 'orders_state.dart';

class OrdersController extends Notifier<OrdersState> {
  int _activeRequestId = 0;

  @override
  OrdersState build() {
    Future.microtask(loadOrders);
    return const OrdersState();
  }

  Future<bool> loadOrders({bool showLoading = true}) async {
    final requestId = ++_activeRequestId;
    final selectedStatus = state.selectedStatus;
    final request = GetOrdersRequest(status: selectedStatus, page: 0);

    if (showLoading) {
      state = state.copyWith(
        reqState: ReqState.loading,
        errorMessage: null,
        page: 0,
        hasMore: true,
        isLoadingMore: false,
      );
    }

    final useCase = ref.read(DI.getOrdersUseCaseProvider);
    final result = await useCase(request);
    if (!ref.mounted || requestId != _activeRequestId) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(
          reqState: state.isSuccess ? ReqState.success : ReqState.error,
          errorMessage: failure.message,
          isLoadingMore: false,
        );
        return false;
      },
      (orders) {
        state = state.copyWith(
          reqState: orders.isEmpty ? ReqState.empty : ReqState.success,
          orders: orders,
          page: 0,
          hasMore: orders.length >= request.limit,
          isLoadingMore: false,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<bool> refresh() => loadOrders(showLoading: !state.isSuccess);

  Future<void> selectStatus(OrderStatus? status) async {
    if (status == state.selectedStatus && !state.isError) return;

    state = state.copyWith(
      selectedStatus: status,
      clearStatus: status == null,
      orders: const [],
      errorMessage: null,
      page: 0,
      hasMore: true,
    );

    await loadOrders();
  }

  Future<bool> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) {
      return false;
    }

    final requestId = _activeRequestId;
    final nextPage = state.page + 1;
    final request = GetOrdersRequest(
      status: state.selectedStatus,
      page: nextPage,
    );

    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    final useCase = ref.read(DI.getOrdersUseCaseProvider);
    final result = await useCase(request);
    if (!ref.mounted || requestId != _activeRequestId) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(isLoadingMore: false);
        return false;
      },
      (newOrders) {
        state = state.copyWith(
          orders: [...state.orders, ...newOrders],
          page: nextPage,
          hasMore: newOrders.length >= request.limit,
          isLoadingMore: false,
        );
        return newOrders.isNotEmpty;
      },
    );
  }
}

final ordersControllerProvider =
    NotifierProvider.autoDispose<OrdersController, OrdersState>(
      OrdersController.new,
    );

