import '../../../../core/enums/order_status.dart';

class GetOrdersRequest {
  final OrderStatus? status;
  final int page;
  final int limit;

  const GetOrdersRequest({
    this.status,
    this.page = 0,
    this.limit = 10,
  }) : assert(page >= 0, 'page must be non-negative'),
       assert(limit > 0, 'limit must be greater than zero');

  GetOrdersRequest copyWith({
    OrderStatus? status,
    bool clearStatus = false,
    int? page,
    int? limit,
  }) {
    return GetOrdersRequest(
      status: clearStatus ? null : (status ?? this.status),
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetOrdersRequest &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => status.hashCode ^ page.hashCode ^ limit.hashCode;
}

