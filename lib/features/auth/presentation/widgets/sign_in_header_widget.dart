import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import 'brand_logo_widget.dart';

class SignInHeaderWidget extends StatelessWidget {
  const SignInHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandLogoWidget(),
        const SizedBox(height: 24),
        Text(
          'Sign in',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 30,
            fontWeight: FontWeightM.bold,
            color: ColorM.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back to STOREY',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 16,
            fontWeight: FontWeightM.regular,
            color: ColorM.textSecondary,
          ),
        ),
      ],
    );
  }
}
