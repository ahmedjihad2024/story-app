import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storey_app/core/di/dependency_injection.dart';
import 'package:storey_app/core/enums/req_state.dart';
import 'package:storey_app/core/events/app_event_bus.dart';
import 'package:storey_app/core/events/event_bus_mixin.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import 'package:storey_app/core/network/failure_message.dart';
import 'package:storey_app/core/shared/features/favorite/data/request/get_favorites_request.dart';
import 'package:storey_app/core/shared/riverpod/cart/cart_controller.dart';
import 'package:storey_app/core/shared/riverpod/favorite/favorite_controller.dart';
import 'package:storey_app/features/home/domain/model/product_model.dart';
import 'favorites_state.dart';

class FavoritesController extends Notifier<FavoritesState> with EventBusMixin {
  final Set<String> _togglingIds = {};

  @override
  FavoritesState build() {
    subscribe<ProductFavoriteChanged>(_onFavoriteChanged);
    ref.onDispose(_togglingIds.clear);
    Future.microtask(loadInitial);
    return const FavoritesState();
  }

  void _onFavoriteChanged(ProductFavoriteChanged event) {
    if (_togglingIds.contains(event.id)) {
      _setProductFavorite(event.id, event.isInFavorite);
      return;
    }

    if (!event.isInFavorite) {
      _removeFromList(event.id);
      return;
    }

    if (!state.products.any((p) => p.id == event.id) &&
        (state.isSuccess || state.isEmpty)) {
      Future.microtask(_refreshSilently);
    }
  }

  void _setProductFavorite(String productId, bool isFavorite) {
    var changed = false;
    final updated = state.products.map((p) {
      if (p.id == productId && p.isWishlisted != isFavorite) {
        changed = true;
        return p.copyWith(isWishlisted: isFavorite);
      }
      return p;
    }).toList();

    if (!changed) return;
    state = state.copyWith(products: updated);
  }

  void _removeFromList(String productId) {
    final updated = state.products.where((p) => p.id != productId).toList();
    if (updated.length == state.products.length) return;

    state = state.copyWith(
      reqState: updated.isEmpty ? ReqState.empty : state.reqState,
      products: updated,
    );
  }

  void _applyFirstPage(List<ProductModel> list, int limit) {
    state = state.copyWith(
      reqState: list.isEmpty ? ReqState.empty : ReqState.success,
      products: list,
      page: 0,
      hasMore: list.length >= limit,
      errorMessage: null,
    );
  }

  Future<void> loadInitial() async {
    state = state.copyWith(
      reqState: ReqState.loading,
      errorMessage: null,
      page: 0,
      hasMore: true,
    );

    const request = GetFavoritesRequest(page: 0);
    final useCase = ref.read(DI.getFavoritesUseCaseProvider);
    final result = await useCase(request);

    if (!ref.mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          reqState: ReqState.error,
          errorMessage: failure.message,
        );
      },
      (list) => _applyFirstPage(list, request.limit),
    );
  }

  Future<void> _refreshSilently() async {
    const request = GetFavoritesRequest(page: 0);
    final useCase = ref.read(DI.getFavoritesUseCaseProvider);
    final result = await useCase(request);

    if (!ref.mounted) return;

    result.fold(
      (_) {},
      (list) => _applyFirstPage(list, request.limit),
    );
  }

  Future<void> refresh() => loadInitial();

  Future<bool> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) {
      return false;
    }

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.page + 1;
    final request = GetFavoritesRequest(page: nextPage);
    final useCase = ref.read(DI.getFavoritesUseCaseProvider);
    final result = await useCase(request);

    if (!ref.mounted) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(isLoadingMore: false);
        return false;
      },
      (newProducts) {
        final existingIds = state.products.map((p) => p.id).toSet();
        final uniqueNew = newProducts
            .where((p) => !existingIds.contains(p.id))
            .toList();
        final updatedProducts = [...state.products, ...uniqueNew];
        state = state.copyWith(
          products: updatedProducts,
          page: nextPage,
          hasMore: newProducts.length >= request.limit,
          isLoadingMore: false,
        );
        return true;
      },
    );
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final favoriteController = ref.read(favoriteControllerProvider.notifier);
    if (favoriteController.isPending(product.id)) return;

    final wasWishlisted = product.isWishlisted;
    _togglingIds.add(product.id);
    _setProductFavorite(product.id, !wasWishlisted);

    try {
      final result = await favoriteController.toggleFavorite(
        productId: product.id,
        isCurrentlyFavorite: wasWishlisted,
      );

      if (!ref.mounted) return;

      result.fold(
        (_) => _setProductFavorite(product.id, wasWishlisted),
        (status) {
          if (!status.isInFavorite) {
            _removeFromList(product.id);
          }
        },
      );
    } finally {
      _togglingIds.remove(product.id);
    }
  }

  Future<Either<Failure, int>?> addToCart(
    ProductModel product, {
    int count = 1,
  }) {
    final cartController = ref.read(cartControllerProvider.notifier);
    if (cartController.isPending(product.id)) return Future.value(null);
    return cartController.addToCart(productId: product.id, count: count);
  }
}

final favoritesControllerProvider =
    NotifierProvider.autoDispose<FavoritesController, FavoritesState>(
      FavoritesController.new,
    );
