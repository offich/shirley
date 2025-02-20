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

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Column(
        spacing: 24.0,
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
          ]),
          Column(
            spacing: 8.0,
            children: [
              Row(
                spacing: 8.0,
                children: <Widget>[
                  SizedBox(width: 40, child: Divider()),
                  Text(
                    'Border',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              Row(
                spacing: 8.0,
                children: [
                  Expanded(
                    child: ColorPickerBlock(
                      title: 'Border Color',
                      pickerColor:
                          field.buttonStyle?.side?.resolve({})?.color ??
                              Colors.black,
                      onColorChanged: (color) {
                        final existingBorderSide =
                            field.buttonStyle?.side?.resolve({}) ??
                                BorderSide();
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
                      value: initialBorderWidth,
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed == null) return;

                        final existingBorderSide =
                            field.buttonStyle?.side?.resolve({}) ??
                                BorderSide();
                        final copiedBorderSide = existingBorderSide.copyWith(
                            width: parsed.toDouble());
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
                      value: borderRadius,
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed == null) return;

                        final existingShape = (field.buttonStyle?.shape
                                ?.resolve({}) ??
                            RoundedRectangleBorder()) as RoundedRectangleBorder;
                        final copiedShape = existingShape.copyWith(
                            borderRadius:
                                BorderRadius.circular(parsed.toDouble()));
                        final copied = field.buttonStyle?.copyWith(
                          shape: WidgetStateProperty.all(copiedShape),
                        );

                        onButtonStyleFieldChanged?.call(copied);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            spacing: 8.0,
            children: [
              Row(
                spacing: 8.0,
                children: <Widget>[
                  SizedBox(width: 40, child: Divider()),
                  Text(
                    'Background',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Expanded(child: Divider()),
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
            ],
          ),
          Column(
            spacing: 8.0,
            children: [
              Row(
                spacing: 8.0,
                children: <Widget>[
                  SizedBox(width: 40, child: Divider()),
                  Text(
                    'Padding',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              Row(
                spacing: 8.0,
                children: [
                  Expanded(
                    child: FieldTextInput(
                      title: 'Padding',
                      placeholder: '2',
                      value: initialPadding,
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed == null) return;

                        final existingPadding = field.buttonStyle?.padding
                            ?.resolve({})?.resolve(null);
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
        ],
      ),
    );
  }
}
