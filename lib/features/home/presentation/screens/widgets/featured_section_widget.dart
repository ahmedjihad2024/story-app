import 'package:flutter/material.dart';
import '../../../domain/model/product_model.dart';
import 'featured_product_card_widget.dart';
import 'home_section_header_widget.dart';

class FeaturedSectionWidget extends StatelessWidget {
  final List<ProductModel> products;
  final void Function(ProductModel)? onProductTap;
  final void Function(ProductModel)? onWishlistToggle;
  final VoidCallback? onSeeAllPressed;

  const FeaturedSectionWidget({
    super.key,
    required this.products,
    this.onProductTap,
    this.onWishlistToggle,
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
            title: 'Featured',
            onActionPressed: onSeeAllPressed,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = products[index];
              return FeaturedProductCardWidget(
                key: ValueKey(item.id),
                product: item,
                onTap: () => onProductTap?.call(item),
                onWishlistToggle: () => onWishlistToggle?.call(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
