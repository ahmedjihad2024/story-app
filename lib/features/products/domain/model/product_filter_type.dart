enum ProductFilterType {
  featured,
  popular,
  category;

  bool get isFeatured => this == ProductFilterType.featured;
  bool get isPopular => this == ProductFilterType.popular;
  bool get isCategory => this == ProductFilterType.category;
}

