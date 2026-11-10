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
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 260);

    return Container(
      height: 64,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorM.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: ColorM.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: duration,
            curve: Curves.easeOutCubic,
            alignment: currentIndex == 0
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.centerEnd,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorM.primary,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: ColorM.primary.withValues(alpha: 0.28),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _NavTabItem(
                  label: 'Home',
                  svgAsset: 'assets/svg/nav_home.svg',
                  isSelected: currentIndex == 0,
                  animationDuration: duration,
                  onTap: () => onTabSelected?.call(0),
                ),
              ),
              Expanded(
                child: _NavTabItem(
                  label: 'Profile',
                  svgAsset: 'assets/svg/nav_profile.svg',
                  isSelected: currentIndex == 1,
                  animationDuration: duration,
                  onTap: () => onTabSelected?.call(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  final String label;
  final String svgAsset;
  final bool isSelected;
  final Duration animationDuration;
  final VoidCallback onTap;

  const _NavTabItem({
    required this.label,
    required this.svgAsset,
    required this.isSelected,
    required this.animationDuration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final targetColor = isSelected ? ColorM.white : ColorM.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: SizedBox.expand(
            child: TweenAnimationBuilder<Color?>(
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              tween: ColorTween(end: targetColor),
              builder: (context, animatedColor, _) {
                final color = animatedColor ?? targetColor;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      svgAsset,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        fontWeight: isSelected
                            ? FontWeightM.semiBold
                            : FontWeightM.medium,
                        color: color,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
