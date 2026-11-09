import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../../../core/widgets/state/state_render.dart';
import '../../../products/presentation/widgets/product_grid_card_widget.dart';
import '../../../products/presentation/widgets/products_grid_shimmer.dart';
import '../../domain/model/search_filter_model.dart';
import '../riverpod/search_controller.dart';
import '../widgets/search_app_bar_widget.dart';
import '../widgets/search_empty_widget.dart';
import '../widgets/search_error_widget.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await ref.read(searchControllerProvider.notifier).refresh();
    if (!mounted) return;

    final state = ref.read(searchControllerProvider);
    if (state.isError) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted(resetFooterState: true);
    }
  }

  Future<void> _handleLoadMore() async {
    final hasMore =
        await ref.read(searchControllerProvider.notifier).loadMore();
    if (!mounted) return;

    if (hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  Future<void> _openFilterScreen() async {
    final currentFilter = ref.read(searchControllerProvider).filter;
    final newFilter = await context.pushNamed<SearchFilterModel>(
      Routes.filter,
      arguments: currentFilter,
    );
    if (newFilter != null && mounted) {
      ref.read(searchControllerProvider.notifier).applyFilter(newFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: SearchAppBarWidget(
        controller: _searchController,
        activeFilterCount: state.filter.activeFiltersCount,
        onQueryChanged: (query) =>
            ref.read(searchControllerProvider.notifier).onQueryChanged(query),
        onClear: () {
          _searchController.clear();
          ref.read(searchControllerProvider.notifier).onQueryChanged('');
        },
        onFilterPressed: _openFilterScreen,
      ),
      body: StateRender(
        reqState: state.reqState,
        loading: (context) => const ProductsGridShimmer(),
        idle: (context) => const ProductsGridShimmer(),
        error: (context) => SearchErrorWidget(
          message: state.errorMessage ?? 'Something went wrong',
          onRetry: () => ref.read(searchControllerProvider.notifier).search(),
        ),
        empty: (context) => SearchEmptyWidget(
          query: state.query,
          hasFilter: state.filter.activeFiltersCount > 0,
          onResetFilter: () => ref
              .read(searchControllerProvider.notifier)
              .applyFilter(const SearchFilterModel()),
        ),
        success: (context) => CustomizedSmartRefresh(
          controller: _refreshController,
          enableRefresh: true,
          enableLoading: state.hasMore,
          onRefresh: _handleRefresh,
          onLoading: _handleLoadMore,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: state.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductGridCardWidget(
                product: product,
                onTap: () => context.pushNamed(
                  Routes.productDetails,
                  arguments: product,
                ),
                onWishlistToggle: () {},
                onAddToCart: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${product.title} to cart'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
