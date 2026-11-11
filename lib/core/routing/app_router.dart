import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/home/domain/model/product_model.dart';
import '../../features/main_layout/presentation/screens/main_layout_screen.dart';
import '../../features/order_details/presentation/screens/order_details_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/product_details/presentation/screens/product_details_screen.dart';
import '../../features/products/domain/model/product_filter_type.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/update_profile/presentation/screens/update_profile_screen.dart';
import '../../features/search/domain/model/search_filter_model.dart';
import '../../features/search/presentation/screens/filter_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../shared/features/profile/domain/model/profile_model.dart';
import 'routes.dart';

export 'routes.dart';

// ignore: non_constant_identifier_names
final GlobalKey<NavigatorState> NAVIGATOR_KEY = GlobalKey<NavigatorState>();

class _AuthRefreshListenable extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;
  bool _isLoggedIn;

  _AuthRefreshListenable(SupabaseClient client)
    : _isLoggedIn = client.auth.currentSession != null {
    _subscription = client.auth.onAuthStateChange.listen((authState) {
      final nowLoggedIn = authState.session != null;
      if (authState.event == AuthChangeEvent.signedOut ||
          nowLoggedIn != _isLoggedIn) {
        _isLoggedIn = nowLoggedIn;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  navigatorKey: NAVIGATOR_KEY,
  initialLocation: Routes.splash.path,
  refreshListenable: _AuthRefreshListenable(Supabase.instance.client),
  redirect: (context, state) {
    final location = state.matchedLocation;
    if (location == Routes.splash.path ||
        location == Routes.signIn.path ||
        location == Routes.signUp.path) {
      return null;
    }

    final hasSession = Supabase.instance.client.auth.currentSession != null;
    if (!hasSession) {
      return Routes.signIn.path;
    }

    return null;
  },
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
      name: Routes.favorites.name,
      path: Routes.favorites.path,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      name: Routes.cart.name,
      path: Routes.cart.path,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      name: Routes.orders.name,
      path: Routes.orders.path,
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      name: Routes.orderDetails.name,
      path: Routes.orderDetails.path,
      builder: (context, state) {
        final orderId = state.extra is String ? state.extra as String : '';
        return OrderDetailsScreen(orderId: orderId);
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
    GoRoute(
      name: Routes.productDetails.name,
      path: Routes.productDetails.path,
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return ProductDetailsScreen(product: product);
      },
    ),
    GoRoute(
      name: Routes.updateProfile.name,
      path: Routes.updateProfile.path,
      builder: (context, state) {
        final initialProfile =
            state.extra is ProfileModel ? state.extra as ProfileModel : null;
        return UpdateProfileScreen(initialProfile: initialProfile);
      },
    ),
  ],
);
