// ignore_for_file: experimental_member_use

import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderDetailsItemResponse {
  final int count;
  final double priceAtPurchase;
  final ProductsRow product;

  const OrderDetailsItemResponse({
    required this.count,
    required this.priceAtPurchase,
    required this.product,
  });

  static OrderDetailsItemResponse? fromPartialRow(
    PostgrestPartialRow<OrderedProductRow> row,
  ) {
    final productRow = row.read(OrderedProduct.products);
    if (productRow == null) return null;

    final isFavorite = productRow.read(Products.favorites).isNotEmpty;
    final fullProduct = productRow.toRow(Products.table);

    return OrderDetailsItemResponse(
      count: row.read(OrderedProduct.count),
      priceAtPurchase: row.read(OrderedProduct.priceAtPurchase).toDouble(),
      product: ProductsRow({
        ...fullProduct.toJson(),
        'is_favorite': isFavorite,
      }),
    );
  }
}

