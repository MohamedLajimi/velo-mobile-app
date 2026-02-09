import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:karaba/core/common/widgets/custom_error_image.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipper: borderRadius != null
          ? _BorderRadiusClipper(borderRadius!)
          : null,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => Container(
          width: width,
          height: height,
          color: context.colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, _, _) =>
            CustomErrorImage(width: width, height: height),
      ),
    );
  }
}

class _BorderRadiusClipper extends CustomClipper<RRect> {
  final BorderRadius borderRadius;
  _BorderRadiusClipper(this.borderRadius);

  @override
  RRect getClip(Size size) => borderRadius
      .resolve(TextDirection.ltr)
      .toRRect(Rect.fromLTWH(0, 0, size.width, size.height));

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}
