import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';

class HomeBottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTabSelected;

  const HomeBottomNavBarWidget({
    super.key,
    this.currentIndex = 0,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorM.white.withValues(alpha: 0.96),
        border: const Border(
          top: BorderSide(
            color: ColorM.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              Expanded(
                child: _NavTabItem(
                  label: 'Home',
                  svgAsset: 'assets/svg/nav_home.svg',
                  isSelected: currentIndex == 0,
                  onTap: () => onTabSelected?.call(0),
                ),
              ),
              Expanded(
                child: _NavTabItem(
                  label: 'Profile',
                  svgAsset: 'assets/svg/nav_profile.svg',
                  isSelected: currentIndex == 1,
                  onTap: () => onTabSelected?.call(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  final String label;
  final String svgAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTabItem({
    required this.label,
    required this.svgAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? ColorM.primary : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: isSelected ? FontWeightM.bold : FontWeightM.medium,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
