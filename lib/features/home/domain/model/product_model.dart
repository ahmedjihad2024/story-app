class ProductModel {
  final String id;
  final String brand;
  final String title;
  final double rating;
  final double price;
  final double originalPrice;
  final String discountPercentage;
  final String imageAsset;
  final bool isWishlisted;

  const ProductModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.rating,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.imageAsset,
    this.isWishlisted = false,
  });

  ProductModel copyWith({
    String? id,
    String? brand,
    String? title,
    double? rating,
    double? price,
    double? originalPrice,
    String? discountPercentage,
    String? imageAsset,
    bool? isWishlisted,
  }) {
    return ProductModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      imageAsset: imageAsset ?? this.imageAsset,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  static const List<ProductModel> sampleFeaturedProducts = [
    ProductModel(
      id: 'feat_1',
      brand: 'Apple',
      title: 'iPhone 5s',
      rating: 2.8,
      price: 174.17,
      originalPrice: 199.99,
      discountPercentage: '-13%',
      imageAsset: 'assets/images/featured_iphone5s.png',
    ),
    ProductModel(
      id: 'feat_2',
      brand: 'Apple',
      title: 'Apple MacBook Pro 14 Inch Space Grey',
      rating: 3.6,
      price: 1906.19,
      originalPrice: 1999.99,
      discountPercentage: '-5%',
      imageAsset: 'assets/images/featured_macbook.png',
    ),
    ProductModel(
      id: 'feat_3',
      brand: 'Apple',
      title: 'iPad Mini Starlight',
      rating: 3.2,
      price: 481.50,
      originalPrice: 499.00,
      discountPercentage: '-4%',
      imageAsset: 'assets/images/featured_ipadmini.png',
    ),
  ];

  static const List<ProductModel> samplePopularProducts = [
    ProductModel(
      id: 'pop_1',
      brand: 'Apple',
      title: 'iPhone 6',
      rating: 3.4,
      price: 279.92,
      originalPrice: 299.99,
      discountPercentage: '-7%',
      imageAsset: 'assets/images/popular_iphone6.png',
    ),
    ProductModel(
      id: 'pop_2',
      brand: 'Asus',
      title: 'Asus Zenbook Pro Dual Screen Laptop',
      rating: 4.0,
      price: 1599.47,
      originalPrice: 1799.99,
      discountPercentage: '-11%',
      imageAsset: 'assets/images/popular_zenbook.png',
    ),
  ];
}

