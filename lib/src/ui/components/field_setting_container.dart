import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/model/button_field.dart';
import 'package:shirley/src/ui/components/field_setting/body_setting_view.dart';
import 'package:shirley/src/ui/components/field_setting/quick_setting_view.dart';
import 'package:shirley/src/ui/components/field_setting/text_setting_view.dart';

class FieldSettingContainer extends HookWidget {
  const FieldSettingContainer({
    super.key,
    required this.field,
    this.onTextChanged,
    this.onTextStyleFieldChanged,
    this.onButtonStyleFieldChanged,
    this.onWidthChanged,
    this.onHeightChanged,
  });

  final ButtonField field;
  final void Function(String)? onTextChanged;
  final void Function(TextStyle?)? onTextStyleFieldChanged;
  final void Function(ButtonStyle?)? onButtonStyleFieldChanged;
  final void Function(double)? onWidthChanged;
  final void Function(double)? onHeightChanged;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(228, 23, 73, 1);

    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            tabAlignment: TabAlignment.fill,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: primaryColor,
            labelStyle: TextStyle(fontSize: 16),
            splashBorderRadius:
                const BorderRadius.vertical(top: Radius.circular(4)),
            overlayColor: WidgetStateProperty.all(
              primaryColor.withAlpha((255.0 * 0.1).round()),
            ),
            tabs: [
              Tab(child: Text('Quick Settings')),
              Tab(child: Text('Body')),
              Tab(child: Text('Text')),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  QuickSettingView(
                    field: field,
                    onTextChanged: onTextChanged,
                    onTextStyleFieldChanged: onTextStyleFieldChanged,
                    onButtonStyleFieldChanged: onButtonStyleFieldChanged,
                  ),
                  BodySettingView(
                    field: field,
                    width: field.width ?? 0.0,
                    height: field.height ?? 0.0,
                    onButtonStyleFieldChanged: onButtonStyleFieldChanged,
                    onWidthChanged: onWidthChanged,
                    onHeightChanged: onHeightChanged,
                  ),
                  TextSettingView(
                    field: field,
                    onTextChanged: onTextChanged,
                    onTextStyleFieldChanged: onTextStyleFieldChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
