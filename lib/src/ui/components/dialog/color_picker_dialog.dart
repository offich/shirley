import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future<void> showColorPickerDialog(
  BuildContext parentContext, {
  required Color pickerColor,
  required Function(Color) onColorChanged,
}) {
  return showDialog(
    context: parentContext,
    builder: (context) {
      return ColorPickerDialog(
        pickerColor: pickerColor,
        onColorChanged: onColorChanged,
      );
    },
  );
}

class ColorPickerDialog extends HookWidget {
  const ColorPickerDialog({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  final Color pickerColor;
  final Function(Color) onColorChanged;

  @override
  Widget build(BuildContext context) {
    final pickedColor = useState(pickerColor);

    return AlertDialog(
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: ColorPicker(
            pickerColor: pickedColor.value,
            onColorChanged: (color) {
              pickedColor.value = color;
              onColorChanged(color);
            },
            labelTypes: [ColorLabelType.rgb],
            pickerAreaBorderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
