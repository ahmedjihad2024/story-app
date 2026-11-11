import '../../../../core/enums/req_state.dart';
import '../../domain/model/cart_item_model.dart';

class CartScreenState {
  final ReqState reqState;
  final List<CartItemModel> items;
  final bool isCheckingOut;
  final String? errorMessage;

  const CartScreenState({
    this.reqState = ReqState.idle,
    this.items = const [],
    this.isCheckingOut = false,
    this.errorMessage,
  });

  int get totalUnits => items.fold(0, (sum, item) => sum + item.count);

  double get subtotal => double.parse(
    items.fold(0.0, (sum, item) => sum + item.totalPrice).toStringAsFixed(2),
  );

  double get originalSubtotal => double.parse(
    items
        .fold(0.0, (sum, item) => sum + item.totalOriginalPrice)
        .toStringAsFixed(2),
  );

  double get totalSavings => double.parse(
    (originalSubtotal - subtotal).clamp(0.0, double.infinity).toStringAsFixed(2),
  );

  CartScreenState copyWith({
    ReqState? reqState,
    List<CartItemModel>? items,
    bool? isCheckingOut,
    String? errorMessage,
  }) {
    return CartScreenState(
      reqState: reqState ?? this.reqState,
      items: items ?? this.items,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => reqState.isLoading;
  bool get isSuccess => reqState.isSuccess;
  bool get isEmpty => reqState.isEmpty;
  bool get isError => reqState.isError;
  bool get isIdle => reqState.isIdle;
}

