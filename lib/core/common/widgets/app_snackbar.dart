import 'package:flutter/material.dart';
import 'package:karaba/core/extensions/theme_extension.dart';
import 'package:karaba/core/theme/app_palette.dart';

enum SnackBarType { success, error }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final isError = type == SnackBarType.error;

    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;
    final iconColor = isError ? AppPalette.error : AppPalette.success;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: context.textTheme.bodyMedium)),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: context.colorScheme.primary,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }
}
