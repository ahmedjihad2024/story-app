import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../theme/color_manager.dart';
import '../../theme/fonts_manager.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart' show RefreshController;

class CustomizedSmartRefresh extends StatelessWidget {
  final Widget child;
  final RefreshController controller;
  final ScrollController? scrollController;
  final void Function()? onLoading;
  final void Function()? onRefresh;
  final bool enableLoading;
  final bool enableRefresh;
  final EdgeInsetsGeometry? classicFooterPadding;
  final ScrollPhysics? physics;
  final RefreshStyle? refreshStyle;

  const CustomizedSmartRefresh({
    super.key,
    required this.child,
    required this.controller,
    this.scrollController,
    this.onLoading,
    this.onRefresh,
    this.enableLoading = false,
    this.enableRefresh = true,
    this.classicFooterPadding,
    this.physics,
    this.refreshStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      key: super.key,
      controller: controller,
      scrollController: scrollController,
      enablePullUp: enableLoading,
      enablePullDown: enableRefresh,
      physics: physics,
      header: ClassicHeader(
        refreshStyle: refreshStyle ?? RefreshStyle.Behind,
        idleIcon: const Icon(Icons.arrow_downward, color: ColorM.primary),
        releaseIcon: const Icon(Icons.refresh, color: ColorM.primary),
        refreshingIcon: const SizedBox(
          width: 25.0,
          height: 50.0,
          child: Center(
            child: SizedBox(
              width: 25.0,
              height: 25.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(ColorM.primary),
              ),
            ),
          ),
        ),
        idleText: '',
        refreshingText: '',
        completeText: '',
        failedText: '',
        releaseText: '',
        canTwoLevelText: '',
        textStyle: const TextStyle(fontSize: 0, height: 0),
      ),
      footer: ClassicFooter(
        outerBuilder: (child) {
          return Padding(
            padding: classicFooterPadding ?? EdgeInsets.zero,
            child: child,
          );
        },
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeightM.medium,
          color: ColorM.textSecondary,
        ),
        loadingText: 'Loading...',
        noDataText: 'No more items',
        failedText: 'Failed to load',
        idleText: 'Pull up to load more',
        canLoadingText: 'Release to load more',
        spacing: 12,
        height: 50 + (classicFooterPadding?.vertical ?? 0),
        loadingIcon: const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            color: ColorM.primary,
            valueColor: AlwaysStoppedAnimation<Color>(ColorM.primary),
            backgroundColor: Colors.transparent,
            strokeWidth: 2.2,
            strokeCap: StrokeCap.round,
          ),
        ),
      ),
      onLoading: onLoading,
      onRefresh: onRefresh != null
          ? () {
              HapticFeedback.mediumImpact();
              onRefresh!();
            }
          : null,
      child: child,
    );
  }
}

