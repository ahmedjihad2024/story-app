import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/main_layout/presentation/screens/main_layout_screen.dart';
import '../../features/products/domain/model/product_filter_type.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/search/domain/model/search_filter_model.dart';
import '../../features/search/presentation/screens/filter_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'routes.dart';

export 'routes.dart';

// ignore: non_constant_identifier_names
final GlobalKey<NavigatorState> NAVIGATOR_KEY = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: NAVIGATOR_KEY,
  initialLocation: Routes.splash.path,
  routes: [
    GoRoute(
      name: Routes.splash.name,
      path: Routes.splash.path,
      builder: (context, state) => const SplashScreen(),
    ),
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
      builder: (context, state) => const MainLayoutScreen(),
    ),
    GoRoute(
      name: Routes.products.name,
      path: Routes.products.path,
      builder: (context, state) {
        if (state.extra is ProductsScreenArgs) {
          final args = state.extra as ProductsScreenArgs;
          return ProductsScreen(
            filterType: args.filterType,
            categoryId: args.categoryId,
            title: args.title,
          );
        }
        if (state.extra is Map<String, dynamic>) {
          final extra = state.extra as Map<String, dynamic>;
          return ProductsScreen(
            filterType: (extra['filterType'] as ProductFilterType?) ??
                ProductFilterType.featured,
            categoryId: extra['categoryId'] as String?,
            title: (extra['title'] as String?) ?? 'Products',
          );
        }
        return const ProductsScreen(
          filterType: ProductFilterType.featured,
          title: 'Products',
        );
      },
    ),
    GoRoute(
      name: Routes.search.name,
      path: Routes.search.path,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      name: Routes.filter.name,
      path: Routes.filter.path,
      builder: (context, state) {
        final initialFilter = state.extra is SearchFilterModel
            ? state.extra as SearchFilterModel
            : const SearchFilterModel();
        return FilterScreen(initialFilter: initialFilter);
      },
    ),
  ],
);
