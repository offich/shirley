import 'package:flutter/material.dart';
import 'package:shirley/src/ui/components/dialog/color_picker_dialog.dart';

class ColorPickerBlock extends StatelessWidget {
  const ColorPickerBlock({
    super.key,
    required this.title,
    required this.pickerColor,
    required this.onColorChanged,
  });

  final String title;
  final Color pickerColor;
  final Function(Color) onColorChanged;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(228, 23, 73, 1);

    return GestureDetector(
      onTap: () async {
        await showColorPickerDialog(
          context,
          pickerColor: pickerColor,
          onColorChanged: onColorChanged,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,
        children: [
          Text(title, style: TextStyle(fontSize: 14)),
          Container(
            decoration: BoxDecoration(
              color: pickerColor,
              border: Border.all(width: 2.0, color: primaryColor),
              borderRadius: BorderRadius.circular(4),
            ),
            height: 36,
          )
        ],
      ),
    );
  }
}
