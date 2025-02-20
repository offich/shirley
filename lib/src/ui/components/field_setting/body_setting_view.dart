import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/common/debouncer.dart';
import 'package:shirley/src/model/button_field.dart';
import 'package:shirley/src/ui/components/field_setting/color_picker_block.dart';
import 'package:shirley/src/ui/components/field_setting/field_text_input.dart';

class BodySettingView extends HookWidget {
  const BodySettingView({
    super.key,
    required this.field,
    required this.width,
    required this.height,
    this.onButtonStyleFieldChanged,
    this.onWidthChanged,
    this.onHeightChanged,
  });

  final ButtonField field;
  final double width;
  final double height;
  final void Function(ButtonStyle?)? onButtonStyleFieldChanged;
  final void Function(double)? onWidthChanged;
  final void Function(double)? onHeightChanged;

  @override
  Widget build(BuildContext context) {
    final debouncer = useState(Debouncer(milliseconds: 200));

    final initialBorderWidth =
        field.buttonStyle?.side?.resolve({})?.width.toString();
    final initialPadding =
        field.buttonStyle?.padding?.resolve({})?.resolve(null).top.toString();

    final padding = field.buttonStyle?.padding?.resolve({})?.resolve(null);
    final paddingLeft = padding?.left.toString();
    final paddingTop = padding?.top.toString();
    final paddingRight = padding?.right.toString();
    final paddingBottom = padding?.bottom.toString();

    String? borderRadius;

    useEffect(() {
      final shape = field.buttonStyle?.shape?.resolve({});

      if (shape is RoundedRectangleBorder) {
        borderRadius = shape.borderRadius.resolve(null).topRight.x.toString();
      }

      return;
    }, []);

    final updatePadding = useCallback(({
      double? left,
      double? top,
      double? right,
      double? bottom,
    }) {
      final existingPadding =
          field.buttonStyle?.padding?.resolve({})?.resolve(null);
      final copiedPadding = existingPadding?.copyWith(
        left: left ?? existingPadding.left,
        top: top ?? existingPadding.top,
        right: right ?? existingPadding.right,
        bottom: bottom ?? existingPadding.bottom,
      );
      final copied = field.buttonStyle?.copyWith(
        padding: WidgetStateProperty.all(copiedPadding),
      );

      onButtonStyleFieldChanged?.call(copied);
    }, [field]);

    return SingleChildScrollView(
      child: Column(
        spacing: 16.0,
        children: [
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
                  title: 'Width',
                  placeholder: '120',
                  value: width.toString(),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed == null) {
                      return;
                    }

                    onWidthChanged?.call(parsed);
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Height',
                  placeholder: '80',
                  value: height.toString(),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed == null) {
                      return;
                    }

                    onHeightChanged?.call(parsed);
                  },
                ),
              ),
              Spacer(),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: FieldTextInput(
                  title: 'Overall Border Width',
                  placeholder: '4',
                  value: initialBorderWidth,
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
                  value: borderRadius,
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed == null) return;

                    final existingShape =
                        (field.buttonStyle?.shape?.resolve({}) ??
                            RoundedRectangleBorder()) as RoundedRectangleBorder;
                    final copiedShape = existingShape.copyWith(
                        borderRadius: BorderRadius.circular(parsed.toDouble()));
                    final copied = field.buttonStyle?.copyWith(
                      shape: WidgetStateProperty.all(copiedShape),
                    );

                    onButtonStyleFieldChanged?.call(copied);
                  },
                ),
              ),
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
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                flex: 2,
                child: FieldTextInput(
                  title: 'Overall Padding',
                  placeholder: '2',
                  value: initialPadding,
                  onChanged: (value) {
                    debouncer.value.run(() {
                      final parsed = int.tryParse(value);
                      if (parsed == null) return;

                      updatePadding(
                        left: parsed.toDouble(),
                        top: parsed.toDouble(),
                        right: parsed.toDouble(),
                        bottom: parsed.toDouble(),
                      );
                    });
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Left',
                  placeholder: '2',
                  value: paddingLeft,
                  onChanged: (value) {
                    debouncer.value.run(() {
                      final parsed = int.tryParse(value);
                      if (parsed == null) return;

                      updatePadding(left: parsed.toDouble());
                    });
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Top',
                  placeholder: '2',
                  value: paddingTop,
                  onChanged: (value) {
                    debouncer.value.run(() {
                      final parsed = int.tryParse(value);
                      if (parsed == null) return;

                      updatePadding(top: parsed.toDouble());
                    });
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Right',
                  placeholder: '2',
                  value: paddingRight,
                  onChanged: (value) {
                    debouncer.value.run(() {
                      final parsed = int.tryParse(value);
                      if (parsed == null) return;

                      updatePadding(right: parsed.toDouble());
                    });
                  },
                ),
              ),
              Expanded(
                child: FieldTextInput(
                  title: 'Bottom',
                  placeholder: '2',
                  value: paddingBottom,
                  onChanged: (value) {
                    debouncer.value.run(() {
                      final parsed = int.tryParse(value);
                      if (parsed == null) return;

                      updatePadding(bottom: parsed.toDouble());
                    });
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
