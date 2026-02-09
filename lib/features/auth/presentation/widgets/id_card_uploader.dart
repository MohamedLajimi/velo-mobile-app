import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:karaba/core/common/models/bottom_sheet_option.dart';
import 'package:karaba/core/common/widgets/app_snackbar.dart';
import 'package:karaba/core/common/widgets/custom_adaptive_image.dart';
import 'package:karaba/core/common/widgets/custom_media_bottom_sheet.dart';
import 'package:karaba/core/common/widgets/custom_media_placeholder.dart';
import 'package:karaba/core/di/injection_container.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/core/extensions/theme_extension.dart';
import 'package:karaba/core/services/media_service.dart';

class IdCardUploader extends StatefulWidget {
  final String? initialPath;
  final ValueChanged<String?> onChanged;

  const IdCardUploader({super.key, this.initialPath, required this.onChanged});

  @override
  State<IdCardUploader> createState() => _IdCardUploaderState();
}

class _IdCardUploaderState extends State<IdCardUploader> {
  String? _path;

  @override
  void initState() {
    super.initState();
    _path = widget.initialPath;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          context.tr('auth.signup.id_card'),
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        12.vSpace,
        _path == null
            ? CustomMediaPlaceholder(
                onTap: () => _showOptions(context),
                icon: CupertinoIcons.doc_plaintext,
                title: context.tr('auth.signup.upload_id_card'),
                subtitle: context.tr('auth.signup.upload_id_card_hint'),
                width: double.infinity,
                height: double.infinity,
              )
            : _buildPreview(context),
      ],
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Stack(
      children: [
        CustomAdaptiveImage(
          path: _path!,
          borderRadius: .circular(16),
          width: .infinity,
          height: 180,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: .circular(16),
            gradient: LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _deleteImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: .circle,
              ),
              child: const Icon(
                CupertinoIcons.xmark,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showOptions(BuildContext context) {
    CustomMediaBottomSheet.show(
      context: context,
      options: [
        BottomSheetOption(
          title: context.tr('media.take_photo'),
          icon: CupertinoIcons.camera,
          onTap: () => _pickImage(ImageSource.camera),
        ),
        BottomSheetOption(
          title: context.tr('media.choose_from_gallery'),
          icon: CupertinoIcons.photo,
          onTap: () => _pickImage(ImageSource.gallery),
        ),
        if (_path != null)
          BottomSheetOption(
            title: context.tr('media.delete_photo'),
            icon: CupertinoIcons.trash,
            iconColor: context.colorScheme.error,
            textColor: context.colorScheme.error,
            onTap: _deleteImage,
          ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final result = await sl<MediaService>().pickSingleImage(source: source);

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
        setState(() => _path = file.path);
        widget.onChanged(file.path);
      },
    );
  }

  void _deleteImage() {
    setState(() => _path = null);
    widget.onChanged(null);
  }
}
