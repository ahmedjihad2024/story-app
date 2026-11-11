import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/navigation_extension.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/shared/features/profile/domain/model/profile_model.dart';
import '../../../../core/theme/color_manager.dart';
import '../../../../core/theme/fonts_manager.dart';
import '../../../../core/widgets/refresh/customized_smart_refresh.dart';
import '../../../../core/widgets/state/state_render.dart';
import '../../../main_layout/presentation/riverpod/layout_controller.dart';
import '../riverpod/profile_controller.dart';
import '../riverpod/profile_state.dart';
import 'widgets/profile_edit_button_widget.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/profile_menu_item_widget.dart';
import 'widgets/profile_shimmer_loading.dart';
import 'widgets/profile_sign_out_card_widget.dart';
import 'widgets/profile_sign_out_dialog_widget.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final success = await ref.read(profileControllerProvider.notifier).refresh();
    if (!mounted) return;

    if (success) {
      _refreshController.refreshCompleted(resetFooterState: true);
    } else {
      _refreshController.refreshFailed();
    }
  }

  void _openEditProfile(BuildContext context, ProfileState state) {
    context.pushNamed(
      Routes.updateProfile,
      arguments: ProfileModel(
        id: '',
        firstName: state.firstName,
        lastName: state.lastName,
        email: state.email,
        imageUrl: state.imageUrl,
      ),
    );
  }

  Future<void> _handleSignOutTap(
    BuildContext context,
    ProfileState state,
  ) async {
    ref.read(profileControllerProvider.notifier).clearSignOutError();
    final signedOut = await showProfileSignOutDialog(
      context,
      email: state.email,
    );
    if (signedOut != true || !context.mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final state = ref.watch(profileControllerProvider);

    ref.listen<ProfileState>(profileControllerProvider, (prev, next) {
      if (next.isSuccess &&
          next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return StateRender(
      reqState: state.reqState,
      loading: (context) => const ProfileShimmerLoading(),
      idle: (context) => const ProfileShimmerLoading(),
      error: (context) => _ProfileError(
        message: state.errorMessage ?? 'Failed to load profile',
        onRetry: () => ref.read(profileControllerProvider.notifier).getUserData(),
      ),
      success: (context) => _ProfileContent(
        state: state,
        refreshController: _refreshController,
        onRefresh: _handleRefresh,
        onEditProfileTap: () => _openEditProfile(context, state),
        onMyOrdersTap: () => context.pushNamed(Routes.orders),
        onSavedItemsTap: () => context.pushNamed(Routes.favorites),
        onSignOutTap: () => _handleSignOutTap(context, state),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final ProfileState state;
  final RefreshController refreshController;
  final Future<void> Function() onRefresh;
  final VoidCallback onEditProfileTap;
  final VoidCallback onMyOrdersTap;
  final VoidCallback onSavedItemsTap;
  final VoidCallback onSignOutTap;

  const _ProfileContent({
    required this.state,
    required this.refreshController,
    required this.onRefresh,
    required this.onEditProfileTap,
    required this.onMyOrdersTap,
    required this.onSavedItemsTap,
    required this.onSignOutTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomizedSmartRefresh(
      controller: refreshController,
      onRefresh: onRefresh,
      enableRefresh: true,
      enableLoading: false,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.paddingOf(context).bottom + 104,
        ),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 26,
              fontWeight: FontWeightM.bold,
              color: ColorM.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 18),
          ProfileHeaderWidget(
            name: state.displayName,
            email: state.email,
            imageUrl: state.imageUrl,
            onEditAvatarTap: onEditProfileTap,
          ),
          const SizedBox(height: 18),
          ProfileEditButtonWidget(
            onTap: onEditProfileTap,
          ),
          const SizedBox(height: 18),
          ProfileMenuItemWidget(
            icon: Icons.inventory_2_outlined,
            iconColor: ColorM.primary,
            iconBackgroundColor: ColorM.primary50,
            title: 'My Orders',
            subtitle: 'Track your orders',
            onTap: onMyOrdersTap,
          ),
          const SizedBox(height: 10),
          ProfileMenuItemWidget(
            icon: Icons.favorite_border_rounded,
            iconColor: const Color(0xFFF43F5E),
            iconBackgroundColor: const Color(0xFFFFF1F2),
            title: 'Saved Items',
            subtitle: 'View wishlist',
            onTap: onSavedItemsTap,
          ),
          const SizedBox(height: 10),
          ProfileMenuItemWidget(
            icon: Icons.verified_user_outlined,
            iconColor: const Color(0xFFA855F7),
            iconBackgroundColor: const Color(0xFFFAF5FF),
            title: 'Privacy & Security',
            subtitle: 'Manage account security',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          ProfileMenuItemWidget(
            icon: Icons.info_outline_rounded,
            iconColor: ColorM.textSecondary,
            iconBackgroundColor: ColorM.surfaceSecondary,
            title: 'Help & Support',
            subtitle: 'Get help or send feedback',
            onTap: () {},
          ),
          const SizedBox(height: 14),
          ProfileSignOutCardWidget(
            onTap: onSignOutTap,
          ),
        ],
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
