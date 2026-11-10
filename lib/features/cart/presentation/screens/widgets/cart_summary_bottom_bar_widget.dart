import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';

class CartSummaryBottomBarWidget extends StatelessWidget {
  final int totalUnits;
  final double subtotal;
  final double totalSavings;
  final VoidCallback onCheckout;

  const CartSummaryBottomBarWidget({
    super.key,
    required this.totalUnits,
    required this.subtotal,
    required this.totalSavings,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final itemLabel = totalUnits == 1 ? 'item' : 'items';

    return Container(
      decoration: BoxDecoration(
        color: ColorM.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: ColorM.border),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -6),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SummaryRow(
                label: 'Subtotal ($totalUnits $itemLabel)',
                value: '\$${subtotal.toStringAsFixed(2)}',
              ),
              if (totalSavings > 0) ...[
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Discount Savings',
                  value: '-\$${totalSavings.toStringAsFixed(2)}',
                  valueColor: ColorM.success,
                ),
              ],
              const SizedBox(height: 8),
              const _SummaryRow(
                label: 'Shipping',
                value: 'Free',
                valueColor: ColorM.success,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: ColorM.border,
                ),
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
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: FontsM.inter.name,
                      fontSize: 20,
                      fontWeight: FontWeightM.bold,
                      color: ColorM.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                title: 'Proceed to Checkout',
                onPressed: onCheckout,
              ),
            ],
          ),
        ),
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

