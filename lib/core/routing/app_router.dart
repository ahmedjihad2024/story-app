import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import 'routes.dart';

export 'routes.dart';

// ignore: non_constant_identifier_names
final GlobalKey<NavigatorState> NAVIGATOR_KEY = GlobalKey<NavigatorState>();

class AuthRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _sub;

  AuthRefreshNotifier(Stream<AuthState> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  navigatorKey: NAVIGATOR_KEY,
  initialLocation: Supabase.instance.client.auth.currentSession != null
      ? Routes.home.path
      : Routes.signIn.path,
  refreshListenable: AuthRefreshNotifier(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  redirect: (context, state) {
    final isLoggedIn = Supabase.instance.client.auth.currentSession != null;
    final isAuthPage = state.matchedLocation == Routes.signIn.path ||
        state.matchedLocation == Routes.signUp.path;

    if (!isLoggedIn && !isAuthPage) return Routes.signIn.path;
    if (isLoggedIn && isAuthPage) return Routes.home.path;
    return null;
  },
  routes: [
    GoRoute(
      name: Routes.signIn.name,
      path: Routes.signIn.path,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      name: Routes.signUp.name,
      path: Routes.signUp.path,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: Routes.home.name,
      path: Routes.home.path,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
