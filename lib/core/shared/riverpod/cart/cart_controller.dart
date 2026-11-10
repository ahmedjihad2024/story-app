import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storey_app/core/di/dependency_injection.dart';
import 'package:storey_app/core/events/app_event_bus.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';

class CartController extends Notifier<void> {
  final Map<String, Future<Object?>> _inFlight = {};

  @override
  void build() {
    ref.onDispose(_inFlight.clear);
  }

  bool isPending(String productId) => _inFlight.containsKey(productId);

  Future<Either<Failure, int>> addToCart({
    required String productId,
    int count = 1,
  }) {
    final useCase = ref.read(DI.addToCartUseCaseProvider);
    return _track(
      productId,
      () => _execute(
        () => useCase(productId: productId, count: count),
        onSuccess: (updatedCount) => _emitProductChanged(
          productId,
          updatedCount,
        ),
      ),
    );
  }

  Future<Either<Failure, int>> updateItemCount({
    required String productId,
    required int count,
  }) {
    final useCase = ref.read(DI.updateCartItemCountUseCaseProvider);
    return _track(
      productId,
      () => _execute(
        () => useCase(productId: productId, count: count),
        onSuccess: (updatedCount) => _emitProductChanged(
          productId,
          updatedCount,
        ),
      ),
    );
  }

  Future<Either<Failure, Unit>> removeFromCart(String productId) {
    final useCase = ref.read(DI.removeFromCartUseCaseProvider);
    return _track(
      productId,
      () => _execute(
        () => useCase(productId),
        onSuccess: (_) => _emitProductChanged(productId, 0),
      ),
    );
  }

  Future<Either<Failure, Unit>> clearCart() {
    final useCase = ref.read(DI.clearCartUseCaseProvider);
    return _execute(
      useCase.call,
      onSuccess: (_) => AppEventBus.instance.fire(const CartCleared()),
    );
  }

  void _emitProductChanged(String productId, int count) {
    AppEventBus.instance.fire(
      ProductCartChanged(productId: productId, count: count),
    );
  }

  Future<Either<Failure, T>> _track<T>(
    String productId,
    Future<Either<Failure, T>> Function() run,
  ) {
    final existing = _inFlight[productId];
    if (existing is Future<Either<Failure, T>>) return existing;

    late final Future<Either<Failure, T>> future;
    future = () async {
      try {
        if (existing != null) {
          await existing;
        }
        return await run();
      } finally {
        if (identical(_inFlight[productId], future)) {
          _inFlight.remove(productId);
        }
      }
    }();

    _inFlight[productId] = future;
    return future;
  }

  Future<Either<Failure, T>> _execute<T>(
    Future<Either<Failure, T>> Function() action, {
    required void Function(T data) onSuccess,
  }) async {
    final result = await action();
    result.fold((_) {}, onSuccess);
    return result;
  }
}

final cartControllerProvider =
    NotifierProvider<CartController, void>(CartController.new);

