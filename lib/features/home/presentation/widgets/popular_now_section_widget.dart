import 'package:flutter/material.dart';
import '../../domain/model/product_model.dart';
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
        HomeSectionHeaderWidget(
          title: 'Popular Now',
          onActionPressed: onSeeAllPressed,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < products.length; i++) ...[
              if (i > 0) const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 323,
                  child: PopularProductCardWidget(
                    product: products[i],
                    onTap: () => onProductTap?.call(products[i]),
                    onWishlistToggle: () => onWishlistToggle?.call(products[i]),
                    onAddToCart: () => onAddToCart?.call(products[i]),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

