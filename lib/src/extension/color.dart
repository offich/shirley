import 'package:flutter/material.dart';

extension ColorExtension on Color {
  int get redValue {
    return (r * 255).round();
  }

  int get greenValue {
    return (g * 255).round();
  }

  int get blueValue {
    return (b * 255).round();
  }

  int get alphaValue {
    return (a * 255).round();
  }

  String get toHex {
    return '#'
        '${alphaValue.toRadixString(16).padLeft(2, '0')}'
        '${redValue.toRadixString(16).padLeft(2, '0')}'
        '${greenValue.toRadixString(16).padLeft(2, '0')}'
        '${blueValue.toRadixString(16).padLeft(2, '0')}';
  }
}
