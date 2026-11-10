import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';

class ProfileSignOutCardWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileSignOutCardWidget({
    super.key,
    this.onTap,
  });

  static const _roseColor = Color(0xFFF43F5E);
  static const _roseSurface = Color(0xFFFFF1F2);
  static const _roseBorder = Color(0xFFFFE4E6);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorM.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _roseBorder),
        boxShadow: [
          BoxShadow(
            color: _roseColor.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: _roseSurface,
          highlightColor: _roseSurface.withValues(alpha: 0.6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _roseSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: _roseColor,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.5,
                    fontWeight: FontWeightM.semiBold,
                    color: _roseColor,
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

