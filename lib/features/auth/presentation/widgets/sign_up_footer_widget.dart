import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';

class SignUpFooterWidget extends StatelessWidget {
  final VoidCallback onSignInTap;

  const SignUpFooterWidget({
    super.key,
    required this.onSignInTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 14,
              fontWeight: FontWeightM.medium,
              color: ColorM.textSecondary,
              height: 20 / 14,
            ),
          ),
          GestureDetector(
            onTap: onSignInTap,
            child: Text(
              'Sign in',
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 14,
                fontWeight: FontWeightM.bold,
                color: ColorM.primary,
                height: 20 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
