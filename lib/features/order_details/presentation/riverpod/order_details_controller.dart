import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/events/app_event_bus.dart';
import '../../../../core/events/event_bus_mixin.dart';
import '../../../../core/network/failure_message.dart';
import 'order_details_state.dart';

class OrderDetailsController extends Notifier<OrderDetailsState>
    with EventBusMixin {
  final String orderId;

  OrderDetailsController({required this.orderId});

  @override
  OrderDetailsState build() {
    subscribe<ProductFavoriteChanged>(_onFavoriteChanged);
    Future.microtask(loadOrder);
    return const OrderDetailsState();
  }

  void _onFavoriteChanged(ProductFavoriteChanged event) {
    final currentOrder = state.order;
    if (currentOrder == null) return;

    var changed = false;
    final updatedItems = currentOrder.items.map((item) {
      if (item.product.id == event.id &&
          item.product.isWishlisted != event.isInFavorite) {
        changed = true;
        return item.copyWith(
          product: item.product.copyWith(isWishlisted: event.isInFavorite),
        );
      }
      return item;
    }).toList();

    if (!changed) return;
    state = state.copyWith(
      order: currentOrder.copyWith(items: updatedItems),
      errorMessage: state.errorMessage,
    );
  }

  Future<bool> loadOrder({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(
        reqState: ReqState.loading,
        errorMessage: null,
      );
    }

    final useCase = ref.read(DI.getOrderByIdUseCaseProvider);
    final result = await useCase(orderId);
    if (!ref.mounted) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(
          reqState: state.isSuccess ? ReqState.success : ReqState.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (order) {
        state = state.copyWith(
          reqState: ReqState.success,
          order: order,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<bool> refresh() => loadOrder(showLoading: !state.isSuccess);
}

final orderDetailsControllerProvider = NotifierProvider.autoDispose
    .family<OrderDetailsController, OrderDetailsState, String>(
      (orderId) => OrderDetailsController(orderId: orderId),
    );

