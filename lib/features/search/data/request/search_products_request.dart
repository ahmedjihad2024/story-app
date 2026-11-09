import '../../domain/model/search_filter_model.dart';

class SearchProductsRequest {
  final String query;
  final SearchFilterModel filter;
  final int page;
  final int limit;

  const SearchProductsRequest({
    this.query = '',
    this.filter = const SearchFilterModel(),
    this.page = 0,
    this.limit = 10,
  });

  SearchProductsRequest copyWith({
    String? query,
    SearchFilterModel? filter,
    int? page,
    int? limit,
  }) {
    return SearchProductsRequest(
      query: query ?? this.query,
      filter: filter ?? this.filter,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

