import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/network/failure_message.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../../../core/widgets/state/state_render.dart';
import '../../../home/domain/model/product_model.dart';
import '../../../products/presentation/widgets/product_grid_card_widget.dart';
import '../../../products/presentation/widgets/products_grid_shimmer.dart';
import '../riverpod/favorites_controller.dart';
import '../riverpod/favorites_state.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await ref.read(favoritesControllerProvider.notifier).refresh();
    if (!mounted) return;

    final state = ref.read(favoritesControllerProvider);
    if (state.isError) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted(resetFooterState: true);
    }
  }

  Future<void> _handleLoadMore() async {
    final hasMore = await ref
        .read(favoritesControllerProvider.notifier)
        .loadMore();

    if (!mounted) return;

    if (hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  Future<void> _handleAddToCart(ProductModel product) async {
    final result = await ref
        .read(favoritesControllerProvider.notifier)
        .addToCart(product);
    if (result == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    result.fold(
      (failure) => messenger.showSnackBar(
        SnackBar(
          content: Text(failure.message),
          backgroundColor: ColorM.error,
          duration: const Duration(seconds: 2),
        ),
      ),
      (count) => messenger.showSnackBar(
        SnackBar(
          content: Text('Added ${product.title} to cart (Qty: $count)'),
          backgroundColor: ColorM.success,
          duration: const Duration(seconds: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoritesControllerProvider);

    ref.listen<FavoritesState>(favoritesControllerProvider, (prev, next) {
      if (next.isError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

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
        title: const Text(
          'Favorites',
          style: TextStyle(
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
        error: (context) => _FavoritesError(
          message: state.errorMessage ?? 'Something went wrong',
          onRetry: () =>
              ref.read(favoritesControllerProvider.notifier).loadInitial(),
        ),
        empty: (context) => _FavoritesEmpty(
          onRefresh: () =>
              ref.read(favoritesControllerProvider.notifier).loadInitial(),
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
                onTap: () => context.pushNamed(
                  Routes.productDetails,
                  arguments: product,
                ),
                onWishlistToggle: () => ref
                    .read(favoritesControllerProvider.notifier)
                    .toggleFavorite(product),
                onAddToCart: () => _handleAddToCart(product),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FavoritesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FavoritesError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesEmpty extends StatelessWidget {
  final VoidCallback onRefresh;

  const _FavoritesEmpty({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            const Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Products you save to your wishlist will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

