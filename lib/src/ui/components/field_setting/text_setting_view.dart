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
    const primaryColor = Color.fromRGBO(228, 23, 73, 1);

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.0,
                  children: [
                    Text('Font Weight', style: TextStyle(fontSize: 14)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                      ),
                      child: DropdownButton<FontWeight>(
                        isDense: true,
                        isExpanded: true,
                        underline: SizedBox.shrink(),
                        padding: const EdgeInsets.all(4),
                        style: Theme.of(context)
                            .dropdownMenuTheme
                            .textStyle
                            ?.copyWith(fontSize: 16),
                        items: FontWeight.values.map((fontWeight) {
                          return DropdownMenuItem(
                            value: fontWeight,
                            child: Text(fontWeight.value.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          final merged = field.textStyle
                              ?.merge(TextStyle(fontWeight: value));
                          onTextStyleFieldChanged?.call(merged);
                        },
                        value: field.textStyle?.fontWeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
