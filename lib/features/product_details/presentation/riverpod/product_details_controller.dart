import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/events/app_event_bus.dart';
import '../../../../core/events/event_bus_mixin.dart';
import '../../../../core/network/error_handler/failure.dart';
import '../../../../core/shared/features/favorite/domain/model/favorite_status.dart';
import '../../../../core/shared/riverpod/cart/cart_controller.dart';
import '../../../../core/shared/riverpod/favorite/favorite_controller.dart';
import '../../../home/domain/model/product_model.dart';
import 'product_details_state.dart';

class ProductDetailsController extends Notifier<ProductDetailsState>
    with EventBusMixin {
  final ProductModel initialProduct;

  ProductDetailsController({required this.initialProduct});

  @override
  ProductDetailsState build() {
    subscribe<ProductFavoriteChanged>(_onFavoriteChanged);
    return ProductDetailsState(product: initialProduct);
  }

  void _onFavoriteChanged(ProductFavoriteChanged event) {
    if (event.id == state.product.id &&
        state.product.isWishlisted != event.isInFavorite) {
      state = state.copyWith(
        product: state.product.copyWith(isWishlisted: event.isInFavorite),
      );
    }
  }

  Future<void> toggleFavorite() async {
    final favoriteController = ref.read(favoriteControllerProvider.notifier);
    if (favoriteController.isPending(state.product.id)) return null;

    final wasWishlisted = state.isWishlisted;

    state = state.copyWith(
      product: state.product.copyWith(isWishlisted: !wasWishlisted),
    );

    final result = await favoriteController.toggleFavorite(
      productId: state.product.id,
      isCurrentlyFavorite: wasWishlisted,
    );


    result.fold(
      (_) {
        state = state.copyWith(
          product: state.product.copyWith(isWishlisted: wasWishlisted),
        );
      },
      (_) {},
    );
  }

  Future<Either<Failure, int>?> addToCart({int count = 1}) {
    final cartController = ref.read(cartControllerProvider.notifier);
    if (cartController.isPending(state.product.id)) return Future.value(null);
    return cartController.addToCart(productId: state.product.id, count: count);
  }
}

final productDetailsControllerProvider = NotifierProvider.autoDispose
    .family<ProductDetailsController, ProductDetailsState, ProductModel>(
      (product) => ProductDetailsController(initialProduct: product),
    );
