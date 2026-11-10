// ignore_for_file: experimental_member_use

import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartItemResponse {
  final String productId;
  final String name;
  final String brand;
  final String? imageUrl;
  final double price;
  final int discountPercentage;
  final int count;
  final bool isInFavorites;

  const CartItemResponse({
    required this.productId,
    required this.name,
    required this.brand,
    this.imageUrl,
    required this.price,
    required this.discountPercentage,
    required this.count,
    required this.isInFavorites
  });

  static CartItemResponse? fromPartialRow(PostgrestPartialRow<CartRow> row) {
    final product = row.read(Cart.products);
    final favorites = product?.read(Products.favorites);
    if (product == null) return null;

    return CartItemResponse(
      productId: product.read(Products.id),
      name: product.read(Products.name),
      brand: product.read(Products.brand),
      imageUrl: product.read(Products.imageUrl),
      price: product.read(Products.price).toDouble(),
      discountPercentage: product.read(Products.discountPercentage),
      count: row.read(Cart.count),
      isInFavorites: favorites?.isNotEmpty ?? false,
    );
  }
}

