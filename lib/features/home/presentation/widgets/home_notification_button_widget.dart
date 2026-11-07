import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import 'home_action_icon_button_widget.dart';

class HomeNotificationButtonWidget extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const HomeNotificationButtonWidget({
    super.key,
    this.count = 2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        HomeActionIconButtonWidget(
          onTap: onTap,
          child: SvgPicture.asset(
            'assets/svg/notifications.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              ColorM.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
        if (count > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: ColorM.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorM.white,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                count > 9 ? '9+' : '$count',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeightM.bold,
                  color: ColorM.white,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

