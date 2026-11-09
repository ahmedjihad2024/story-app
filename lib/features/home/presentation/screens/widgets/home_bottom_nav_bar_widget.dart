import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';

class HomeBottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTabSelected;
  final VoidCallback? onAddPressed;

  const HomeBottomNavBarWidget({
    super.key,
    this.currentIndex = 0,
    this.onTabSelected,
    this.onAddPressed,
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
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Home and Profile items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Tab
                  GestureDetector(
                    onTap: () => onTabSelected?.call(0),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/nav_home.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              currentIndex == 0
                                  ? ColorM.primary
                                  : const Color(0xFF94A3B8),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: currentIndex == 0
                                  ? FontWeightM.bold
                                  : FontWeightM.medium,
                              color: currentIndex == 0
                                  ? ColorM.primary
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Center space for FAB
                  const SizedBox(width: 60),

                  // Profile Tab
                  GestureDetector(
                    onTap: () => onTabSelected?.call(1),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/nav_profile.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              currentIndex == 1
                                  ? ColorM.primary
                                  : const Color(0xFF94A3B8),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: currentIndex == 1
                                  ? FontWeightM.bold
                                  : FontWeightM.medium,
                              color: currentIndex == 1
                                  ? ColorM.primary
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Centered Floating Add Item Button
              Positioned(
                top: -16,
                child: GestureDetector(
                  onTap: onAddPressed,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: ColorM.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ColorM.primary.withValues(alpha: 0.45),
                          offset: const Offset(0, 8),
                          blurRadius: 24,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/svg/nav_add.svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

