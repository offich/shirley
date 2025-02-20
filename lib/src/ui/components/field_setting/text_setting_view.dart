import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/model/button_field.dart';
import 'package:shirley/src/ui/components/field_setting/color_picker_block.dart';
import 'package:shirley/src/ui/components/field_setting/field_text_input.dart';

class TextSettingView extends HookWidget {
  const TextSettingView({
    super.key,
    required this.field,
    this.onTextChanged,
    this.onTextStyleFieldChanged,
  });

  final ButtonField field;
  final Function(String)? onTextChanged;
  final Function(TextStyle?)? onTextStyleFieldChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 16.0,
        children: [
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ColorPickerBlock(
                  title: 'Text Color',
                  pickerColor: field.textStyle?.color ?? Colors.black,
                  onColorChanged: (color) {
                    final merged =
                        field.textStyle?.merge(TextStyle(color: color));
                    onTextStyleFieldChanged?.call(merged);
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Content',
                  placeholder: 'Normal Button',
                  value: field.text,
                  onChanged: (value) {
                    onTextChanged?.call(value);
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Font Size',
                  placeholder: '12',
                  value: field.textStyle?.fontSize?.toString(),
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed == null) {
                      return;
                    }

                    final merged = field.textStyle
                        ?.merge(TextStyle(fontSize: parsed.toDouble()));
                    onTextStyleFieldChanged?.call(merged);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
