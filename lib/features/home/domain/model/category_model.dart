class CategoryModel {
  final String id;
  final String name;
  final String iconAsset;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconAsset,
  });

  static const List<CategoryModel> sampleCategories = [
    CategoryModel(
      id: 'smartphones',
      name: 'Smartphones',
      iconAsset: 'assets/svg/cat_smartphones.svg',
    ),
    CategoryModel(
      id: 'laptops',
      name: 'Laptops',
      iconAsset: 'assets/svg/cat_laptops.svg',
    ),
    CategoryModel(
      id: 'headphones',
      name: 'Headphones',
      iconAsset: 'assets/svg/cat_headphones.svg',
    ),
    CategoryModel(
      id: 'smartwatches',
      name: 'Smart\nwatches',
      iconAsset: 'assets/svg/cat_smartwatches.svg',
    ),
  ];
}

