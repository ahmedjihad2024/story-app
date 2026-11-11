// ignore_for_file: experimental_member_use

import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_item_response.dart';

class OrderResponse {
  final String id;
  final String status;
  final DateTime createdAt;
  final List<OrderItemResponse> items;

  const OrderResponse({
    required this.id,
    required this.status,
    required this.createdAt,
    this.items = const [],
  });

  static OrderResponse fromPartialRow(PostgrestPartialRow<OrdersRow> row) {
    final orderedProducts = row.read(Orders.orderedProduct);

    return OrderResponse(
      id: row.read(Orders.id),
      status: row.read(Orders.status),
      createdAt: row.read(Orders.createdAt),
      items: orderedProducts
          .map(OrderItemResponse.fromPartialRow)
          .whereType<OrderItemResponse>()
          .toList(),
    );
  }
}

