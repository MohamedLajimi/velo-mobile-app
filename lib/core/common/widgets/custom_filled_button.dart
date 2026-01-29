import 'package:flutter/material.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final bool? isEnabled;

  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isEnabled == true && !isLoading) ? onPressed : null,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(double.infinity, 55),
        backgroundColor: isEnabled ?? true
            ? backgroundColor
            : context.colorScheme.surfaceContainer,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
    );
  }
}
