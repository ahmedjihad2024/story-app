import '../../domain/model/product_filter_type.dart';

class GetProductsRequest {
  final ProductFilterType filterType;
  final String? categoryId;
  final int page;
  final int limit;

  const GetProductsRequest({
    required this.filterType,
    this.categoryId,
    this.page = 0,
    this.limit = 10,
  });

  GetProductsRequest copyWith({
    ProductFilterType? filterType,
    String? categoryId,
    int? page,
    int? limit,
  }) {
    return GetProductsRequest(
      filterType: filterType ?? this.filterType,
      categoryId: categoryId ?? this.categoryId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetProductsRequest &&
          runtimeType == other.runtimeType &&
          filterType == other.filterType &&
          categoryId == other.categoryId &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode =>
      filterType.hashCode ^
      categoryId.hashCode ^
      page.hashCode ^
      limit.hashCode;
}
