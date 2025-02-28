import 'package:devtools_extensions/api.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/common/widget.dart';
import 'package:shirley/src/model/button_field.dart';
import 'package:shirley/src/ui/components/dynamic_widget.dart';
import 'package:shirley/src/ui/components/field_setting_container.dart';
import 'package:shirley/src/ui/components/preview_container.dart';
import 'package:shirley/src/ui/style/color.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class ShirleyDevToolsExtension extends HookWidget {
  const ShirleyDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    final updatedTheme = useState<HighlighterTheme?>(null);

    return DevToolsExtension(
      eventHandlers: {
        DevToolsExtensionEventType.themeUpdate: (event) async {
          if (event.data == null) return;

          final newTheme = event.data!['theme'];
          updatedTheme.value = newTheme == 'dark'
              ? await HighlighterTheme.loadDarkTheme()
              : await HighlighterTheme.loadLightTheme();
        },
      },
      child: Shirley(updatedTheme: updatedTheme.value),
    );
  }
}

class Shirley extends HookWidget {
  const Shirley({super.key, this.updatedTheme});

  final HighlighterTheme? updatedTheme;

  @override
  Widget build(BuildContext context) {
    final theme = useState<HighlighterTheme?>(null);
    final code = useState('');
    final jsonString = useState('');

    final buttonField = useState(ButtonField(
      text: '1.Normal Button',
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      height: 80,
      width: 120,
      buttonStyle: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(4),
        backgroundColor: ShirleyColor.secondaryColor,
        side: BorderSide(color: ShirleyColor.primaryColor, width: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ));

    useEffect(() {
      afterBuild((_) async {
        await Highlighter.initialize(['dart']);

        if (context.mounted) {
          theme.value = await HighlighterTheme.loadForContext(context);
        }
      });

      return;
    }, []);

    useEffect(() {
      code.value = buttonField.value.toCode();
      jsonString.value = buttonField.value.toJsonString();

      return;
    }, [buttonField.value]);

    useEffect(() {
      theme.value = updatedTheme;

      return;
    }, [updatedTheme]);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          spacing: 24.0,
          children: [
            Column(
              spacing: 24.0,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Shirley - Button Generator DevTools',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontSize: 28),
                ),
                Builder(builder: (context) {
                  final presets = [
                    ButtonField(
                      text: 'Get started',
                      height: 40,
                      width: 120,
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(19, 39, 67, 1),
                        side: BorderSide(
                          color: Color.fromRGBO(215, 56, 94, 1),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      textStyle: TextStyle(
                        color: Color.fromRGBO(237, 201, 136, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ButtonField(
                      text: 'With these',
                      height: 40,
                      width: 120,
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 30, 86, 1),
                        side: BorderSide(
                          color: Color.fromRGBO(255, 172, 65, 1),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      textStyle: TextStyle(
                        color: Color.fromRGBO(50, 50, 50, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ButtonField(
                      text: 'Presets Now!!',
                      height: 40,
                      width: 120,
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(35, 41, 49, 1),
                        side: BorderSide(
                          color: Color.fromRGBO(247, 56, 89, 1),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      textStyle: TextStyle(
                        color: Color.fromRGBO(241, 209, 138, 1),
                        fontSize: 14,
                      ),
                    ),
                  ];

                  return Row(
                    spacing: 8.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: presets.map((preset) {
                      return GestureDetector(
                        onTap: () => buttonField.value = preset,
                        child: DynamicWidget(
                          jsonString: preset.toJsonString(),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
            SizedBox(
              height: 400,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  Expanded(
                    flex: 3,
                    child: theme.value != null
                        ? PreviewContainer(
                            code: code.value,
                            json: jsonString.value,
                            theme: theme.value!,
                          )
                        : SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 7,
                    child: FieldSettingContainer(
                      field: buttonField.value,
                      onTextChanged: (text) {
                        final cloned = buttonField.value.clone();
                        cloned.text = text;
                        buttonField.value = cloned;
                      },
                      onTextStyleFieldChanged: (textStyle) {
                        final cloned = buttonField.value.clone();
                        cloned.textStyle = textStyle;
                        buttonField.value = cloned;
                      },
                      onButtonStyleFieldChanged: (buttonStyle) {
                        final cloned = buttonField.value.clone();
                        cloned.buttonStyle = buttonStyle;
                        buttonField.value = cloned;
                      },
                      onWidthChanged: (width) {
                        final cloned = buttonField.value.clone();
                        cloned.width = width;
                        buttonField.value = cloned;
                      },
                      onHeightChanged: (height) {
                        final cloned = buttonField.value.clone();
                        cloned.height = height;
                        buttonField.value = cloned;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              spacing: 8.0,
              children: [
                Expanded(child: Divider()),
                Text(
                  'or Pick from assets',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.normal),
                ),
                Expanded(child: Divider()),
              ],
            ),
            Builder(builder: (context) {
              final presets = [
                ButtonField(
                  text: 'Tap Here',
                  height: 40,
                  width: 120,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(169, 181, 223, 1),
                    side: BorderSide(
                      color: Color.fromRGBO(255, 242, 242, 1),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  textStyle: TextStyle(
                    color: Color.fromRGBO(45, 51, 107, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ButtonField(
                  text: 'Subscribe',
                  height: 60,
                  width: 180,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(220, 215, 201, 1),
                    side: BorderSide(
                      color: Color.fromRGBO(63, 79, 68, 1),
                      width: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  textStyle: TextStyle(
                    color: Color.fromRGBO(162, 123, 92, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                ButtonField(
                  text: 'Order',
                  height: 40,
                  width: 120,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 157, 35, 1),
                    side: BorderSide(
                      color: Color.fromRGBO(193, 70, 0, 1),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textStyle: TextStyle(
                    color: Color.fromRGBO(254, 249, 225, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ButtonField(
                  text: 'Continue',
                  height: 40,
                  width: 120,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: Color.fromRGBO(105, 11, 34, 1),
                      width: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  textStyle: TextStyle(
                    color: Color.fromRGBO(105, 11, 34, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ButtonField(
                  text: 'Login',
                  height: 100,
                  width: 100,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(133, 159, 61, 1),
                    side: BorderSide(
                      color: Color.fromRGBO(246, 252, 223, 1),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  textStyle: TextStyle(
                    color: Color.fromRGBO(49, 81, 30, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ];

              return Wrap(
                spacing: 12.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: presets.map((preset) {
                  return GestureDetector(
                    onTap: () => buttonField.value = preset,
                    child: DynamicWidget(jsonString: preset.toJsonString()),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
