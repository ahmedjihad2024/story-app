import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/color_manager.dart';
import '../../../../../core/theme/fonts_manager.dart';
import '../../../../../core/widgets/images/app_cached_image.dart';

class UpdateProfileAvatarPickerWidget extends StatelessWidget {
  final String? imageUrl;
  final Uint8List? pickedImageBytes;
  final bool enabled;
  final VoidCallback onPickTap;
  final VoidCallback? onClearPickedTap;

  const UpdateProfileAvatarPickerWidget({
    super.key,
    this.imageUrl,
    this.pickedImageBytes,
    this.enabled = true,
    required this.onPickTap,
    this.onClearPickedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          enabled: enabled,
          label: 'Change profile photo',
          child: GestureDetector(
            onTap: enabled ? onPickTap : null,
            behavior: HitTestBehavior.opaque,
            child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 104,
                height: 104,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: ColorM.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: ColorM.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      offset: const Offset(0, 6),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: pickedImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.memory(
                          pickedImageBytes!,
                          width: 98,
                          height: 98,
                          fit: BoxFit.cover,
                        ),
                      )
                    : AppCachedImage(
                        imageUrl: imageUrl,
                        width: 98,
                        height: 98,
                        borderRadius: BorderRadius.circular(24),
                        fallback: Container(
                          width: 98,
                          height: 98,
                          decoration: BoxDecoration(
                            color: ColorM.primary50,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person_rounded,
                            size: 46,
                            color: ColorM.primary,
                          ),
                        ),
                      ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: ColorM.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorM.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: ColorM.primary.withValues(alpha: 0.32),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 16,
                    color: ColorM.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: enabled ? onPickTap : null,
              style: TextButton.styleFrom(
                foregroundColor: ColorM.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              icon: const Icon(Icons.photo_camera_outlined, size: 16),
              label: Text(
                'Change Photo',
                style: TextStyle(
                  fontFamily: FontsM.inter.name,
                  fontSize: 13.5,
                  fontWeight: FontWeightM.semiBold,
                ),
              ),
            ),
            if (pickedImageBytes != null && onClearPickedTap != null) ...[
              const SizedBox(width: 4),
              TextButton.icon(
                onPressed: enabled ? onClearPickedTap : null,
                style: TextButton.styleFrom(
                  foregroundColor: ColorM.textSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                icon: const Icon(Icons.undo_rounded, size: 16),
                label: Text(
                  'Revert',
                  style: TextStyle(
                    fontFamily: FontsM.inter.name,
                    fontSize: 13.5,
                    fontWeight: FontWeightM.medium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class UpdateProfileImageSourceSheet extends StatelessWidget {
  const UpdateProfileImageSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorM.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorM.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Update Profile Photo',
              style: TextStyle(
                fontFamily: FontsM.inter.name,
                fontSize: 17,
                fontWeight: FontWeightM.bold,
                color: ColorM.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _ImageSourceOptionTile(
              icon: Icons.photo_library_outlined,
              iconColor: ColorM.primary,
              iconBackgroundColor: ColorM.primary50,
              title: 'Choose from Gallery',
              subtitle: 'Select a photo from your device',
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            const SizedBox(height: 10),
            _ImageSourceOptionTile(
              icon: Icons.camera_alt_outlined,
              iconColor: ColorM.primary,
              iconBackgroundColor: ColorM.primary50,
              title: 'Take a Photo',
              subtitle: 'Use your camera to capture a new photo',
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSourceOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ImageSourceOptionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorM.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorM.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: FontsM.inter.name,
                          fontSize: 14.5,
                          fontWeight: FontWeightM.semiBold,
                          color: ColorM.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: FontsM.inter.name,
                          fontSize: 12,
                          color: ColorM.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: ColorM.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

