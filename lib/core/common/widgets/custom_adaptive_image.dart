import 'package:flutter/material.dart';
import 'package:karaba/core/common/widgets/custom_local_image.dart';
import 'package:karaba/core/common/widgets/custom_network_image.dart';

class CustomAdaptiveImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const CustomAdaptiveImage({
    super.key,
    required this.path,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  bool get _isNetworkUrl =>
      path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return _isNetworkUrl
        ? CustomNetworkImage(
            url: path,
            width: width,
            height: height,
            borderRadius: borderRadius,
            fit: fit,
          )
        : CustomLocalImage(
            path: path,
            width: width,
            height: height,
            borderRadius: borderRadius,
            fit: fit,
          );
  }
}
