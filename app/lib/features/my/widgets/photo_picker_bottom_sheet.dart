import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_strings.dart';

/// 프로필 사진 선택 BottomSheet.
/// 갤러리에서 선택, 카메라로 촬영, 사진 삭제(기존 사진 있을 때만) 옵션을 제공한다.
class PhotoPickerBottomSheet extends StatelessWidget {
  final bool hasExistingPhoto;
  final VoidCallback onGallery;
  final VoidCallback onCamera;
  final VoidCallback? onDelete;

  const PhotoPickerBottomSheet({
    super.key,
    required this.hasExistingPhoto,
    required this.onGallery,
    required this.onCamera,
    this.onDelete,
  });

  /// 바텀시트를 표시한다.
  static void show({
    required BuildContext context,
    required bool hasExistingPhoto,
    required VoidCallback onGallery,
    required VoidCallback onCamera,
    VoidCallback? onDelete,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.darkCard : AppColors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      builder: (ctx) {
        return PhotoPickerBottomSheet(
          hasExistingPhoto: hasExistingPhoto,
          onGallery: () {
            Navigator.pop(ctx);
            onGallery();
          },
          onCamera: () {
            Navigator.pop(ctx);
            onCamera();
          },
          onDelete: hasExistingPhoto
              ? () {
                  Navigator.pop(ctx);
                  onDelete?.call();
                }
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.iconTheme.color ?? theme.colorScheme.onSurface;

    return SafeArea(
      key: const ValueKey('photo_picker_bottom_sheet'),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const ValueKey('photo_gallery_option'),
              leading: Icon(Icons.photo_library_outlined, color: iconColor),
              title: Text(
                AppStrings.selectFromGallery,
                style: theme.textTheme.bodyLarge,
              ),
              onTap: onGallery,
            ),
            ListTile(
              key: const ValueKey('photo_camera_option'),
              leading: Icon(Icons.camera_alt_outlined, color: iconColor),
              title: Text(
                AppStrings.takePhoto,
                style: theme.textTheme.bodyLarge,
              ),
              onTap: onCamera,
            ),
            if (hasExistingPhoto && onDelete != null)
              ListTile(
                key: const ValueKey('photo_delete_option'),
                leading: Icon(Icons.delete_outline,
                    color: theme.colorScheme.error),
                title: Text(
                  AppStrings.deletePhoto,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                onTap: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
