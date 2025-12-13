import 'package:flutter/material.dart';

mixin AppColors {
  Color getTextColor(Color backgroundColor, {bool inverted = false}) {
    final isLight = backgroundColor.computeLuminance() > 0.5;

    if (!inverted) {
      // Normal behavior
      // Light → black, Dark → white
      return isLight ? Colors.black : Colors.white;
    } else {
      // Opposite behavior
      // Light → white, Dark → black
      return isLight ? Colors.white : Colors.black;
    }
  }
}
