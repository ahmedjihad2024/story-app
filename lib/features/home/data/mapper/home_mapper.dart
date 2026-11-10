import '../../../../core/network/supabase_schema.g.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/home_model.dart';
import '../../domain/model/product_model.dart';
import '../../domain/model/promo_banner_model.dart';
import '../response/home_response.dart';

extension OffersRowMapper on OffersRow {
  PromoBannerModel toDomain() {
    return PromoBannerModel(
      id: id,
      tag: 'SPECIAL OFFER',
      title: title,
      subtitle: body,
      buttonText: 'Shop Now',
      imageAsset: 'assets/images/promo_banner_bg.png',
    );
  }
}

extension ProductsRowMapper on ProductsRow {
  ProductModel toDomain() {
    final original = discountPercentage > 0
        ? (price / (1 - (discountPercentage / 100))).toDouble()
        : price.toDouble();
    final discount = discountPercentage > 0 ? '-$discountPercentage%' : '';

    return ProductModel(
      id: id,
      brand: brand,
      title: name,
      rating: rating.toDouble(),
      price: price.toDouble(),
      originalPrice: double.parse(original.toStringAsFixed(2)),
      discountPercentage: discount,
      imageAsset: imageUrl ?? '',
      imageUrl: imageUrl,
      description: description,
      salesCount: salesCount,
      isWishlisted: isFavorite,
    );
  }
}

extension CategoryRowMapper on CategoryRow {
  CategoryModel toDomain() {
    return CategoryModel(
      id: id,
      name: name,
      iconAsset: _resolveCategoryIcon(name),
      imageUrl: imageUrl,
    );
  }

  static String _resolveCategoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('smart') || lower.contains('phone')) {
      return 'assets/svg/cat_smartphones.svg';
    } else if (lower.contains('laptop') ||
        lower.contains('mac') ||
        lower.contains('pc')) {
      return 'assets/svg/cat_laptops.svg';
    } else if (lower.contains('head') ||
        lower.contains('audio') ||
        lower.contains('ear')) {
      return 'assets/svg/cat_headphones.svg';
    } else if (lower.contains('watch')) {
      return 'assets/svg/cat_smartwatches.svg';
    }
    return 'assets/svg/cat_smartphones.svg';
  }
}

extension HomeDataMapper on HomeData {
  HomeModel toDomain() {
    return HomeModel(
      banners: offers.map((offer) => offer.toDomain()).toList(),
      categories: categories.map((cat) => cat.toDomain()).toList(),
      featuredProducts: featured.map((prod) => prod.toDomain()).toList(),
      popularProducts: popular.map((prod) => prod.toDomain()).toList(),
    );
  }
}

