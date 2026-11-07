import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import 'home_action_icon_button_widget.dart';
import 'home_notification_button_widget.dart';

class HomeAppBarWidget extends StatelessWidget {
  final VoidCallback? onCartPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onNotificationsPressed;

  const HomeAppBarWidget({
    super.key,
    this.onCartPressed,
    this.onProfilePressed,
    this.onNotificationsPressed,
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
              onTap: onCartPressed,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/user_avatar.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    size: 22,
                    color: ColorM.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            HomeNotificationButtonWidget(
              count: 2,
              onTap: onNotificationsPressed,
            ),
          ],
        ),
      ],
    );
  }
}

