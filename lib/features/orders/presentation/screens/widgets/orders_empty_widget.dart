import 'package:flutter/material.dart';
import '../../../../../core/enums/order_status.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import 'order_status_badge_widget.dart';

class OrdersEmptyWidget extends StatelessWidget {
  final OrderStatus? selectedStatus;
  final VoidCallback onAction;

  const OrdersEmptyWidget({
    super.key,
    required this.selectedStatus,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isFiltered = selectedStatus != null;
    final statusLabel = selectedStatus?.uiStyle.label.toLowerCase();
    final title = isFiltered ? 'No $statusLabel orders' : 'No orders yet';
    final subtitle = isFiltered
        ? 'No orders matched this status. Try another filter or view all orders.'
        : 'Once you place an order, you can track its status and items here.';
    final buttonLabel = isFiltered ? 'Show All Orders' : 'Browse Products';
    final buttonIcon = isFiltered
        ? Icons.filter_alt_off_outlined
        : Icons.storefront_outlined;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: ColorM.primary50,
                shape: BoxShape.circle,
                border: Border.all(color: ColorM.primary100),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 38,
                color: ColorM.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 19,
                fontWeight: FontWeightM.bold,
                color: ColorM.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 14,
                color: ColorM.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: ColorM.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(buttonIcon, size: 18),
              label: Text(
                buttonLabel,
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 14,
                  fontWeight: FontWeightM.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
