import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/network/failure_message.dart';
import '../../data/request/search_products_request.dart';
import '../../domain/model/search_filter_model.dart';
import 'search_state.dart';

class SearchController extends Notifier<SearchState> {
  Timer? _debounceTimer;

  @override
  SearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    Future.microtask(search);
    return const SearchState();
  }

  void onQueryChanged(String query) {
    if (state.query == query) return;
    state = state.copyWith(query: query);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      search();
    });
  }

  Future<void> applyFilter(SearchFilterModel filter) async {
    state = state.copyWith(filter: filter);
    await search();
  }

  Future<void> search() async {
    state = state.copyWith(
      reqState: ReqState.loading,
      page: 0,
      hasMore: true,
      errorMessage: null,
    );

    final request = SearchProductsRequest(
      query: state.query,
      filter: state.filter,
      page: 0,
    );

    final useCase = ref.read(DI.searchProductsUseCaseProvider);
    final result = await useCase(request);

    result.fold(
      (failure) {
        state = state.copyWith(
          reqState: ReqState.error,
          errorMessage: failure.message,
        );
      },
      (products) {
        if (products.isEmpty) {
          state = state.copyWith(
            reqState: ReqState.empty,
            products: const [],
            hasMore: false,
          );
        } else {
          state = state.copyWith(
            reqState: ReqState.success,
            products: products,
            page: 0,
            hasMore: products.length >= request.limit,
            errorMessage: null,
          );
        }
      },
    );
  }

  Future<void> refresh() => search();

  Future<bool> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) {
      return false;
    }

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.page + 1;
    final request = SearchProductsRequest(
      query: state.query,
      filter: state.filter,
      page: nextPage,
    );

    final useCase = ref.read(DI.searchProductsUseCaseProvider);
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

final searchControllerProvider =
    NotifierProvider.autoDispose<SearchController, SearchState>(
  SearchController.new,
);
