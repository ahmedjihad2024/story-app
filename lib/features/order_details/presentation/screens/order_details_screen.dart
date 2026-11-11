import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../../../core/widgets/state/state_render.dart';
import '../riverpod/order_details_controller.dart';
import '../riverpod/order_details_state.dart';
import 'widgets/order_details_error_widget.dart';
import 'widgets/order_details_header_card_widget.dart';
import 'widgets/order_details_item_card_widget.dart';
import 'widgets/order_details_shimmer_loading.dart';
import 'widgets/order_details_summary_card_widget.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final success = await ref
        .read(orderDetailsControllerProvider(widget.orderId).notifier)
        .refresh();
    if (!mounted) return;

    if (success) {
      _refreshController.refreshCompleted(resetFooterState: true);
    } else {
      _refreshController.refreshFailed();
    }
  }

  void _showErrorSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ColorM.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderDetailsControllerProvider(widget.orderId));

    ref.listen<OrderDetailsState>(
      orderDetailsControllerProvider(widget.orderId),
      (prev, next) {
        if (next.isSuccess &&
            next.errorMessage != null &&
            next.errorMessage != prev?.errorMessage) {
          _showErrorSnackBar(next.errorMessage!);
        }
      },
    );

    final order = state.order;

    return Scaffold(
      backgroundColor: ColorM.background,
      appBar: AppBar(
        backgroundColor: ColorM.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: ColorM.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Order Details',
          style: TextStyle(
            fontFamily: FontsM.inter.name,
            fontSize: 18,
            fontWeight: FontWeightM.bold,
            color: ColorM.textPrimary,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: ColorM.border,
          ),
        ),
      ),
      body: StateRender(
        reqState: state.reqState,
        idle: (context) => const OrderDetailsShimmerLoading(),
        loading: (context) => const OrderDetailsShimmerLoading(),
        error: (context) => OrderDetailsErrorWidget(
          message: state.errorMessage ?? 'Failed to load order details',
          onRetry: () => ref
              .read(orderDetailsControllerProvider(widget.orderId).notifier)
              .loadOrder(),
        ),
        empty: (context) => OrderDetailsErrorWidget(
          message: 'Order not found',
          onRetry: () => ref
              .read(orderDetailsControllerProvider(widget.orderId).notifier)
              .loadOrder(),
        ),
        success: (context) {
          if (order == null) {
            return OrderDetailsErrorWidget(
              message: 'Order not found',
              onRetry: () => ref
                  .read(
                    orderDetailsControllerProvider(widget.orderId).notifier,
                  )
                  .loadOrder(),
            );
          }

          return CustomizedSmartRefresh(
            controller: _refreshController,
            onRefresh: _handleRefresh,
            enableRefresh: true,
            enableLoading: false,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.paddingOf(context).bottom + 24,
              ),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                OrderDetailsHeaderCardWidget(order: order),
                const SizedBox(height: 18),
                Text(
                  'Items (${order.totalItemsCount})',
                  style: TextStyle(
                    fontFamily: FontsM.inter.name,
                    fontSize: 15.5,
                    fontWeight: FontWeightM.bold,
                    color: ColorM.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (order.items.isEmpty)
                  const _OrderNoAvailableItemsCard()
                else
                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OrderDetailsItemCardWidget(
                        key: ValueKey(item.product.id),
                        item: item,
                        onTap: () => context.pushNamed(
                          Routes.productDetails,
                          arguments: item.product,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                OrderDetailsSummaryCardWidget(order: order),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrderNoAvailableItemsCard extends StatelessWidget {
  const _OrderNoAvailableItemsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorM.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorM.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: ColorM.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'No active product details are available for this order.',
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 13.5,
                color: ColorM.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

