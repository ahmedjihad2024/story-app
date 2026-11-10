import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/failure_message.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../home/domain/model/product_model.dart';
import '../riverpod/product_details_controller.dart';
import '../widgets/product_details_bottom_bar_widget.dart';
import '../widgets/product_details_description_widget.dart';
import '../widgets/product_details_header_widget.dart';
import '../widgets/product_details_image_widget.dart';
import '../widgets/product_details_price_widget.dart';
import '../widgets/product_details_rating_widget.dart';
import '../widgets/product_details_top_nav_widget.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  void _handleWishlistToggle(
    BuildContext context,
    WidgetRef ref,
  ) async {
    ref
        .read(productDetailsControllerProvider(product).notifier)
        .toggleFavorite();
  }

  void _handleShare(BuildContext context, ProductModel currentProduct) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${currentProduct.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _handleAddToCart(
    BuildContext context,
    WidgetRef ref,
    ProductModel currentProduct,
  ) async {
    final result = await ref
        .read(productDetailsControllerProvider(product).notifier)
        .addToCart();
    if (result == null || !context.mounted) return;

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
          content: Text('Added ${currentProduct.title} to cart (Qty: $count)'),
          backgroundColor: ColorM.success,
          duration: const Duration(seconds: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailsControllerProvider(product));
    final currentProduct = state.product;

    return Scaffold(
      backgroundColor: ColorM.white,
      bottomNavigationBar: ProductDetailsBottomBarWidget(
        price: currentProduct.price,
        onAddToCart: () => _handleAddToCart(context, ref, currentProduct),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ProductDetailsTopNavWidget(
              isWishlisted: state.isWishlisted,
              onWishlistToggle: () => _handleWishlistToggle(context, ref),
              onShare: () => _handleShare(context, currentProduct),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductDetailsImageWidget(
                      imageUrl: currentProduct.imageUrl,
                      imageAsset: currentProduct.imageAsset,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductDetailsHeaderWidget(
                            brand: currentProduct.brand,
                            title: currentProduct.title,
                            discountPercentage:
                                currentProduct.discountPercentage,
                          ),
                          const SizedBox(height: 12),
                          ProductDetailsRatingWidget(
                            rating: currentProduct.rating,
                          ),
                          const SizedBox(height: 16),
                          ProductDetailsPriceWidget(
                            price: currentProduct.price,
                            originalPrice: currentProduct.originalPrice,
                            discountPercentage:
                                currentProduct.discountPercentage,
                          ),
                          const SizedBox(height: 24),
                          const Divider(
                            color: Color(0xFFF1F5F9),
                            thickness: 1,
                            height: 1,
                          ),
                          const SizedBox(height: 20),
                          ProductDetailsDescriptionWidget(
                            description: currentProduct.description,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
