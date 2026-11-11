import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../domain/model/order_details_model.dart';

class OrderDetailsSummaryCardWidget extends StatelessWidget {
  final OrderDetailsModel order;

  const OrderDetailsSummaryCardWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = order.totalItemsCount;
    final itemLabel = totalItems == 1 ? 'item' : 'items';

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
          Text(
            'Order Summary',
            style: TextStyle(
              fontFamily: FontsM.inter.name,
              fontSize: 15.5,
              fontWeight: FontWeightM.bold,
              color: ColorM.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: ColorM.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorM.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 18,
                  color: ColorM.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Payment Method',
                    style: TextStyle(
                      fontFamily: FontsM.inter.name,
                      fontSize: 13,
                      fontWeight: FontWeightM.medium,
                      color: ColorM.textSecondary,
                    ),
                  ),
                ),
                Text(
                  'Cash on Delivery',
                  style: TextStyle(
                    fontFamily: FontsM.inter.name,
                    fontSize: 13,
                    fontWeight: FontWeightM.semiBold,
                    color: ColorM.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            label: 'Subtotal ($totalItems $itemLabel)',
            value: '\$${order.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          const _SummaryRow(
            label: 'Shipping',
            value: 'Free',
            valueColor: ColorM.success,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: ColorM.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 16,
                  fontWeight: FontWeightM.bold,
                  color: ColorM.textPrimary,
                ),
              ),
              Text(
                '\$${order.subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 19,
                  fontWeight: FontWeightM.bold,
                  color: ColorM.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 13.5,
            fontWeight: FontWeightM.regular,
            color: ColorM.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 14,
            fontWeight: FontWeightM.semiBold,
            color: valueColor ?? ColorM.textPrimary,
          ),
        ),
      ],
    );
  }
}

