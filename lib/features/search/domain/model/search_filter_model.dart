enum ProductSortOption {
  newest('Newest'),
  popular('Most Popular'),
  priceLowToHigh('Price: Low → High'),
  priceHighToLow('Price: High → Low');

  final String label;
  const ProductSortOption(this.label);
}

class SearchFilterModel {
  final String? categoryId;
  final String? categoryName;
  final num? minPrice;
  final num? maxPrice;
  final ProductSortOption sortBy;

  const SearchFilterModel({
    this.categoryId,
    this.categoryName,
    this.minPrice,
    this.maxPrice,
    this.sortBy = ProductSortOption.newest,
  });

  bool get hasActiveFilters =>
      categoryId != null ||
      minPrice != null ||
      maxPrice != null ||
      sortBy != ProductSortOption.newest;

  int get activeFiltersCount {
    int count = 0;
    if (categoryId != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (sortBy != ProductSortOption.newest) count++;
    return count;
  }

  SearchFilterModel copyWith({
    String? categoryId,
    String? categoryName,
    num? minPrice,
    num? maxPrice,
    ProductSortOption? sortBy,
    bool clearCategory = false,
    bool clearPrice = false,
  }) {
    return SearchFilterModel(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      categoryName:
          clearCategory ? null : (categoryName ?? this.categoryName),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

