import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/screens/home_tab.dart';
import '../../../home/presentation/screens/widgets/home_bottom_nav_bar_widget.dart';
import '../../../profile/presentation/screens/profile_tab.dart';
import '../riverpod/layout_controller.dart';

class MainLayoutScreen extends ConsumerWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(layoutControllerProvider.notifier);
    final currentIndex = ref.watch(
      layoutControllerProvider.select((s) => s.currentNavIndex),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: controller.setNavIndex,
              children: const [
                HomeTab(),
                ProfileTab(),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HomeBottomNavBarWidget(
                  currentIndex: currentIndex,
                  onTabSelected: controller.setNavIndex,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
