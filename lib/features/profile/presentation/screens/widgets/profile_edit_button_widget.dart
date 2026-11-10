import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';

class ProfileEditButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileEditButtonWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorM.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorM.primary100),
        boxShadow: [
          BoxShadow(
            color: ColorM.primary.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: ColorM.primary50.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: ColorM.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeightM.semiBold,
                    color: ColorM.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

