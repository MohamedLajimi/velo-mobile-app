import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:karaba/core/common/models/bottom_sheet_option.dart';
import 'package:karaba/core/common/widgets/custom_avatar.dart';
import 'package:karaba/core/common/widgets/custom_media_bottom_sheet.dart';
import 'package:karaba/core/di/injection_container.dart';
import 'package:karaba/core/extensions/theme_extension.dart';
import 'package:karaba/core/services/media_service.dart';
import 'package:karaba/core/common/widgets/app_snackbar.dart';

class CustomAvatarSelector extends StatefulWidget {
  final String? initialImageUrl;
  final double radius;
  final ValueChanged<File?>? onImageChanged;
  final VoidCallback? onImageDeleted;

  const CustomAvatarSelector({
    super.key,
    this.initialImageUrl,
    this.radius = 50,
    this.onImageChanged,
    this.onImageDeleted,
  });

  @override
  State<CustomAvatarSelector> createState() => _CustomAvatarSelectorState();
}

class _CustomAvatarSelectorState extends State<CustomAvatarSelector> {
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomAvatar(
          imageUrl: _imageUrl,
          imageFile: _imageFile,
          radius: widget.radius,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _showImageOptions,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.surface,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                CupertinoIcons.camera,
                size: 18,
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showImageOptions() {
    final hasImage =
        _imageFile != null || (_imageUrl != null && _imageUrl!.isNotEmpty);

    final options = [
      BottomSheetOption(
        title: context.tr('media.take_photo'),
        icon: CupertinoIcons.camera,
        onTap: _takePhoto,
      ),
      BottomSheetOption(
        title: context.tr('media.choose_from_gallery'),
        icon: CupertinoIcons.photo,
        onTap: _pickFromGallery,
      ),
      if (hasImage)
        BottomSheetOption(
          title: context.tr('media.delete_photo'),
          icon: CupertinoIcons.trash,
          iconColor: context.colorScheme.error,
          textColor: context.colorScheme.error,
          onTap: _deleteImage,
        ),
    ];

    CustomMediaBottomSheet.show(context: context, options: options);
  }

  Future<void> _takePhoto() async {
    final result = await sl<MediaService>().pickSingleImage(
      source: ImageSource.camera,
    );

    result.fold(
      (failure) {
        if (mounted) {
          AppSnackbar.show(
            context,
            message: context.tr(failure.message),
            type: SnackBarType.error,
          );
        }
      },
      (file) {
        setState(() {
          _imageFile = file;
          _imageUrl = null;
        });
        widget.onImageChanged?.call(file);
      },
    );
  }

  Future<void> _pickFromGallery() async {
    final result = await sl<MediaService>().pickSingleImage(
      source: ImageSource.gallery,
    );

    result.fold(
      (failure) {
        if (mounted) {
          AppSnackbar.show(
            context,
            message: context.tr(failure.message),
            type: SnackBarType.error,
          );
        }
      },
      (file) {
        setState(() {
          _imageFile = file;
          _imageUrl = null;
        });
        widget.onImageChanged?.call(file);
      },
    );
  }

  void _deleteImage() {
    setState(() {
      _imageFile = null;
      _imageUrl = null;
    });
    widget.onImageChanged?.call(null);
    widget.onImageDeleted?.call();
  }
}
