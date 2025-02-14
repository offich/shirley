import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/model/button_field.dart';
import 'package:shirley/src/ui/components/dialog/color_picker_dialog.dart';

class QuickSettingView extends HookWidget {
  const QuickSettingView({
    super.key,
    required this.field,
    this.onColorChanged,
  });

  final ButtonField field;
  final void Function(Color)? onColorChanged;

  @override
  Widget build(BuildContext context) {
    final buttonTextEditingController =
        useTextEditingController(text: field.text ?? '');
    final fontSizeTextEditingController = useTextEditingController(
      text: field.textStyle?.fontSize?.toString() ?? '',
    );

    final content = useState(field.text ?? '');
    final fontSize = useState(field.textStyle?.fontSize?.toString() ?? '');

    return Column(
      spacing: 16.0,
      children: [
        Row(
          spacing: 8.0,
          children: [
            GestureDetector(
              onTap: () async {
                await showColorPickerDialog(
                  context,
                  pickerColor: field.backgroundColor ?? Colors.orange,
                  onColorChanged: (color) {
                    onColorChanged?.call(color);
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text('Background Color', style: TextStyle(fontSize: 14)),
                  Container(
                    decoration: BoxDecoration(
                      color: field.backgroundColor ?? Colors.orange,
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: 200,
                    height: 32,
                  )
                ],
              ),
            ),
          ],
        ),
        Row(spacing: 8.0, children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Content',
                hintText: 'Normal Button',
              ),
              controller: buttonTextEditingController,
              onChanged: (value) {
                content.value = value;
              },
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Font Size',
                hintText: '12',
              ),
              controller: fontSizeTextEditingController,
              onChanged: (value) {
                fontSize.value = value;
              },
            ),
          ),
        ])
      ],
    );
  }
}
