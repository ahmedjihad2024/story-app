import 'package:flutter/material.dart';
import '../routing/app_router.dart';
import '../theme/theme_manager.dart';

class StoreyApp extends StatelessWidget {
  const StoreyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Storey',
      theme: ThemeManager.lightTheme(context),
      routerConfig: appRouter,
    );
  }
}
