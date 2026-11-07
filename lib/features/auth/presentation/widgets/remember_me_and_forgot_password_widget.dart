import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';

class RememberMeAndForgotPasswordWidget extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onForgotPassword;

  const RememberMeAndForgotPasswordWidget({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: rememberMe,
                onChanged: onRememberMeChanged,
                activeColor: ColorM.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(
                  color: ColorM.border,
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onRememberMeChanged(!rememberMe),
              child: Text(
                'Remember me',
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 14,
                  fontWeight: FontWeightM.medium,
                  color: ColorM.gray600,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onForgotPassword,
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 14,
              fontWeight: FontWeightM.semiBold,
              color: ColorM.primary,
            ),
          ),
        ),
      ],
    );
  }
}
