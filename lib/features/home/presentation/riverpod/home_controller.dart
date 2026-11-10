import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storey_app/core/events/app_event_bus.dart';
import 'package:storey_app/core/events/event_bus_mixin.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import 'package:storey_app/core/shared/riverpod/cart/cart_controller.dart';
import 'package:storey_app/core/shared/riverpod/favorite/favorite_controller.dart';
import 'package:storey_app/features/home/domain/model/product_model.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/req_state.dart';
import '../../../../core/network/failure_message.dart';
import 'home_state.dart';

class HomeController extends Notifier<HomeState> with EventBusMixin {
  @override
  HomeState build() {
    subscribe<ProductFavoriteChanged>(_onFavoriteChanged);
    Future.microtask(loadData);
    return const HomeState();
  }

  void _onFavoriteChanged(ProductFavoriteChanged f) {
    _setProductFavorite(f.id, f.isInFavorite);
  }

  void _setProductFavorite(String productId, bool isFavorite) {
    final data = state.data;
    if (data == null) return;

    var changed = false;
    List<ProductModel> mapProducts(List<ProductModel> list) {
      return list.map((p) {
        if (p.id == productId && p.isWishlisted != isFavorite) {
          changed = true;
          return p.copyWith(isWishlisted: isFavorite);
        }
        return p;
      }).toList();
    }

    final featured = mapProducts(data.featuredProducts);
    final popular = mapProducts(data.popularProducts);

    if (!changed) return;

    state = state.copyWith(
      data: data.copyWith(
        featuredProducts: featured,
        popularProducts: popular,
      ),
    );
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final favoriteController = ref.read(favoriteControllerProvider.notifier);
    if (favoriteController.isPending(product.id)) return;

    final wasWishlisted = product.isWishlisted;
    _setProductFavorite(product.id, !wasWishlisted);

    final result = await favoriteController.toggleFavorite(
      productId: product.id,
      isCurrentlyFavorite: wasWishlisted,
    );

    if (!ref.mounted) return;

    result.fold(
      (_) => _setProductFavorite(product.id, wasWishlisted),
      (_) {},
    );
  }

  Future<Either<Failure, int>?> addToCart(
    ProductModel product, {
    int count = 1,
  }) {
    final cartController = ref.read(cartControllerProvider.notifier);
    if (cartController.isPending(product.id)) return Future.value(null);
    return cartController.addToCart(productId: product.id, count: count);
  }

  Future<void> loadData() async {
    state = state.copyWith(reqState: ReqState.loading, errorMessage: null);

    final useCase = ref.read(DI.getHomeDataUseCaseProvider);
    final result = await useCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          reqState: ReqState.error,
          errorMessage: failure.message,
        );
      },
      (homeModel) {
        state = state.copyWith(
          reqState: ReqState.success,
          data: homeModel,
          errorMessage: null,
        );
      },
    );
  }

  /// Called by SmartRefresh pull-to-refresh.
  Future<void> refresh() => loadData();
}

final homeControllerProvider =
    NotifierProvider.autoDispose<HomeController, HomeState>(HomeController.new);
