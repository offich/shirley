import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/dynamic_widget.dart';

class PreviewWidgetView extends HookWidget {
  const PreviewWidgetView({required this.json, super.key});

  final String json;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [DynamicWidget(jsonString: json)],
    );
  }
}
