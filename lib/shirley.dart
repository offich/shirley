import 'package:code_builder/code_builder.dart';
import 'package:devtools_extensions/api.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/dynamic_widget.dart';
import 'package:shirley/src/ui/components/preset_button.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:dart_style/dart_style.dart';

extension ColorExtension on Color {
  int get redValue {
    return (r * 255).round();
  }

  int get greenValue {
    return (g * 255).round();
  }

  int get blueValue {
    return (b * 255).round();
  }

  int get alphaValue {
    return (a * 255).round();
  }

  String get toHex {
    return '#'
        '${alphaValue.toRadixString(16).padLeft(2, '0')}'
        '${redValue.toRadixString(16).padLeft(2, '0')}'
        '${greenValue.toRadixString(16).padLeft(2, '0')}'
        '${blueValue.toRadixString(16).padLeft(2, '0')}';
  }
}

class Shirley extends HookWidget {
  const Shirley({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = useState<HighlighterTheme?>(null);
    final code = useState('');
    final highlighter = useState<Highlighter?>(null);
    final highlightedCode = useState<TextSpan>(TextSpan());
    final jsonString = useState('');

    final backgroundColor = useState<Color>(Color.fromRGBO(131, 217, 119, 1));
    final content = useState('');

    final buttonTextEditingController =
        useTextEditingController(text: '1.Normal Button');

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Highlighter.initialize(['dart']);

        theme.value = await HighlighterTheme.loadDarkTheme();

        highlighter.value = Highlighter(
          language: 'dart',
          theme: theme.value!,
        );

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

        final formattedCode = DartFormatter(
          languageVersion: DartFormatter.latestLanguageVersion,
          indent: 2,
        ).format('${shirleyButtonClass.accept(DartEmitter.scoped())}');

        code.value = formattedCode;

        highlightedCode.value = highlighter.value!.highlight(formattedCode);

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
      });

      return;
    }, [backgroundColor.value, content.value]);

    useEffect(() {
      if (theme.value == null) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        highlighter.value = Highlighter(
          language: 'dart',
          theme: theme.value!,
        );

        highlightedCode.value = highlighter.value!.highlight(code.value);
      });

      return;
    }, [theme.value]);

    if (highlighter.value == null) {
      return SizedBox.shrink();
    }

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
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabAlignment: TabAlignment.fill,
                              tabs: [
                                Tab(child: Text('Preview')),
                                Tab(child: Text('Code')),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DynamicWidget(
                                          jsonString: jsonString.value)
                                    ],
                                  ),
                                  SelectableText.rich(highlightedCode.value),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: DefaultTabController(
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
                                  Column(children: [
                                    Row(children: [
                                      Container(
                                        color: backgroundColor.value,
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
                                          controller:
                                              buttonTextEditingController,
                                          onChanged: (value) {
                                            content.value = value;
                                          },
                                        ),
                                      )
                                    ])
                                  ]),
                                  Text.rich(highlightedCode.value),
                                  Column(children: [SizedBox.shrink()]),
                                ],
                              ),
                            ),
                          ],
                        ),
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
              ColorPicker(
                pickerColor: backgroundColor.value,
                onColorChanged: (newColor) {
                  backgroundColor.value = newColor;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
