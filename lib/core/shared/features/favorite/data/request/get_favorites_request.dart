class GetFavoritesRequest {
  final int page;
  final int limit;

  const GetFavoritesRequest({
    this.page = 0,
    this.limit = 10,
  }) : assert(page >= 0, 'page must be non-negative'),
       assert(limit > 0, 'limit must be greater than zero');

  GetFavoritesRequest copyWith({
    int? page,
    int? limit,
  }) {
    return GetFavoritesRequest(
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetFavoritesRequest &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => page.hashCode ^ limit.hashCode;
}

