import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';

class ProductDetailsBottomBarWidget extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;

  const ProductDetailsBottomBarWidget({
    super.key,
    required this.price,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.paddingOf(context).bottom + 14,
      ),
      decoration: const BoxDecoration(
        color: ColorM.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: onAddToCart,
                style: FilledButton.styleFrom(
                  backgroundColor: ColorM.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorM.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

