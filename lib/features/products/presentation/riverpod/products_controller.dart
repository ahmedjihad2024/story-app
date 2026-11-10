import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storey_app/core/events/app_event_bus.dart';
import 'package:storey_app/core/events/event_bus_mixin.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import 'package:storey_app/core/shared/riverpod/cart/cart_controller.dart';
import 'package:storey_app/core/shared/riverpod/favorite/favorite_controller.dart';
import 'package:storey_app/features/home/domain/model/product_model.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/network/failure_message.dart';
import '../../data/request/get_products_request.dart';
import '../../domain/model/product_filter_type.dart';
import 'products_state.dart';

class ProductsArgs {
  final ProductFilterType filterType;
  final String? categoryId;

  const ProductsArgs({required this.filterType, this.categoryId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsArgs &&
          runtimeType == other.runtimeType &&
          filterType == other.filterType &&
          categoryId == other.categoryId;

  @override
  int get hashCode => filterType.hashCode ^ categoryId.hashCode;
}

class ProductsController extends Notifier<ProductsState> with EventBusMixin {
  final ProductFilterType filterType;
  final String? categoryId;

  ProductsController({required this.filterType, this.categoryId});

  @override
  ProductsState build() {
    subscribe<ProductFavoriteChanged>(_onFavoriteChanged);
    Future.microtask(loadInitial);
    return const ProductsState();
  }

  void _onFavoriteChanged(ProductFavoriteChanged f) {
    _setProductFavorite(f.id, f.isInFavorite);
  }

  void _setProductFavorite(String productId, bool isFavorite) {
    var changed = false;
    final products = state.products.map((p) {
      if (p.id == productId && p.isWishlisted != isFavorite) {
        changed = true;
        return p.copyWith(isWishlisted: isFavorite);
      }
      return p;
    }).toList();

    if (!changed) return;
    state = state.copyWith(products: products);
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final favoriteController = ref.read(favoriteControllerProvider.notifier);
    if (favoriteController.isPending(product.id)) return;

    final wasWishlisted = product.isWishlisted;
    _setProductFavorite(product.id, !wasWishlisted);

    final result = await favoriteController.toggleFavorite(
      productId: product.id,
      isCurrentlyFavorite: wasWishlisted,
    );

    if (!ref.mounted) return;

    result.fold(
      (_) => _setProductFavorite(product.id, wasWishlisted),
      (_) {},
    );
  }

  Future<Either<Failure, int>?> addToCart(
    ProductModel product, {
    int count = 1,
  }) {
    final cartController = ref.read(cartControllerProvider.notifier);
    if (cartController.isPending(product.id)) return Future.value(null);
    return cartController.addToCart(productId: product.id, count: count);
  }

  Future<void> loadInitial([GetProductsRequest? customRequest]) async {
    final request =
        customRequest ??
        GetProductsRequest(
          filterType: filterType,
          categoryId: categoryId,
          page: 0,
        );

    state = state.copyWith(
      reqState: ReqState.loading,
      errorMessage: null,
      page: 0,
      hasMore: true,
    );

    final useCase = ref.read(DI.getProductsUseCaseProvider);
    final result = await useCase(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          reqState: ReqState.error,
          errorMessage: failure.message,
        );
      },
      (list) {
        if (list.isEmpty) {
          state = state.copyWith(
            reqState: ReqState.empty,
            products: const [],
            hasMore: false,
          );
        } else {
          state = state.copyWith(
            reqState: ReqState.success,
            products: list,
            page: 0,
            hasMore: list.length >= request.limit,
            errorMessage: null,
          );
        }
      },
    );
  }

  Future<void> refresh() => loadInitial();

  Future<bool> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) {
      return false;
    }

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.page + 1;
    final request = GetProductsRequest(
      filterType: filterType,
      categoryId: categoryId,
      page: nextPage,
    );

    final useCase = ref.read(DI.getProductsUseCaseProvider);
    final result = await useCase(request);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoadingMore: false);
        return false;
      },
      (newProducts) {
        final updatedProducts = [...state.products, ...newProducts];
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
}

final productsControllerProvider = NotifierProvider.autoDispose
    .family<ProductsController, ProductsState, ProductsArgs>(
      (arg) => ProductsController(
        filterType: arg.filterType,
        categoryId: arg.categoryId,
      ),
    );
