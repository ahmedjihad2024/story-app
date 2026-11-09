import '../../../../core/extensions/supabase_extensions.dart';
import '../../../../core/network/supabase_schema.g.dart';

class HomeData {
  final List<OffersRow> offers;
  final List<CategoryRow> categories;
  final List<ProductsRow> featured;
  final List<ProductsRow> popular;

  const HomeData({
    required this.offers,
    this.categories = const [],
    required this.featured,
    required this.popular,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        offers: (json['offers'] as Object?).toRows(OffersRow.new),
        categories: (json['categories'] as Object?).toRows(CategoryRow.new),
        featured: (json['featured'] as Object?).toRows(ProductsRow.new),
        popular: (json['popular'] as Object?).toRows(ProductsRow.new),
      );
}
