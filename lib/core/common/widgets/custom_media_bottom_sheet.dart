import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaba/core/common/models/bottom_sheet_option.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class CustomMediaBottomSheet extends StatelessWidget {
  final String? title;
  final List<BottomSheetOption> options;

  const CustomMediaBottomSheet({super.key, this.title, required this.options});

  static Future<void> show({
    required BuildContext context,
    String? title,
    required List<BottomSheetOption> options,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          CustomMediaBottomSheet(title: title, options: options),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.4,
              ),
              borderRadius: .circular(2),
            ),
          ),

          if (title != null) ...[
            16.vSpace,
            Text(
              title!,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            20.vSpace,
          ] else
            16.vSpace,

          ...options.map((option) => _OptionTile(option: option)),

          8.vSpace,
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final BottomSheetOption option;

  const _OptionTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
        option.onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        contentPadding: .zero,
        leading: Icon(
          option.icon,
          color: option.iconColor ?? context.colorScheme.primary,
          size: 24,
        ),
        title: Text(
          option.title,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: option.textColor ?? context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
