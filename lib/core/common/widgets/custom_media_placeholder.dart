import 'package:flutter/material.dart';
import 'package:karaba/core/extensions/spacing_extension.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class CustomMediaPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final double width;
  final double height;
  final VoidCallback onTap;

  const CustomMediaPlaceholder({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.theme.dividerColor, width: 1.5),
          color: context.colorScheme.surfaceContainer.withValues(alpha: 0.3),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: context.colorScheme.onSurfaceVariant),
              10.vSpace,
              Text(
                title,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                6.vSpace,
                Text(
                  subtitle!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
