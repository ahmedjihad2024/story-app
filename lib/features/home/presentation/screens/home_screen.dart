import 'package:flutter/material.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/product_model.dart';
import '../../domain/model/promo_banner_model.dart';
import '../widgets/categories_section_widget.dart';
import '../widgets/featured_section_widget.dart';
import '../widgets/hero_promo_banner_widget.dart';
import '../widgets/home_app_bar_widget.dart';
import '../widgets/home_bottom_nav_bar_widget.dart';
import '../widgets/home_search_bar_widget.dart';
import '../widgets/popular_now_section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  int _currentNavIndex = 0;
  late List<ProductModel> _featuredProducts;
  late List<ProductModel> _popularProducts;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _featuredProducts = List.of(ProductModel.sampleFeaturedProducts);
    _popularProducts = List.of(ProductModel.samplePopularProducts);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    // Simulate network latency / cubit refresh matching Dokkan pattern
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() {
      _featuredProducts = List.of(ProductModel.sampleFeaturedProducts);
      _popularProducts = List.of(ProductModel.samplePopularProducts);
    });

    _refreshController.refreshCompleted(resetFooterState: true);
  }

  void _handleCategorySelected(CategoryModel category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected category: ${category.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleWishlistToggle(ProductModel product, bool isFeatured) {
    setState(() {
      if (isFeatured) {
        final index = _featuredProducts.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _featuredProducts[index] = _featuredProducts[index].copyWith(
            isWishlisted: !_featuredProducts[index].isWishlisted,
          );
        }
      } else {
        final index = _popularProducts.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _popularProducts[index] = _popularProducts[index].copyWith(
            isWishlisted: !_popularProducts[index].isWishlisted,
          );
        }
      }
    });
  }

  void _handleAddToCart(ProductModel product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${product.title} to cart'),
        duration: const Duration(seconds: 1),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: CustomizedSmartRefresh(
          controller: _refreshController,
          onRefresh: _handleRefresh,
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
                      onProfilePressed: () {
                        setState(() => _currentNavIndex = 1);
                      },
                      onNotificationsPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HomeSearchBarWidget(
                      onChanged: (query) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategoriesSectionWidget(
                      onCategorySelected: _handleCategorySelected,
                      onSeeAllPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  HeroPromoBannerWidget(
                    onShopNowPressed: _handleShopNowPressed,
                  ),
                  const SizedBox(height: 20),
                  FeaturedSectionWidget(
                    products: _featuredProducts,
                    onWishlistToggle: (product) =>
                        _handleWishlistToggle(product, true),
                    onProductTap: (product) {},
                    onSeeAllPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PopularNowSectionWidget(
                      products: _popularProducts,
                      onWishlistToggle: (product) =>
                          _handleWishlistToggle(product, false),
                      onAddToCart: _handleAddToCart,
                      onProductTap: (product) {},
                      onSeeAllPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 100),
                ]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavBarWidget(
        currentIndex: _currentNavIndex,
        onTabSelected: (index) {
          setState(() => _currentNavIndex = index);
        },
        onAddPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Item pressed'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
