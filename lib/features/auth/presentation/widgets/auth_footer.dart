import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class AuthFooter extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback onTextPressed;

  const AuthFooter({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onTextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        RichText(
          text: TextSpan(
            text: '$firstText ',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            children: [
              TextSpan(
                text: secondText,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTextPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
