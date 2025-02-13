import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/field_setting/body_setting_view.dart';
import 'package:shirley/src/ui/components/field_setting/quick_setting_view.dart';
import 'package:shirley/src/ui/components/field_setting/text_setting_view.dart';

class FieldSettingContainer extends HookWidget {
  const FieldSettingContainer({super.key, required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            tabAlignment: TabAlignment.fill,
            tabs: [
              Tab(child: Text('Quick Settings')),
              Tab(child: Text('Body')),
              Tab(child: Text('Main Text')),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              children: [
                QuickSettingView(backgroundColor: backgroundColor),
                BodySettingView(),
                TextSettingView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
