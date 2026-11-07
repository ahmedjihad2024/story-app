import 'package:flutter/material.dart';
import 'package:storey_app/core/routing/app_router.dart';
import 'package:storey_app/core/routing/routes.dart';
import 'package:storey_app/core/theme/theme_manager.dart';

class StoreyApp extends StatelessWidget {
  const StoreyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Storey',
      theme: ThemeManager.lightTheme(context),
      initialRoute: Routes.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
