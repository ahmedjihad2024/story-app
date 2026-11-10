import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';

class CartEmptyWidget extends StatelessWidget {
  final VoidCallback onShopNow;

  const CartEmptyWidget({
    super.key,
    required this.onShopNow,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: ColorM.primary50,
                shape: BoxShape.circle,
                border: Border.all(color: ColorM.primary100),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 38,
                color: ColorM.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 19,
                fontWeight: FontWeightM.bold,
                color: ColorM.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you haven’t added any products yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 14,
                color: ColorM.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onShopNow,
              style: FilledButton.styleFrom(
                backgroundColor: ColorM.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.storefront_outlined, size: 18),
              label: Text(
                'Browse Products',
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 14,
                  fontWeight: FontWeightM.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

