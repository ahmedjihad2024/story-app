import 'package:flutter/material.dart';
import '../../../../../core/enums/order_status.dart';
import '../../../../../core/extensions/order_format_extensions.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../orders/presentation/screens/widgets/order_status_badge_widget.dart';
import '../../../domain/model/order_details_model.dart';

class OrderDetailsHeaderCardWidget extends StatelessWidget {
  final OrderDetailsModel order;

  const OrderDetailsHeaderCardWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final orderCode = order.id.shortOrderCode;
    final formattedDate = order.createdAt.formattedOrderDate;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ColorM.primary50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorM.primary100),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.receipt_long_outlined,
                  size: 22,
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
                        fontSize: 16,
                        fontWeight: FontWeightM.bold,
                        color: ColorM.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Placed on $formattedDate',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontsM.inter.name,
                        fontSize: 12.5,
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1, color: ColorM.border),
          ),
          if (order.status == OrderStatus.cancelled)
            const _CancelledOrderNotice()
          else
            _OrderProgressTimeline(status: order.status),
        ],
      ),
    );
  }
}

class _CancelledOrderNotice extends StatelessWidget {
  const _CancelledOrderNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cancel_outlined,
            size: 18,
            color: ColorM.error,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This order was cancelled and will not be shipped.',
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 13,
                fontWeight: FontWeightM.medium,
                color: ColorM.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderProgressTimeline extends StatelessWidget {
  final OrderStatus status;

  const _OrderProgressTimeline({required this.status});

  static const _steps = [
    OrderStatus.pending,
    OrderStatus.paid,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = _steps.indexOf(status);

    return Row(
      children: List.generate(_steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < activeIndex;
          return Expanded(
            child: Container(
              height: 2.5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isCompleted ? ColorM.primary : ColorM.gray200,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final step = _steps[stepIndex];
        final isReached = stepIndex <= activeIndex;
        final isCurrent = stepIndex == activeIndex;
        final isDeliveredComplete =
            status == OrderStatus.delivered && step == OrderStatus.delivered;
        final activeColor = isDeliveredComplete ? ColorM.success : ColorM.primary;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isReached ? activeColor : ColorM.surfaceSecondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isReached ? activeColor : ColorM.border,
                  width: isCurrent ? 2 : 1,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Icon(
                step.uiStyle.icon,
                size: 15,
                color: isReached ? ColorM.white : ColorM.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              step.uiStyle.label,
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 11.5,
                fontWeight: isReached ? FontWeightM.semiBold : FontWeightM.medium,
                color: isReached ? ColorM.textPrimary : ColorM.textSecondary,
              ),
            ),
          ],
        );
      }),
    );
  }
}

