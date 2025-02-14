import 'package:code_builder/code_builder.dart';
import 'package:flutter/material.dart';
import 'package:shirley/src/extension/color.dart';

class ButtonField {
  String? text;
  TextStyle? textStyle;
  ButtonStyle? buttonStyle;

  ButtonField({this.text, this.textStyle, this.buttonStyle});

  Color? get backgroundColor => buttonStyle?.backgroundColor?.resolve({});

  ButtonField clone() {
    return ButtonField()
      ..buttonStyle = buttonStyle
      ..text = text
      ..textStyle = textStyle;
  }

  TextStyle? cloneTextStyle() {
    return TextStyle(fontSize: textStyle?.fontSize);
  }

  String toCode() {
    final elevatedButton = refer('ElevatedButton').newInstance(
      [],
      {
        'child': refer('Text').newInstance([
          literalString(text ?? ''),
        ], {
          'style': refer('TextStyle').call([], {
            'fontSize': literalNum(textStyle?.fontSize ?? 0),
          }),
        }),
        'style': refer('ElevatedButton.styleFrom').call([], {
          'backgroundColor': refer('Colors.fromRGBO').call([
            literalNum(backgroundColor?.redValue ?? 0),
            literalNum(backgroundColor?.greenValue ?? 0),
            literalNum(backgroundColor?.blueValue ?? 0),
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

    return '${shirleyButtonClass.accept(DartEmitter.scoped())}';
  }

  String toJsonString() {
    return '''
{
  "type": "elevated_button",
  "args": {
    "child": {
      "type": "text",
      "args": {
        "text": "$text",
        "style": {
          "fontSize": "${textStyle?.fontSize}"
        }
      }
    },
    "style": {
      "backgroundColor": "${buttonStyle?.backgroundColor?.resolve({})?.toHex}"
    }
  }
}''';
  }
}
