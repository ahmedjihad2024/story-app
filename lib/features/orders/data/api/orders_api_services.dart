// ignore_for_file: experimental_member_use

import 'package:storey_app/core/extensions/supabase_extensions.dart';
import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../request/get_orders_request.dart';
import '../response/order_response.dart';

abstract class OrdersApiServices {
  Future<List<OrderResponse>> getOrders([
    GetOrdersRequest request = const GetOrdersRequest(),
  ]);
}

class OrdersApiServicesImpl implements OrdersApiServices {
  final SupabaseClient _sb;

  OrdersApiServicesImpl([SupabaseClient? client])
    : _sb = client ?? Supabase.instance.client;

  @override
  Future<List<OrderResponse>> getOrders([
    GetOrdersRequest request = const GetOrdersRequest(),
  ]) async {
    final userId = _sb.requireUserId();
    final from = request.page * request.limit;
    final to = from + request.limit - 1;

    var query = _sb
        .table(Orders.table)
        .selectOnly([
          Orders.id,
          Orders.status,
          Orders.createdAt,
          Orders.orderedProduct.select([
            OrderedProduct.productId,
            OrderedProduct.count,
            OrderedProduct.priceAtPurchase,
            OrderedProduct.products.select([
              Products.name,
              Products.brand,
              Products.imageUrl,
            ]),
          ]),
        ])
        .where(Orders.userId.eq(userId));

    if (request.status != null) {
      query = query.where(Orders.status.eq(request.status!.value));
    }

    final rows = await query
        .order(Orders.createdAt.desc())
        .order(Orders.id.desc())
        .range(from, to);

    return rows.map(OrderResponse.fromPartialRow).toList();
  }
}
