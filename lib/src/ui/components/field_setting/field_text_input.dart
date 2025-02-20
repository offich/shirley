import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FieldTextInput extends HookWidget {
  const FieldTextInput({
    super.key,
    required this.title,
    this.value,
    this.placeholder,
    this.syncable = false,
    this.onChanged,
  });

  final String title;
  final String? value;
  final String? placeholder;
  final bool syncable;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: value);

    useEffect(() {
      if (!syncable) return;

      controller.text = value ?? '';
      return;
    }, [value]);

    const primaryColor = Color.fromRGBO(228, 23, 73, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        TextField(
          cursorColor: primaryColor,
          decoration: InputDecoration(
            isDense: true,
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
          ),
          controller: controller,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
