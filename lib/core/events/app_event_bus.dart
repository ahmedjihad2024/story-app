import 'dart:async';
import '../shared/features/profile/domain/model/profile_model.dart';

/// Singleton broadcast stream bus. Fire any event from anywhere,
/// subscribe from any Riverpod notifier via [EventBusMixin].
class AppEventBus {
  AppEventBus._();

  static final AppEventBus instance = AppEventBus._();

  final StreamController<Object> _controller =
      StreamController<Object>.broadcast();

  /// Returns a filtered stream of events of type [T].
  Stream<T> on<T>() => _controller.stream.where((e) => e is T).cast<T>();

  /// Fire an event to all subscribers.
  void fire(Object event) => _controller.add(event);

  void dispose() => _controller.close();
}

/// Event fired whenever a product's favorite status changes.
class ProductFavoriteChanged {
  final String id;
  final bool isInFavorite;
  const ProductFavoriteChanged({required this.id, required this.isInFavorite});
}

/// Event fired whenever the user's profile is updated.
class ProfileUpdated {
  final ProfileModel profile;
  const ProfileUpdated(this.profile);
}

/// Event fired whenever a cart item's quantity changes (`count == 0` means removed).
class ProductCartChanged {
  final String productId;
  final int count;
  const ProductCartChanged({required this.productId, required this.count});
}

/// Event fired when the entire cart is cleared.
class CartCleared {
  const CartCleared();
}
