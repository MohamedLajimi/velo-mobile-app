import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karaba/core/common/blocs/language_cubit/language_cubit.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class LanguageDropdownSelector extends StatelessWidget {
  const LanguageDropdownSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentCode = context.locale.languageCode;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: DropdownButton<String>(
        borderRadius: .circular(16),
        alignment: .centerRight,
        padding: const .only(right: 8),
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        value: currentCode,
        underline: const SizedBox(),
        icon: const Icon(CupertinoIcons.globe, size: 20),
        onChanged: (String? code) {
          if (code != null && code != currentCode) {
            final newLocale = Locale(code);
            context.setLocale(newLocale);
            context.read<LanguageCubit>().changeLanguage(newLocale);
          }
        },
        items: const [
          DropdownMenuItem(value: 'en', child: Text('EN')),
          DropdownMenuItem(value: 'fr', child: Text('FR')),
        ],
      ),
    );
  }
}
