import 'package:flutter/material.dart';

class AppDimensions {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleFactor;

  static void init(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    scaleFactor = screenWidth / 375;
  }

  static double sp(double size, {double min = 0.8, double max = 1.2}) {
    double scaledSize = size * scaleFactor;
    return scaledSize.clamp(size * min, size * max);
  }
}
