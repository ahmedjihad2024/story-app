import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storey_app/core/di/dependency_injection.dart';
import 'package:storey_app/core/events/app_event_bus.dart';
import 'package:storey_app/core/network/error_handler/failure.dart';
import 'package:storey_app/core/shared/features/favorite/domain/model/favorite_status.dart';

class FavoriteController extends Notifier<void> {
  final Map<String, Future<Either<Failure, FavoriteStatus>>> _inFlight = {};

  @override
  void build() {
    ref.onDispose(_inFlight.clear);
  }

  bool isPending(String productId) => _inFlight.containsKey(productId);

  Future<Either<Failure, FavoriteStatus>> addToFavorite(String productId) {
    final useCase = ref.read(DI.addToFavoriteUseCaseProvider);
    return _track(
      productId,
      () => _execute(
        () => useCase(productId),
        onSuccess: (status) => _emit(productId, status.isInFavorite),
      ),
    );
  }

  Future<Either<Failure, FavoriteStatus>> removeFromFavorite(
    String productId,
  ) {
    final useCase = ref.read(DI.removeFromFavoriteUseCaseProvider);
    return _track(
      productId,
      () => _execute(
        () => useCase(productId),
        onSuccess: (status) => _emit(productId, status.isInFavorite),
      ),
    );
  }

  /// Toggles favorite status for [productId] and returns the [Either] result.
  ///
  /// Optimistically emits [ProductFavoriteChanged] before the request and
  /// reverts it if the request fails.
  Future<Either<Failure, FavoriteStatus>> toggleFavorite({
    required String productId,
    required bool isCurrentlyFavorite,
  }) {
    return _track(productId, () {
      final targetStatus = !isCurrentlyFavorite;
      
      final action = isCurrentlyFavorite
          ? () => ref.read(DI.removeFromFavoriteUseCaseProvider)(productId)
          : () => ref.read(DI.addToFavoriteUseCaseProvider)(productId);

      return _execute(
        action,
        onSuccess: (status) {
          _emit(productId, status.isInFavorite);
        },
      );
    });
  }

  void _emit(String productId, bool isInFavorite) {
    AppEventBus.instance.fire(
      ProductFavoriteChanged(id: productId, isInFavorite: isInFavorite),
    );
  }

  Future<Either<Failure, FavoriteStatus>> _track(
    String productId,
    Future<Either<Failure, FavoriteStatus>> Function() run,
  ) {
    final existing = _inFlight[productId];
    if (existing != null) return existing;

    final future = () async {
      try {
        return await run();
      } finally {
        _inFlight.remove(productId);
      }
    }();

    _inFlight[productId] = future;
    return future;
  }

  Future<Either<Failure, FavoriteStatus>> _execute(
    Future<Either<Failure, FavoriteStatus>> Function() action, {
    required void Function(FavoriteStatus status) onSuccess,
    void Function()? onFailure,
  }) async {
    final result = await action();
    result.fold(
      (_) => onFailure?.call(),
      onSuccess,
    );
    return result;
  }
}

final favoriteControllerProvider =
    NotifierProvider<FavoriteController, void>(FavoriteController.new);
