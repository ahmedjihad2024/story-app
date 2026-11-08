import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import '../riverpod/sign_in_controller.dart';

class RememberMeAndForgotPasswordWidget extends ConsumerWidget {
  final VoidCallback onForgotPassword;

  const RememberMeAndForgotPasswordWidget({
    super.key,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rememberMe = ref.watch(
      signInControllerProvider.select((s) => s.rememberMe),
    );
    final notifier = ref.read(signInControllerProvider.notifier);

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
                onChanged: (val) => notifier.toggleRememberMe(val ?? false),
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
              onTap: () => notifier.toggleRememberMe(!rememberMe),
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
