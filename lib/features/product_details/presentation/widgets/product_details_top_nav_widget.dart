import 'package:flutter/material.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/theme/color_manager.dart';

class ProductDetailsTopNavWidget extends StatelessWidget {
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;
  final VoidCallback onShare;

  const ProductDetailsTopNavWidget({
    super.key,
    required this.isWishlisted,
    required this.onWishlistToggle,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF0F172A),
            ),
          ),
          Row(
            children: [
              _ActionButton(
                onPressed: onWishlistToggle,
                icon: Icon(
                  isWishlisted ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  size: 20,
                  color: isWishlisted ? Colors.red : const Color(0xFF334155),
                ),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                onPressed: onShare,
                icon: const Icon(
                  Icons.share_outlined,
                  size: 20,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ColorM.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
