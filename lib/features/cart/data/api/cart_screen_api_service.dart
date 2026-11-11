// ignore_for_file: experimental_member_use

import 'package:storey_app/core/extensions/supabase_extensions.dart';
import 'package:storey_app/core/network/supabase_schema.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../response/cart_item_response.dart';
import '../response/order_id_response.dart';

abstract class CartScreenApiService {
  Future<List<CartItemResponse>> getCart();
  Future<void> clearCart();
  Future<OrderIdResponse> checkout();
}

class CartScreenApiServiceImpl implements CartScreenApiService {
  final SupabaseClient _sb;

  CartScreenApiServiceImpl([SupabaseClient? client])
    : _sb = client ?? Supabase.instance.client;

  @override
  Future<List<CartItemResponse>> getCart() async {
    final userId = _sb.requireUserId();

    final rows = await _sb
        .table(Cart.table)
        .selectOnly([
          Cart.count,
          Cart.products.select([
            Products.id,
            Products.name,
            Products.brand,
            Products.imageUrl,
            Products.price,
            Products.discountPercentage,
            Products.favorites.select([Favorites.productId]),
          ]),
        ])
        .where(Cart.userId.eq(userId))
        .requiring(Cart.products)
        .embedded(
          Cart.products,
          (product) => product.embedded(
            Products.favorites,
            (fav) => fav.where(Favorites.userId.eq(userId)),
          ),
        )
        .order(Cart.createdAt.desc())
        .order(Cart.productId.asc());

    return rows
        .map(CartItemResponse.fromPartialRow)
        .whereType<CartItemResponse>()
        .toList();
  }

  @override
  Future<void> clearCart() async {
    final userId = _sb.requireUserId();
    await _sb.table(Cart.table).delete().where(Cart.userId.eq(userId));
  }

  @override
  Future<OrderIdResponse> checkout() async {
    _sb.requireUserId();
    final response = await _sb.rpc("checkout_cod_order");
    return OrderIdResponse.fromJson(response as Map<String, dynamic>);
  }
}

