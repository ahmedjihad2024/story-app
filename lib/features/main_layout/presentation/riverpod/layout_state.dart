class LayoutState {
  final int currentNavIndex;

  const LayoutState({this.currentNavIndex = 0});

  LayoutState copyWith({int? currentNavIndex}) {
    return LayoutState(
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
    );
  }
}

