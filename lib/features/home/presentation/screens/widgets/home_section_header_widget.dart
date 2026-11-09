import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';

class HomeSectionHeaderWidget extends StatelessWidget {
  final String title;
  final String actionTitle;
  final VoidCallback? onActionPressed;

  const HomeSectionHeaderWidget({
    super.key,
    required this.title,
    this.actionTitle = 'See All',
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeightM.bold,
            color: ColorM.textPrimary,
            height: 28 / 18,
          ),
        ),
        if(onActionPressed != null) GestureDetector(
          onTap: onActionPressed,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              actionTitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeightM.semiBold,
                color: ColorM.primary,
                height: 20 / 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

