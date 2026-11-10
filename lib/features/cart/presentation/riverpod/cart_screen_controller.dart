import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/events/app_event_bus.dart';
import '../../../../core/events/event_bus_mixin.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../../core/network/failure_message.dart';
import '../../../../core/shared/features/cart/domain/model/cart_item_model.dart';
import '../../../../core/shared/features/favorite/domain/model/favorite_status.dart';
import '../../../../core/shared/riverpod/cart/cart_controller.dart';
import '../../../../core/shared/riverpod/favorite/favorite_controller.dart';
import 'cart_screen_state.dart';

class CartScreenController extends Notifier<CartScreenState> with EventBusMixin {
  @override
  CartScreenState build() {
    subscribe<ProductFavoriteChanged>(_onFavoriteChanged);
    Future.microtask(loadCart);
    return const CartScreenState();
  }

  void _onFavoriteChanged(ProductFavoriteChanged event) {
    _setItemFavorite(event.id, event.isInFavorite);
  }

  void _setItemFavorite(String productId, bool isFavorite) {
    var changed = false;
    final updated = state.items.map((item) {
      if (item.productId == productId && item.isInFavorites != isFavorite) {
        changed = true;
        return item.copyWith(isInFavorites: isFavorite);
      }
      return item;
    }).toList();

    if (!changed) return;
    state = state.copyWith(items: updated);
  }

  void _setItemCountLocally(String productId, int count) {
    final updated = state.items
        .map(
          (item) =>
              item.productId == productId ? item.copyWith(count: count) : item,
        )
        .toList();
    state = state.copyWith(items: updated, errorMessage: null);
  }

  void _removeItemLocally(String productId) {
    final updated = state.items
        .where((item) => item.productId != productId)
        .toList();
    if (updated.length == state.items.length) return;

    state = state.copyWith(
      reqState: updated.isEmpty ? ReqState.empty : ReqState.success,
      items: updated,
      errorMessage: null,
    );
  }

  Future<bool> loadCart({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(
        reqState: ReqState.loading,
        errorMessage: null,
      );
    }

    final useCase = ref.read(DI.getCartUseCaseProvider);
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
      (items) {
        state = state.copyWith(
          reqState: items.isEmpty ? ReqState.empty : ReqState.success,
          items: items,
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<bool> refresh() => loadCart(showLoading: !state.isSuccess);

  Future<Either<Failure, int>?> incrementItem(CartItemModel item) {
    return _updateItemCount(item, item.count + 1);
  }

  Future<Either<Failure, int>?> decrementItem(CartItemModel item) async {
    if (item.count <= 1) {
      final removeResult = await removeItem(item);
      if (removeResult == null) return null;
      return removeResult.map((_) => 0);
    }
    return _updateItemCount(item, item.count - 1);
  }

  Future<Either<Failure, int>?> _updateItemCount(
    CartItemModel item,
    int targetCount,
  ) async {
    final cartController = ref.read(cartControllerProvider.notifier);
    if (cartController.isPending(item.productId)) return null;

    final previousCount = item.count;
    _setItemCountLocally(item.productId, targetCount);

    final result = await cartController.updateItemCount(
      productId: item.productId,
      count: targetCount,
    );
    if (!ref.mounted) return null;

    result.fold(
      (_) => _setItemCountLocally(item.productId, previousCount),
      (savedCount) {
        if (savedCount != targetCount) {
          _setItemCountLocally(item.productId, savedCount);
        }
      },
    );
    return result;
  }

  Future<Either<Failure, Unit>?> removeItem(CartItemModel item) async {
    final cartController = ref.read(cartControllerProvider.notifier);
    if (cartController.isPending(item.productId)) return null;

    final previousItems = List<CartItemModel>.of(state.items);
    _removeItemLocally(item.productId);

    final result = await cartController.removeFromCart(item.productId);
    if (!ref.mounted) return null;

    result.fold(
      (_) => state = state.copyWith(
        reqState: previousItems.isEmpty ? ReqState.empty : ReqState.success,
        items: previousItems,
      ),
      (_) {},
    );
    return result;
  }

  Future<Either<Failure, Unit>?> clearCart() async {
    if (state.items.isEmpty) return null;

    final previousItems = List<CartItemModel>.of(state.items);
    state = state.copyWith(
      reqState: ReqState.empty,
      items: const [],
      errorMessage: null,
    );

    final result = await ref.read(cartControllerProvider.notifier).clearCart();
    if (!ref.mounted) return null;

    result.fold(
      (_) => state = state.copyWith(
        reqState: ReqState.success,
        items: previousItems,
      ),
      (_) {},
    );
    return result;
  }

  Future<Either<Failure, FavoriteStatus>?> toggleFavorite(
    CartItemModel item,
  ) async {
    final favoriteController = ref.read(favoriteControllerProvider.notifier);
    if (favoriteController.isPending(item.productId)) return null;

    final wasWishlisted = item.isInFavorites;
    _setItemFavorite(item.productId, !wasWishlisted);

    final result = await favoriteController.toggleFavorite(
      productId: item.productId,
      isCurrentlyFavorite: wasWishlisted,
    );

    if (!ref.mounted) return null;

    result.fold(
      (_) => _setItemFavorite(item.productId, wasWishlisted),
      (_) {},
    );
    return result;
  }
}

final cartScreenControllerProvider =
    NotifierProvider.autoDispose<CartScreenController, CartScreenState>(
      CartScreenController.new,
    );

