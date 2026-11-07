import 'package:flutter/material.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';

class SignInFooterWidget extends StatelessWidget {
  final VoidCallback onCreateAccountTap;

  const SignInFooterWidget({
    super.key,
    required this.onCreateAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?  ",
            style: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 14,
              fontWeight: FontWeightM.medium,
              color: ColorM.gray600,
            ),
          ),
          GestureDetector(
            onTap: onCreateAccountTap,
            child: Text(
              'Create an Account',
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 14,
                fontWeight: FontWeightM.semiBold,
                color: ColorM.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
