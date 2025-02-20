import 'package:devtools_extensions/api.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/common/widget.dart';
import 'package:shirley/src/model/button_field.dart';
import 'package:shirley/src/ui/components/field_setting_container.dart';
import 'package:shirley/src/ui/components/preset_button.dart';
import 'package:shirley/src/ui/components/preview_container.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class Shirley extends HookWidget {
  const Shirley({super.key});

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
        backgroundColor: Color.fromRGBO(131, 217, 119, 1),
        side: BorderSide(color: Color.fromRGBO(11, 127, 90, 1), width: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ));

    useEffect(() {
      afterBuild((_) async {
        await Highlighter.initialize(['dart']);

        theme.value = await HighlighterTheme.loadDarkTheme();
      });

      return;
    }, []);

    useEffect(() {
      code.value = buttonField.value.toCode();
      jsonString.value = buttonField.value.toJsonString();

      return;
    }, [buttonField.value]);

    return DevToolsExtension(
      eventHandlers: {
        DevToolsExtensionEventType.themeUpdate: (event) async {
          if (event.data == null) return;

          final newTheme = event.data!['theme'];
          theme.value = newTheme == 'dark'
              ? await HighlighterTheme.loadDarkTheme()
              : await HighlighterTheme.loadLightTheme();
        },
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 24.0,
            children: [
              SizedBox(
                height: 80,
                child: Column(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Shirley'),
                    Text('Button Generator'),
                    Builder(builder: (context) {
                      final presets = List<Widget>.filled(3, PresetButton());
                      return Row(
                        spacing: 16.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: presets,
                      );
                    }),
                  ],
                ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('or Pick from Presets'),
                ],
              ),
              Builder(builder: (context) {
                final presets = List<Widget>.filled(48, PresetButton());
                return Wrap(spacing: 8.0, runSpacing: 16.0, children: presets);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
