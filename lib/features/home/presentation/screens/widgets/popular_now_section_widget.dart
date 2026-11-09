import 'package:flutter/material.dart';
import '../../../domain/model/product_model.dart';
import 'home_section_header_widget.dart';
import 'popular_product_card_widget.dart';

class PopularNowSectionWidget extends StatelessWidget {
  final List<ProductModel> products;
  final void Function(ProductModel)? onProductTap;
  final void Function(ProductModel)? onWishlistToggle;
  final void Function(ProductModel)? onAddToCart;
  final VoidCallback? onSeeAllPressed;

  const PopularNowSectionWidget({
    super.key,
    this.products = ProductModel.samplePopularProducts,
    this.onProductTap,
    this.onWishlistToggle,
    this.onAddToCart,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: HomeSectionHeaderWidget(
            title: 'Popular Now',
            onActionPressed: onSeeAllPressed,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 310,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = products[index];
              return SizedBox(
                width: 180,
                child: PopularProductCardWidget(
                  product: item,
                  onTap: () => onProductTap?.call(item),
                  onWishlistToggle: () => onWishlistToggle?.call(item),
                  onAddToCart: () => onAddToCart?.call(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
