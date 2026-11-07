import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';

class SocialLoginDividerWidget extends StatelessWidget {
  const SocialLoginDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: ColorM.divider,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR CONTINUE WITH',
            style: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 12,
              fontWeight: FontWeightM.semiBold,
              color: ColorM.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: ColorM.divider,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
