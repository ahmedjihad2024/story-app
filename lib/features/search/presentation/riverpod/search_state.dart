import '../../../../core/enums/req_state.dart';
import '../../../home/domain/model/product_model.dart';
import '../../domain/model/search_filter_model.dart';

class SearchState {
  final ReqState reqState;
  final List<ProductModel> products;
  final String query;
  final SearchFilterModel filter;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const SearchState({
    this.reqState = ReqState.idle,
    this.products = const [],
    this.query = '',
    this.filter = const SearchFilterModel(),
    this.page = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get isLoading => reqState == ReqState.loading;
  bool get isSuccess => reqState == ReqState.success;
  bool get isEmpty => reqState == ReqState.empty;
  bool get isError => reqState == ReqState.error;
  bool get isIdle => reqState == ReqState.idle;

  SearchState copyWith({
    ReqState? reqState,
    List<ProductModel>? products,
    String? query,
    SearchFilterModel? filter,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return SearchState(
      reqState: reqState ?? this.reqState,
      products: products ?? this.products,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }
}

