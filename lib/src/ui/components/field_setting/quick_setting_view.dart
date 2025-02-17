import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/model/button_field.dart';
import 'package:shirley/src/ui/components/field_setting/color_picker_block.dart';
import 'package:shirley/src/ui/components/field_setting/field_text_input.dart';

class QuickSettingView extends HookWidget {
  const QuickSettingView({
    super.key,
    required this.field,
    this.onTextChanged,
    this.onTextStyleFieldChanged,
    this.onButtonStyleFieldChanged,
  });

  final ButtonField field;
  final void Function(String)? onTextChanged;
  final void Function(TextStyle?)? onTextStyleFieldChanged;
  final void Function(ButtonStyle?)? onButtonStyleFieldChanged;

  @override
  Widget build(BuildContext context) {
    final initialPadding =
        field.buttonStyle?.padding?.resolve({})?.resolve(null).top.toString();
    final initialBorderWidth =
        field.buttonStyle?.side?.resolve({})?.width.toString();

    String? borderRadius;

    useEffect(() {
      final shape = field.buttonStyle?.shape?.resolve({});

      if (shape is RoundedRectangleBorder) {
        borderRadius = shape.borderRadius.resolve(null).topRight.x.toString();
      }

      return;
    }, []);

    final content = useState(field.text ?? '');
    final fontSize = useState(field.textStyle?.fontSize?.toString() ?? '');

    return SingleChildScrollView(
      child: Column(
        spacing: 16.0,
        children: [
          Row(spacing: 8.0, children: [
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
                initialText: field.text,
                onChanged: (value) {
                  content.value = value;
                  onTextChanged?.call(value);
                },
              ),
            ),
            Expanded(
              child: FieldTextInput(
                title: 'Font Size',
                placeholder: '12',
                initialText: field.textStyle?.fontSize?.toString(),
                onChanged: (value) {
                  fontSize.value = value;
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
          ]),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ColorPickerBlock(
                  title: 'Border Color',
                  pickerColor: field.buttonStyle?.side?.resolve({})?.color ??
                      Colors.black,
                  onColorChanged: (color) {
                    final existingBorderSide =
                        field.buttonStyle?.side?.resolve({}) ?? BorderSide();
                    final copiedBorderSide =
                        existingBorderSide.copyWith(color: color);
                    final copied = field.buttonStyle?.copyWith(
                      side: WidgetStateProperty.all(copiedBorderSide),
                    );

                    onButtonStyleFieldChanged?.call(copied);
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Border Width',
                  placeholder: '4',
                  initialText: initialBorderWidth,
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed == null) return;

                    final existingBorderSide =
                        field.buttonStyle?.side?.resolve({}) ?? BorderSide();
                    final copiedBorderSide =
                        existingBorderSide.copyWith(width: parsed.toDouble());
                    final copied = field.buttonStyle?.copyWith(
                      side: WidgetStateProperty.all(copiedBorderSide),
                    );

                    onButtonStyleFieldChanged?.call(copied);
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Border Radius',
                  placeholder: '4',
                  initialText: borderRadius,
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed == null) return;

                    final existingBorderSide =
                        field.buttonStyle?.side?.resolve({}) ?? BorderSide();
                    final copiedBorderSide =
                        existingBorderSide.copyWith(width: parsed.toDouble());
                    final copied = field.buttonStyle?.copyWith(
                      side: WidgetStateProperty.all(copiedBorderSide),
                    );

                    onButtonStyleFieldChanged?.call(copied);
                  },
                ),
              ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ColorPickerBlock(
                  title: 'Background Color',
                  pickerColor: field.backgroundColor ?? Colors.orange,
                  onColorChanged: (color) {
                    final copied = field.buttonStyle?.copyWith(
                        backgroundColor: WidgetStateProperty.all(color));

                    onButtonStyleFieldChanged?.call(copied);
                  },
                ),
              ),
              Spacer(),
              Spacer(),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: FieldTextInput(
                  title: 'Padding',
                  placeholder: '2',
                  initialText: initialPadding,
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed == null) return;

                    final existingPadding =
                        field.buttonStyle?.padding?.resolve({})?.resolve(null);
                    final copiedPadding = existingPadding?.copyWith(
                      left: parsed.toDouble(),
                      top: parsed.toDouble(),
                      right: parsed.toDouble(),
                      bottom: parsed.toDouble(),
                    );
                    final copied = field.buttonStyle?.copyWith(
                      padding: WidgetStateProperty.all(copiedPadding),
                    );

                    onButtonStyleFieldChanged?.call(copied);
                  },
                ),
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
