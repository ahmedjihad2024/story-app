import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/screens/home_tab.dart';
import '../../../home/presentation/screens/widgets/home_bottom_nav_bar_widget.dart';
import '../riverpod/layout_controller.dart';
import 'profile_placeholder_screen.dart';

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
      bottomNavigationBar: HomeBottomNavBarWidget(
        currentIndex: currentIndex,
        onTabSelected: controller.setNavIndex,
        onAddPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Item pressed'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
      body: SafeArea(
        bottom: false,
        child: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: controller.setNavIndex,
          children: const [
            HomeTab(),
            ProfilePlaceholderScreen(),
          ],
        ),
      ),
    );
  }
}

