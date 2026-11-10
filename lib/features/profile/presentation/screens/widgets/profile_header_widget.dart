import 'package:flutter/material.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../../core/widgets/images/app_cached_image.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String badgeLabel;
  final String email;
  final String? imageUrl;
  final VoidCallback? onEditAvatarTap;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
    this.badgeLabel = 'STOREY Premium',
    required this.email,
    this.imageUrl,
    this.onEditAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: ColorM.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: ColorM.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: AppCachedImage(
                imageUrl: imageUrl,
                width: 67,
                height: 67,
                borderRadius: BorderRadius.circular(19),
                fallback: Container(
                  width: 67,
                  height: 67,
                  decoration: BoxDecoration(
                    color: ColorM.primary50,
                    borderRadius: BorderRadius.circular(19),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person_rounded,
                    size: 34,
                    color: ColorM.primary,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -13,
              bottom: -13,
              child: Semantics(
                button: true,
                label: 'Edit profile photo',
                child: GestureDetector(
                  onTap: onEditAvatarTap,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: ColorM.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: ColorM.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: ColorM.primary.withValues(alpha: 0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 13,
                          color: ColorM.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 19,
                  fontWeight: FontWeightM.bold,
                  color: ColorM.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ColorM.primary50,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: ColorM.primary100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 12,
                      color: ColorM.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      badgeLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        fontWeight: FontWeightM.semiBold,
                        color: ColorM.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeightM.regular,
                  color: ColorM.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
