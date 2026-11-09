import '../../../../core/enums/req_state.dart';
import '../../../home/domain/model/product_model.dart';

class ProductsState {
  final ReqState reqState;
  final List<ProductModel> products;
  final String? errorMessage;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const ProductsState({
    this.reqState = ReqState.idle,
    this.products = const [],
    this.errorMessage,
    this.page = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ProductsState copyWith({
    ReqState? reqState,
    List<ProductModel>? products,
    String? errorMessage,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProductsState(
      reqState: reqState ?? this.reqState,
      products: products ?? this.products,
      errorMessage: errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get isLoading => reqState.isLoading;
  bool get isSuccess => reqState.isSuccess;
  bool get isError => reqState.isError;
  bool get isEmpty => reqState.isEmpty;
}

