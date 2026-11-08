import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/routes.dart';

extension NavigationExtension on BuildContext {
  Future<T?> pushNamed<T>(Routes route, {Object? arguments}) =>
      GoRouter.of(this).pushNamed<T>(route.name, extra: arguments);

  void goNamed(Routes route, {Object? arguments}) =>
      GoRouter.of(this).goNamed(route.name, extra: arguments);

  void go(String location, {Object? extra}) =>
      GoRouter.of(this).go(location, extra: extra);

  Future<T?> pushReplacementNamed<T>(Routes route, {Object? arguments}) =>
      GoRouter.of(this).pushReplacementNamed<T>(route.name, extra: arguments);

  void pop<T>([T? result]) => GoRouter.of(this).pop<T>(result);

  void maybePop<T>([T? result]) {
    final router = GoRouter.of(this);
    if (router.canPop()) router.pop<T>(result);
  }

  void popUntilNamed(Routes route) => GoRouter.of(this).goNamed(route.name);

  bool get canPop => GoRouter.of(this).canPop();
}
