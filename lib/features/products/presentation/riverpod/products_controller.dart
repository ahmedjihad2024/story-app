import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/network/failure_message.dart';
import '../../data/request/get_products_request.dart';
import '../../domain/model/product_filter_type.dart';
import 'products_state.dart';

class ProductsArgs {
  final ProductFilterType filterType;
  final String? categoryId;

  const ProductsArgs({
    required this.filterType,
    this.categoryId,
  });

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

class ProductsController extends Notifier<ProductsState> {
  final ProductFilterType filterType;
  final String? categoryId;

  ProductsController({
    required this.filterType,
    this.categoryId,
  });

  @override
  ProductsState build() {
    Future.microtask(loadInitial);
    return const ProductsState();
  }

  Future<void> loadInitial([GetProductsRequest? customRequest]) async {
    final request = customRequest ??
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
