import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<void> showColorPickerDialog(
  BuildContext parentContext, {
  required Color pickerColor,
  required Function(Color) onColorChanged,
}) {
  return showDialog(
    context: parentContext,
    builder: (context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: onColorChanged,
            ),
          ),
        ),
      );
    },
  );
}
