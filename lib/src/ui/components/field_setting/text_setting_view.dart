import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextSettingView extends HookWidget {
  const TextSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [SizedBox.shrink()]));
  }
}
