import 'package:flutter/material.dart';
import '../../../../../core/extensions/order_format_extensions.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../../core/widgets/images/app_cached_image.dart';
import '../../../domain/model/order_item_model.dart';
import '../../../domain/model/order_model.dart';
import 'order_status_badge_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final orderCode = order.id.shortOrderCode;
    final formattedDate = order.createdAt.formattedOrderDate;
    final itemCount = order.totalItemsCount;
    final itemLabel = itemCount == 1 ? '1 item' : '$itemCount items';

    return Semantics(
      button: onTap != null,
      label: 'Order $orderCode, ${order.status.uiStyle.label}, $formattedDate',
      child: Container(
        decoration: BoxDecoration(
          color: ColorM.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorM.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Material(
          color: ColorM.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: ColorM.primary50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ColorM.primary100),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          size: 20,
                          color: ColorM.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order $orderCode',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: FontsM.inter.name,
                                fontSize: 15,
                                fontWeight: FontWeightM.bold,
                                color: ColorM.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              formattedDate,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: FontsM.inter.name,
                                fontSize: 12,
                                fontWeight: FontWeightM.medium,
                                color: ColorM.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      OrderStatusBadgeWidget(status: order.status),
                    ],
                  ),
                  if (order.items.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _OrderItemsPreviewStrip(items: order.items),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: ColorM.border,
                    ),
                  ),
                  Row(
                    children: [
                      if (order.items.isNotEmpty)
                        Text(
                          itemLabel,
                          style: TextStyle(
                            fontFamily: FontsM.inter.name,
                            fontSize: 13,
                            fontWeight: FontWeightM.medium,
                            color: ColorM.textSecondary,
                          ),
                        )
                      else
                        Text(
                          'View order details',
                          style: TextStyle(
                            fontFamily: FontsM.inter.name,
                            fontSize: 13,
                            fontWeight: FontWeightM.medium,
                            color: ColorM.textSecondary,
                          ),
                        ),
                      const Spacer(),
                      if (order.items.isNotEmpty)
                        Text(
                          '\$${order.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: FontsM.inter.name,
                            fontSize: 16,
                            fontWeight: FontWeightM.bold,
                            color: ColorM.textPrimary,
                          ),
                        ),
                      if (onTap != null) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: ColorM.textSecondary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderItemsPreviewStrip extends StatelessWidget {
  final List<OrderItemModel> items;

  const _OrderItemsPreviewStrip({required this.items});

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.take(3).toList();
    final extraCount = items.length - visibleItems.length;
    final firstItem = items.first;
    final summaryText = items.length == 1
        ? '${firstItem.name} × ${firstItem.count}'
        : '${firstItem.name} + ${items.length - 1} more';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorM.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorM.border),
      ),
      child: Row(
        children: [
          ...visibleItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorM.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorM.border),
                ),
                child: AppCachedImage(
                  imageUrl: item.imageUrl,
                  width: 38,
                  height: 38,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
          if (extraCount > 0)
            Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: ColorM.primary50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorM.primary100),
              ),
              alignment: Alignment.center,
              child: Text(
                '+$extraCount',
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 12,
                  fontWeight: FontWeightM.bold,
                  color: ColorM.primary,
                ),
              ),
            )
          else
            const SizedBox(width: 4),
          Expanded(
            child: Text(
              summaryText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 12.5,
                fontWeight: FontWeightM.medium,
                color: ColorM.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
