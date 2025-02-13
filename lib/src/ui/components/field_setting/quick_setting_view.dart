import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/dialog/color_picker_dialog.dart';

class QuickSettingView extends HookWidget {
  const QuickSettingView({
    super.key,
    required this.backgroundColor,
    this.onColorChanged,
  });

  final Color backgroundColor;
  final void Function(Color)? onColorChanged;

  @override
  Widget build(BuildContext context) {
    final buttonTextEditingController =
        useTextEditingController(text: 'content');

    final content = useState('');

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
                  pickerColor: backgroundColor,
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
                      color: backgroundColor,
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
        Row(children: [
          SizedBox(
            width: 120,
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
        ])
      ],
    );
  }
}
