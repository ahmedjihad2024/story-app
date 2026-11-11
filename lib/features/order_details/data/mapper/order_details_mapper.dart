import '../../../../core/enums/order_status.dart';
import '../../../home/data/mapper/home_mapper.dart';
import '../../domain/model/order_details_item_model.dart';
import '../../domain/model/order_details_model.dart';
import '../response/order_details_item_response.dart';
import '../response/order_details_response.dart';

extension OrderDetailsItemResponseMapper on OrderDetailsItemResponse {
  OrderDetailsItemModel toDomain() {
    return OrderDetailsItemModel(
      count: count,
      priceAtPurchase: priceAtPurchase,
      product: product.toDomain(),
    );
  }
}

extension OrderDetailsResponseMapper on OrderDetailsResponse {
  OrderDetailsModel toDomain() {
    return OrderDetailsModel(
      id: id,
      status: OrderStatus.fromValue(status),
      createdAt: createdAt,
      items: items.map((item) => item.toDomain()).toList(),
    );
  }
}

