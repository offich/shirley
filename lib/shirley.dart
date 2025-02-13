import 'package:code_builder/code_builder.dart';
import 'package:devtools_extensions/api.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/common/widget.dart';
import 'package:shirley/src/extension/color.dart';
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

    final backgroundColor = useState<Color>(Color.fromRGBO(131, 217, 119, 1));
    final content = useState('1.Normal Button');

    final buttonTextEditingController =
        useTextEditingController(text: '1.Normal Button');

    useEffect(() {
      afterBuild((_) async {
        await Highlighter.initialize(['dart']);

        theme.value = await HighlighterTheme.loadDarkTheme();
      });

      return;
    }, []);

    useEffect(() {
      final elevatedButton = refer('ElevatedButton').newInstance(
        [],
        {
          'child': refer('Text').newInstance([
            literalString(buttonTextEditingController.text),
          ]),
          'style': refer('ElevatedButton.styleFrom').call([], {
            'backgroundColor': refer('Colors.fromRGBO').call([
              literalNum(backgroundColor.value.redValue),
              literalNum(backgroundColor.value.greenValue),
              literalNum(backgroundColor.value.blueValue),
              literalNum(1)
            ])
          }),
          'onPressed': Method((builder) => builder
            ..lambda = true
            ..body = Code('() {}')).closure,
        },
      );

      final parameter = Parameter(
        (builder) => builder
          ..name = 'context'
          ..type = refer('BuildContext'),
      );

      final methods = [
        Method(
          (builder) => builder
            ..name = 'build'
            ..requiredParameters.add(parameter)
            ..body = Code('return ${elevatedButton.accept(DartEmitter())};')
            ..returns = refer('Widget'),
        ),
      ];

      final shirleyButtonClass = Class((builder) {
        builder
          ..name = 'ShirleyButton'
          ..extend = refer('StatelessWidget')
          ..methods.addAll(methods);
      });

      code.value = '${shirleyButtonClass.accept(DartEmitter.scoped())}';

      jsonString.value = '''
{
  "type": "elevated_button",
  "args": {
    "child": {
      "type": "text",
      "args": {
        "text": "${content.value}"
      }
    },
    "style": {
      "backgroundColor": "${backgroundColor.value.toHex}"
    }
  }
}
''';

      return;
    }, [backgroundColor.value, content.value]);

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
                        backgroundColor: backgroundColor.value,
                        onColorChanged: (color) =>
                            backgroundColor.value = color,
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
