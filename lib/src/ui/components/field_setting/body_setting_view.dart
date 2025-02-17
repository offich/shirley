import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/field_setting/field_text_input.dart';

class BodySettingView extends HookWidget {
  const BodySettingView({
    super.key,
    required this.width,
    required this.height,
    this.onWidthChanged,
    this.onHeightChanged,
  });

  final double width;
  final double height;
  final void Function(double)? onWidthChanged;
  final void Function(double)? onHeightChanged;

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
                child: FieldTextInput(
                  title: 'Width',
                  placeholder: '120',
                  initialText: width.toString(),
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
                  initialText: height.toString(),
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
        ],
      ),
    );
  }
}
