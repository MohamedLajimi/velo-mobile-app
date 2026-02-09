import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool? isRequired;
  final TextInputType? inputType;
  final bool isObscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isRequired = true,
    this.inputType = TextInputType.text,
    this.isObscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      keyboardType: inputType,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      style: context.textTheme.bodyMedium,
      validator: (value) {
        if (isRequired == true && (value == null || value.trim().isEmpty)) {
          return "$hintText ${context.tr('validation.is_required')}";
        }
        return validator?.call(value);
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: context.colorScheme.onSurfaceVariant,
                size: 18,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onTapSuffixIcon,
                icon: Icon(suffixIcon, color: context.colorScheme.primary),
              )
            : null,
      ),
    );
  }
}
