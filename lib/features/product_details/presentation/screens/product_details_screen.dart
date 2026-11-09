import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../home/domain/model/product_model.dart';
import '../widgets/product_details_bottom_bar_widget.dart';
import '../widgets/product_details_description_widget.dart';
import '../widgets/product_details_header_widget.dart';
import '../widgets/product_details_image_widget.dart';
import '../widgets/product_details_price_widget.dart';
import '../widgets/product_details_rating_widget.dart';
import '../widgets/product_details_top_nav_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late bool _isWishlisted;

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.product.isWishlisted;
  }

  void _handleWishlistToggle() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isWishlisted ? 'Added to wishlist' : 'Removed from wishlist',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${widget.product.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${widget.product.title} to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: ColorM.white,
      bottomNavigationBar: ProductDetailsBottomBarWidget(
        price: product.price,
        onAddToCart: _handleAddToCart,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ProductDetailsTopNavWidget(
              isWishlisted: _isWishlisted,
              onWishlistToggle: _handleWishlistToggle,
              onShare: _handleShare,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductDetailsImageWidget(
                      imageUrl: product.imageUrl,
                      imageAsset: product.imageAsset,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductDetailsHeaderWidget(
                            brand: product.brand,
                            title: product.title,
                            discountPercentage: product.discountPercentage,
                          ),
                          const SizedBox(height: 12),
                          ProductDetailsRatingWidget(
                            rating: product.rating,
                          ),
                          const SizedBox(height: 16),
                          ProductDetailsPriceWidget(
                            price: product.price,
                            originalPrice: product.originalPrice,
                            discountPercentage: product.discountPercentage,
                          ),
                          const SizedBox(height: 24),
                          const Divider(
                            color: Color(0xFFF1F5F9),
                            thickness: 1,
                            height: 1,
                          ),
                          const SizedBox(height: 20),
                          ProductDetailsDescriptionWidget(
                            description: product.description,
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
