import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/shared/features/cart/domain/model/cart_item_model.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../../core/widgets/images/app_cached_image.dart';

class CartItemCardWidget extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback onWishlistToggle;

  const CartItemCardWidget({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorM.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorM.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CartItemThumbnail(
            imageUrl: item.imageUrl,
            discountLabel: item.formattedDiscount,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontsM.inter.name,
                          fontSize: 11.5,
                          fontWeight: FontWeightM.medium,
                          color: ColorM.textSecondary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onWishlistToggle,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: SvgPicture.asset(
                          'assets/svg/heart_wishlist.svg',
                          width: 17,
                          height: 17,
                          colorFilter: ColorFilter.mode(
                            item.isInFavorites
                                ? ColorM.error
                                : const Color(0xFF94A3B8),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onRemove,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 19,
                          color: ColorM.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontsM.inter.name,
                    fontSize: 14.5,
                    fontWeight: FontWeightM.semiBold,
                    color: ColorM.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontFamily: FontsM.inter.name,
                                  fontSize: 16,
                                  fontWeight: FontWeightM.bold,
                                  color: ColorM.textPrimary,
                                ),
                              ),
                              if (item.hasDiscount)
                                Text(
                                  '\$${item.totalOriginalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontFamily: FontsM.inter.name,
                                    fontSize: 12,
                                    color: ColorM.textHint,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                          if (item.count > 1) ...[
                            const SizedBox(height: 2),
                            Text(
                              '\$${item.price.toStringAsFixed(2)} each',
                              style: TextStyle(
                                fontFamily: FontsM.inter.name,
                                fontSize: 11,
                                color: ColorM.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _QuantityStepper(
                      count: item.count,
                      onDecrement: onDecrement,
                      onIncrement: onIncrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemThumbnail extends StatelessWidget {
  final String? imageUrl;
  final String discountLabel;

  const _CartItemThumbnail({
    required this.imageUrl,
    required this.discountLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: ColorM.surfaceSecondary,
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: AppCachedImage(
            imageUrl: imageUrl,
            width: 88,
            height: 88,
            fit: BoxFit.contain,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        if (discountLabel.isNotEmpty)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                discountLabel,
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 9.5,
                  fontWeight: FontWeightM.bold,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrement = count > 1;

    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: ColorM.background,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: ColorM.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperIconButton(
            icon: Icons.remove_rounded,
            color: canDecrement ? ColorM.textPrimary : ColorM.textHint,
            onTap: canDecrement ? onDecrement : null,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 28),
            alignment: Alignment.center,
            child: Text(
              '$count',
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 13.5,
                fontWeight: FontWeightM.semiBold,
                color: ColorM.textPrimary,
              ),
            ),
          ),
          _StepperIconButton(
            icon: Icons.add_rounded,
            color: ColorM.primary,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepperIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StepperIconButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 32,
        height: 34,
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

