import 'category_model.dart';
import 'product_model.dart';
import 'promo_banner_model.dart';

class HomeModel {
  final List<PromoBannerModel> banners;
  final List<CategoryModel> categories;
  final List<ProductModel> featuredProducts;
  final List<ProductModel> popularProducts;

  const HomeModel({
    required this.banners,
    this.categories = const [],
    required this.featuredProducts,
    required this.popularProducts,
  });

  HomeModel copyWith({
    List<PromoBannerModel>? banners,
    List<CategoryModel>? categories,
    List<ProductModel>? featuredProducts,
    List<ProductModel>? popularProducts,
  }) {
    return HomeModel(
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      popularProducts: popularProducts ?? this.popularProducts,
    );
  }
}

