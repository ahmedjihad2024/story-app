import '../../../../core/enums/order_status.dart';
import '../../domain/model/order_item_model.dart';
import '../../domain/model/order_model.dart';
import '../response/order_item_response.dart';
import '../response/order_response.dart';

extension OrderItemResponseMapper on OrderItemResponse {
  OrderItemModel toDomain() {
    return OrderItemModel(
      productId: productId,
      name: name,
      brand: brand,
      imageUrl: imageUrl,
      count: count,
      priceAtPurchase: priceAtPurchase,
    );
  }
}

extension OrderResponseMapper on OrderResponse {
  OrderModel toDomain() {
    return OrderModel(
      id: id,
      status: OrderStatus.fromValue(status),
      createdAt: createdAt,
      items: items.map((item) => item.toDomain()).toList(),
    );
  }
}

