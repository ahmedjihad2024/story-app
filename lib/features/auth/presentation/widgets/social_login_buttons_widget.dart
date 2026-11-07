import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';

class SocialLoginButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: ColorM.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorM.border,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 14,
                fontWeight: FontWeightM.semiBold,
                color: ColorM.gray800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialLoginButtonsWidget extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  const SocialLoginButtonsWidget({
    super.key,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            icon: const Icon(
              Icons.g_mobiledata_rounded,
              color: Color(0xFF4285F4),
              size: 24,
            ),
            label: 'Google',
            onTap: onGoogleTap,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SocialLoginButton(
            icon: const Icon(
              Icons.apple,
              color: ColorM.black,
              size: 22,
            ),
            label: 'Apple',
            onTap: onAppleTap,
          ),
        ),
      ],
    );
  }
}
