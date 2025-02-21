import 'package:flutter/material.dart';
import 'package:shirley/src/model/button_field.dart';

class PresetButton extends StatelessWidget {
  const PresetButton({
    super.key,
    required this.preset,
    this.onPressed,
  });

  final ButtonField preset;
  final void Function(ButtonField)? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: preset.buttonStyle,
      onPressed: () => onPressed?.call(preset),
      child: Text(preset.text ?? '', style: preset.textStyle),
    );
  }
}
