import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_event_bus.dart';

/// Mixin that lets any Riverpod [AnyNotifier] (such as [Notifier] or
/// [AsyncNotifier]) subscribe to [AppEventBus] events and automatically
/// cancel all subscriptions when the notifier rebuilds or is disposed.
///
/// Call [subscribe] inside `build()` rather than a constructor, because [ref]
/// is only available once the notifier has been initialized.
///
/// Usage:
/// ```dart
/// class MyController extends Notifier<MyState> with EventBusMixin {
///   @override
///   MyState build() {
///     subscribe<ProductFavoriteChanged>(_onFavoriteChanged);
///     return const MyState();
///   }
///
///   void _onFavoriteChanged(ProductFavoriteChanged event) { ... }
/// }
/// ```
mixin EventBusMixin<StateT, ValueT> on AnyNotifier<StateT, ValueT> {
  /// Subscribe to bus events of type [T].
  ///
  /// Automatically cancels the subscription when the provider rebuilds or is
  /// disposed, and ignores late events if the notifier is no longer mounted.
  void subscribe<T>(void Function(T event) callback) {
    final currentRef = ref;
    final subscription = AppEventBus.instance.on<T>().listen((event) {
      if (!currentRef.mounted) return;
      callback(event);
    });
    currentRef.onDispose(subscription.cancel);
  }

  /// Fire an [event] to all subscribers on [AppEventBus].
  void fireEvent(Object event) => AppEventBus.instance.fire(event);
}


