import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../riverpod/profile_controller.dart';

Future<bool?> showProfileSignOutDialog(
  BuildContext context, {
  required String email,
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss sign out dialog',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, _, __) => ProfileSignOutDialogWidget(email: email),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class ProfileSignOutDialogWidget extends ConsumerWidget {
  final String email;

  const ProfileSignOutDialogWidget({
    super.key,
    required this.email,
  });

  static const _roseColor = Color(0xFFF43F5E);
  static const _roseSurface = Color(0xFFFFF1F2);
  static const _roseBorder = Color(0xFFFFE4E6);

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(profileControllerProvider.notifier).signOut();
    if (success && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSigningOut = ref.watch(
      profileControllerProvider.select((s) => s.isSigningOut),
    );
    final signOutError = ref.watch(
      profileControllerProvider.select((s) => s.signOutError),
    );

    return PopScope(
      canPop: !isSigningOut,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
          decoration: BoxDecoration(
            color: ColorM.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: ColorM.border.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(0, 14),
                blurRadius: 32,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SignOutIconBadge(),
              const SizedBox(height: 18),
              Text(
                'Sign Out',
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 20,
                  fontWeight: FontWeightM.bold,
                  color: ColorM.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to sign out of your STOREY account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 13.5,
                  fontWeight: FontWeightM.regular,
                  color: ColorM.textSecondary,
                  height: 1.45,
                ),
              ),
              if (email.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                _AccountEmailPill(email: email.trim()),
              ],
              if (signOutError != null) ...[
                const SizedBox(height: 14),
                _SignOutErrorNotice(message: signOutError),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: isSigningOut
                            ? null
                            : () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorM.textPrimary,
                          side: const BorderSide(color: ColorM.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: FontsM.inter.name,
                            fontSize: 14.5,
                            fontWeight: FontWeightM.semiBold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isSigningOut
                            ? null
                            : [
                                BoxShadow(
                                  color: _roseColor.withValues(alpha: 0.28),
                                  offset: const Offset(0, 6),
                                  blurRadius: 14,
                                ),
                              ],
                      ),
                      child: ElevatedButton(
                        onPressed: isSigningOut
                            ? null
                            : () => _confirmSignOut(context, ref),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _roseColor,
                          foregroundColor: ColorM.white,
                          disabledBackgroundColor: _roseColor.withValues(
                            alpha: 0.65,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: isSigningOut
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorM.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontFamily: FontsM.inter.name,
                                  fontSize: 14.5,
                                  fontWeight: FontWeightM.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignOutIconBadge extends StatelessWidget {
  const _SignOutIconBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: ProfileSignOutDialogWidget._roseSurface,
        shape: BoxShape.circle,
        border: Border.all(
          color: ProfileSignOutDialogWidget._roseBorder,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: ProfileSignOutDialogWidget._roseColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ProfileSignOutDialogWidget._roseColor.withValues(
                alpha: 0.28,
              ),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.logout_rounded,
          size: 24,
          color: ColorM.white,
        ),
      ),
    );
  }
}

class _AccountEmailPill extends StatelessWidget {
  final String email;

  const _AccountEmailPill({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ColorM.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ColorM.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.alternate_email_rounded,
            size: 14,
            color: ColorM.textSecondary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 12.5,
                fontWeight: FontWeightM.medium,
                color: ColorM.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignOutErrorNotice extends StatelessWidget {
  final String message;

  const _SignOutErrorNotice({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ProfileSignOutDialogWidget._roseSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProfileSignOutDialogWidget._roseBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 16,
            color: ColorM.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 12.5,
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

