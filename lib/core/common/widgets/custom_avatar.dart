import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final double radius;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colorScheme.surfaceContainer,
      child: ClipOval(child: _buildImage()),
    );
  }

  Widget _buildImage() {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Icon(CupertinoIcons.person, size: radius);
  }
}
