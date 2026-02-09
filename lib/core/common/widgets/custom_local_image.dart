import 'dart:io';
import 'package:flutter/material.dart';
import 'package:karaba/core/common/widgets/custom_error_image.dart';

class CustomLocalImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const CustomLocalImage({
    super.key,
    required this.path,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) =>
            CustomErrorImage(width: width, height: height),
      ),
    );
  }
}
