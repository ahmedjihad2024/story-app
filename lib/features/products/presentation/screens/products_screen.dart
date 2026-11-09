import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../../../core/widgets/state/state_render.dart';
import '../../domain/model/product_filter_type.dart';
import '../riverpod/products_controller.dart';
import '../riverpod/products_state.dart';
import '../widgets/product_grid_card_widget.dart';
import '../widgets/products_grid_shimmer.dart';

class ProductsScreenArgs {
  final ProductFilterType filterType;
  final String? categoryId;
  final String title;

  const ProductsScreenArgs({
    required this.filterType,
    this.categoryId,
    required this.title,
  });
}

class ProductsScreen extends ConsumerStatefulWidget {
  final ProductFilterType filterType;
  final String? categoryId;
  final String title;

  const ProductsScreen({
    super.key,
    required this.filterType,
    this.categoryId,
    required this.title,
  });

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final RefreshController _refreshController = RefreshController();

  ProductsArgs get _args => ProductsArgs(
        filterType: widget.filterType,
        categoryId: widget.categoryId,
      );

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await ref.read(productsControllerProvider(_args).notifier).refresh();
    if (!mounted) return;

    final state = ref.read(productsControllerProvider(_args));
    if (state.isError) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted(resetFooterState: true);
    }
  }

  Future<void> _handleLoadMore() async {
    final hasMore = await ref
        .read(productsControllerProvider(_args).notifier)
        .loadMore();

    if (!mounted) return;

    if (hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsControllerProvider(_args));

    ref.listen<ProductsState>(
      productsControllerProvider(_args),
      (prev, next) {
        if (next.isError && next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage!)),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: ColorM.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF0F172A),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: ColorM.border,
            height: 1,
          ),
        ),
      ),
      body: StateRender(
        reqState: state.reqState,
        loading: (context) => const ProductsGridShimmer(),
        idle: (context) => const ProductsGridShimmer(),
        error: (context) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 56,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => ref
                      .read(productsControllerProvider(_args).notifier)
                      .loadInitial(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        empty: (context) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'There are no products matching this criteria.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => ref
                      .read(productsControllerProvider(_args).notifier)
                      .loadInitial(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
        success: (context) => CustomizedSmartRefresh(
          controller: _refreshController,
          onRefresh: _handleRefresh,
          onLoading: _handleLoadMore,
          enableRefresh: true,
          enableLoading: state.hasMore,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductGridCardWidget(
                product: product,
                onTap: () {},
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
