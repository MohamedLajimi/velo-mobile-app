import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const .symmetric(horizontal: 16),
          child: Text(
            context.tr('auth.login.continue_with'),
            style: context.textTheme.bodyMedium,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
