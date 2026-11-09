import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'layout_state.dart';

class LayoutController extends Notifier<LayoutState> {
  late final PageController pageController;

  @override
  LayoutState build() {
    pageController = PageController();
    // Dispose when the provider is destroyed.
    ref.onDispose(pageController.dispose);
    return const LayoutState();
  }

  void setNavIndex(int index) {
    if (state.currentNavIndex == index) return;
    state = state.copyWith(currentNavIndex: index);
    pageController.jumpToPage(index);
  }
}

final layoutControllerProvider =
    NotifierProvider<LayoutController, LayoutState>(LayoutController.new);

