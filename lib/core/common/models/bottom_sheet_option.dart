import 'package:flutter/material.dart';

class BottomSheetOption {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const BottomSheetOption({
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });
}