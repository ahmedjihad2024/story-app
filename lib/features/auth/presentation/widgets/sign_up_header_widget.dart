import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import 'brand_logo_widget.dart';

class SignUpHeaderWidget extends StatelessWidget {
  const SignUpHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandLogoWidget(),
        const SizedBox(height: 24),
        Text(
          'Create account',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 30,
            fontWeight: FontWeightM.bold,
            color: ColorM.textPrimary,
            letterSpacing: -0.75,
            height: 36 / 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join STOREY today',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 16,
            fontWeight: FontWeightM.regular,
            color: ColorM.textSecondary,
            height: 24 / 16,
          ),
        ),
      ],
    );
  }
}
