import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../../core/widgets/images/app_cached_image.dart';
import '../../../domain/model/order_details_item_model.dart';

class OrderDetailsItemCardWidget extends StatelessWidget {
  final OrderDetailsItemModel item;
  final VoidCallback onTap;

  const OrderDetailsItemCardWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Semantics(
      button: true,
      label: '${product.title}, quantity ${item.count}, total \$${item.totalPrice.toStringAsFixed(2)}',
      child: Container(
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
        child: Material(
          color: ColorM.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: ColorM.surfaceSecondary,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: ColorM.border),
                    ),
                    child: AppCachedImage(
                      imageUrl: product.imageUrl,
                      width: 82,
                      height: 82,
                      borderRadius: BorderRadius.circular(13),
                    ),
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
                                product.brand,
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
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 18,
                              color: ColorM.textSecondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.title,
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorM.surfaceSecondary,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: ColorM.border),
                              ),
                              child: Text(
                                'Qty: ${item.count}',
                                style: TextStyle(
                                  fontFamily: FontsM.inter.name,
                                  fontSize: 12,
                                  fontWeight: FontWeightM.semiBold,
                                  color: ColorM.gray700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '\$${item.priceAtPurchase.toStringAsFixed(2)} each',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: FontsM.inter.name,
                                  fontSize: 12,
                                  fontWeight: FontWeightM.regular,
                                  color: ColorM.textSecondary,
                                ),
                              ),
                            ),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: FontsM.inter.name,
                                fontSize: 15,
                                fontWeight: FontWeightM.bold,
                                color: ColorM.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

