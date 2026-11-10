import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../../core/widgets/images/app_cached_image.dart';
import '../../../domain/model/product_model.dart';

class FeaturedProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistToggle;

  const FeaturedProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
    this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 160,
        height: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorM.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorM.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Discount badge & Wishlist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (product.discountPercentage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.discountPercentage,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeightM.semiBold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Semantics(
                  button: true,
                  label: product.isWishlisted
                      ? 'Remove ${product.title} from favorites'
                      : 'Add ${product.title} to favorites',
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: onWishlistToggle,
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg/heart_wishlist.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              product.isWishlisted
                                  ? ColorM.error
                                  : ColorM.textSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Product image
            Expanded(
              child: Center(
                child: AppCachedImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Brand
            Text(
              product.brand,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeightM.regular,
                color: ColorM.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            // Title
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeightM.semiBold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            // Rating
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/star.svg',
                  width: 11,
                  height: 11,
                ),
                const SizedBox(width: 4),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeightM.medium,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Price & Original price
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeightM.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '\$${product.originalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeightM.regular,
                    color: ColorM.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

