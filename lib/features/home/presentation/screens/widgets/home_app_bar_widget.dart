import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import 'home_action_icon_button_widget.dart';

class HomeAppBarWidget extends StatelessWidget {
  final VoidCallback? onFavoritesPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onProfilePressed;

  const HomeAppBarWidget({
    super.key,
    this.onFavoritesPressed,
    this.onCartPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Good morning 👋',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeightM.regular,
                color: ColorM.textSecondary,
                height: 16 / 12,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'STOREY',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeightM.bold,
                color: ColorM.primary,
                letterSpacing: 0.5,
                height: 28 / 20,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeActionIconButtonWidget(
              onTap: onFavoritesPressed,
              semanticLabel: 'Favorites',
              child: SvgPicture.asset(
                'assets/svg/heart_wishlist.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  ColorM.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 10),
            HomeActionIconButtonWidget(
              onTap: onCartPressed,
              semanticLabel: 'Shopping cart',
              child: SvgPicture.asset(
                'assets/svg/shopping_bag.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  ColorM.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 10),
            HomeActionIconButtonWidget(
              onTap: onProfilePressed,
              semanticLabel: 'Profile',
              child: const Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: ColorM.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

