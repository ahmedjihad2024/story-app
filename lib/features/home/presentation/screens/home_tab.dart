import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../../../core/widgets/state/state_render.dart';
import '../../../products/domain/model/product_filter_type.dart';
import '../../../products/presentation/screens/products_screen.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/home_model.dart';
import '../../domain/model/product_model.dart';
import '../../domain/model/promo_banner_model.dart';
import '../riverpod/home_controller.dart';
import '../riverpod/home_state.dart';
import 'widgets/categories_section_widget.dart';
import 'widgets/featured_section_widget.dart';
import 'widgets/hero_promo_banner_widget.dart';
import 'widgets/home_app_bar_widget.dart';
import 'widgets/home_search_bar_widget.dart';
import 'widgets/home_shimmer_loading.dart';
import 'widgets/popular_now_section_widget.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await ref.read(homeControllerProvider.notifier).refresh();
    if (!mounted) return;

    final state = ref.read(homeControllerProvider);
    if (state.isError) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted(resetFooterState: true);
    }
  }

  void _handleSearchTap() {
    context.pushNamed(Routes.search);
  }

  void _handleCategorySelected(CategoryModel category) {
    context.pushNamed(
      Routes.products,
      arguments: ProductsScreenArgs(
        filterType: ProductFilterType.category,
        categoryId: category.id,
        title: category.name,
      ),
    );
  }

  void _handleFeaturedSeeAll() {
    context.pushNamed(
      Routes.products,
      arguments: const ProductsScreenArgs(
        filterType: ProductFilterType.featured,
        title: 'Featured Products',
      ),
    );
  }

  void _handlePopularSeeAll() {
    context.pushNamed(
      Routes.products,
      arguments: const ProductsScreenArgs(
        filterType: ProductFilterType.popular,
        title: 'Popular Products',
      ),
    );
  }

  void _handleShopNowPressed(PromoBannerModel banner) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening promo: ${banner.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleAddToCart(ProductModel product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${product.title} to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final homeState = ref.watch(homeControllerProvider);

    // Show snackbar on error during refresh (listener pattern).
    ref.listen<HomeState>(homeControllerProvider, (prev, next) {
      if (next.isError && next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return StateRender(
      reqState: homeState.reqState,
      loading: (context) => const HomeShimmerLoading(),
      idle: (context) => const HomeShimmerLoading(),
      error: (context) => _HomeError(
        message: homeState.errorMessage ?? 'Something went wrong',
        onRetry: () => ref.read(homeControllerProvider.notifier).loadData(),
      ),
      success: (context) => _HomeContent(
        data: homeState.data!,
        refreshController: _refreshController,
        onRefresh: _handleRefresh,
        onSearchTap: _handleSearchTap,
        onCategorySelected: _handleCategorySelected,
        onFeaturedSeeAll: _handleFeaturedSeeAll,
        onPopularSeeAll: _handlePopularSeeAll,
        onShopNowPressed: _handleShopNowPressed,
        onAddToCart: _handleAddToCart,
      ),
    );
  }
}

// ── Widgets (converted from build helper functions) ──────────────────────────

class _HomeError extends StatelessWidget {
  const _HomeError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
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

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.data,
    required this.refreshController,
    required this.onRefresh,
    required this.onSearchTap,
    required this.onCategorySelected,
    required this.onFeaturedSeeAll,
    required this.onPopularSeeAll,
    required this.onShopNowPressed,
    required this.onAddToCart,
  });

  final HomeModel data;
  final RefreshController refreshController;
  final Future<void> Function() onRefresh;
  final VoidCallback onSearchTap;
  final void Function(CategoryModel) onCategorySelected;
  final VoidCallback onFeaturedSeeAll;
  final VoidCallback onPopularSeeAll;
  final void Function(PromoBannerModel) onShopNowPressed;
  final void Function(ProductModel) onAddToCart;

  @override
  Widget build(BuildContext context) {
    return CustomizedSmartRefresh(
      controller: refreshController,
      onRefresh: onRefresh,
      enableRefresh: true,
      enableLoading: false,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeAppBarWidget(
                  onCartPressed: () {},
                  onProfilePressed: () {},
                  onNotificationsPressed: () {},
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeSearchBarWidget(
                  readOnly: true,
                  onTap: onSearchTap,
                ),
              ),
              const SizedBox(height: 20),
              if (data.categories.isNotEmpty)
                CategoriesSectionWidget(
                  categories: data.categories,
                  onCategorySelected: onCategorySelected,
                ),
              const SizedBox(height: 20),
              if (data.banners.isNotEmpty)
                HeroPromoBannerWidget(
                  banners: data.banners,
                  onShopNowPressed: onShopNowPressed,
                ),
              const SizedBox(height: 20),
              if (data.featuredProducts.isNotEmpty)
                FeaturedSectionWidget(
                  products: data.featuredProducts,
                  onWishlistToggle: (_) {},
                  onProductTap: (_) {},
                  onSeeAllPressed: onFeaturedSeeAll,
                ),
              const SizedBox(height: 20),
              if (data.popularProducts.isNotEmpty)
                PopularNowSectionWidget(
                  products: data.popularProducts,
                  onWishlistToggle: (_) {},
                  onAddToCart: onAddToCart,
                  onProductTap: (_) {},
                  onSeeAllPressed: onPopularSeeAll,
                ),
              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
    );
  }
}
