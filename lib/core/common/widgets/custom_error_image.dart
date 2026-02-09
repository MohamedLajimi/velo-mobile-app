import 'package:flutter/cupertino.dart';
import 'package:karaba/core/extensions/theme_extension.dart';

class CustomErrorImage extends StatelessWidget {
  final double width;
  final double height;

  const CustomErrorImage({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: context.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          CupertinoIcons.exclamationmark_circle,
          color: context.colorScheme.error,
          size: 24,
        ),
      ),
    );
  }
}
