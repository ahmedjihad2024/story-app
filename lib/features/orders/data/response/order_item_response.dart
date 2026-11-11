// ignore_for_file: experimental_member_use

import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderItemResponse {
  final String productId;
  final String name;
  final String brand;
  final String? imageUrl;
  final int count;
  final double priceAtPurchase;

  const OrderItemResponse({
    required this.productId,
    required this.name,
    required this.brand,
    this.imageUrl,
    required this.count,
    required this.priceAtPurchase,
  });

  static OrderItemResponse? fromPartialRow(
    PostgrestPartialRow<OrderedProductRow> row,
  ) {
    final product = row.read(OrderedProduct.products);
    if (product == null) return null;

    return OrderItemResponse(
      productId: row.read(OrderedProduct.productId),
      name: product.read(Products.name),
      brand: product.read(Products.brand),
      imageUrl: product.read(Products.imageUrl),
      count: row.read(OrderedProduct.count),
      priceAtPurchase: row.read(OrderedProduct.priceAtPurchase).toDouble(),
    );
  }
}

