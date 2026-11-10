import '../../../home/domain/model/product_model.dart';

class ProductDetailsState {
  final ProductModel product;

  const ProductDetailsState({
    required this.product,
  });

  bool get isWishlisted => product.isWishlisted;

  ProductDetailsState copyWith({
    ProductModel? product,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
    );
  }
}
