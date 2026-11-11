// ignore_for_file: experimental_member_use

import 'package:storey_app/core/extensions/supabase_extensions.dart';
import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../response/order_details_response.dart';

abstract class OrderDetailsApiServices {
  Future<OrderDetailsResponse> getOrderById(String orderId);
}

class OrderDetailsApiServicesImpl implements OrderDetailsApiServices {
  final SupabaseClient _sb;

  OrderDetailsApiServicesImpl([SupabaseClient? client])
    : _sb = client ?? Supabase.instance.client;

  @override
  Future<OrderDetailsResponse> getOrderById(String orderId) async {
    final userId = _sb.requireUserId();

    final row = await _sb
        .table(Orders.table)
        .selectOnly([
          Orders.id,
          Orders.status,
          Orders.createdAt,
          Orders.orderedProduct.select([
            OrderedProduct.count,
            OrderedProduct.priceAtPurchase,
            OrderedProduct.products.select([
              Products.table.allColumns,
              Products.favorites.select([Favorites.productId]),
            ]),
          ]),
        ])
        .where(Orders.userId.eq(userId) & Orders.id.eq(orderId))
        .embedded(
          Orders.orderedProduct,
          (ordered) => ordered
              .order(OrderedProduct.createdAt.desc())
              .requiring(
                OrderedProduct.products,
                (product) => product.embedded(
                  Products.favorites,
                  (fav) => fav.where(Favorites.userId.eq(userId)),
                ),
              ),
        )
        .single();

    return OrderDetailsResponse.fromPartialRow(row);
  }
}
