import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuickSettingView extends HookWidget {
  const QuickSettingView({super.key, required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final buttonTextEditingController =
        useTextEditingController(text: 'content');

    final content = useState('');

    return Column(children: [
      Row(children: [
        Container(
          color: backgroundColor,
          width: 200,
          height: 200,
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
