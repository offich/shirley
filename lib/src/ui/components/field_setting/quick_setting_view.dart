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

    return Column(children: [
      Row(children: [
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
          child: Container(
            color: backgroundColor,
            width: 200,
            height: 200,
          ),
        ),
        SizedBox(
          width: 200,
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
        )
      ])
    ]);
  }
}
