import 'package:code_builder/code_builder.dart';
import 'package:flutter/material.dart';
import 'package:shirley/src/extension/color.dart';

class ButtonField {
  String? text;
  TextStyle? textStyle;
  ButtonStyle? buttonStyle;

  ButtonField({this.text, this.textStyle, this.buttonStyle});

  Color? get backgroundColor => buttonStyle?.backgroundColor?.resolve({});
  Color? get borderColor => buttonStyle?.side?.resolve({})?.color;
  double? get borderRadius {
    final shape = buttonStyle?.shape?.resolve({});

    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius.resolve(null).topRight.x;
    }

    return 0.0;
  }

  EdgeInsets? get padding {
    return buttonStyle?.padding?.resolve({})?.resolve(null);
  }

  ButtonField clone() {
    return ButtonField()
      ..buttonStyle = buttonStyle
      ..text = text
      ..textStyle = textStyle;
  }

  String toCode() {
    final sameAllPadding = [padding?.right, padding?.left, padding?.bottom]
        .every((e) => e != null && e == padding?.top);

    final elevatedButton = refer('ElevatedButton').newInstance(
      [],
      {
        'child': refer('Text').newInstance([
          literalString(text ?? ''),
        ], {
          'style': refer('TextStyle').call([], {
            'fontSize': literalNum(textStyle?.fontSize ?? 0),
            'color': refer('Color.fromRGBO').call([
              literalNum(textStyle?.color?.redValue ?? 0),
              literalNum(textStyle?.color?.greenValue ?? 0),
              literalNum(textStyle?.color?.blueValue ?? 0),
              literalNum(1)
            ]),
          }),
        }),
        'style': refer('ElevatedButton.styleFrom').call([], {
          'padding': sameAllPadding
              ? refer('EdgeInsets.all').call([literalNum(padding?.left ?? 0)])
              : refer('EdgeInsets.fromLTRB').call(
                  [
                    literalNum(padding?.left ?? 0),
                    literalNum(padding?.top ?? 0),
                    literalNum(padding?.right ?? 0),
                    literalNum(padding?.bottom ?? 0),
                  ],
                ),
          'backgroundColor': refer('Colors.fromRGBO').call([
            literalNum(backgroundColor?.redValue ?? 0),
            literalNum(backgroundColor?.greenValue ?? 0),
            literalNum(backgroundColor?.blueValue ?? 0),
            literalNum(1)
          ]),
          'side': refer('BorderSide').call([], {
            'width': literalNum(buttonStyle?.side?.resolve({})?.width ?? 0),
            'color': refer('Color.fromRGBO').call([
              literalNum(borderColor?.redValue ?? 0),
              literalNum(borderColor?.greenValue ?? 0),
              literalNum(borderColor?.blueValue ?? 0),
              literalNum(1)
            ]),
          }),
          'shape': refer('RoundedRectangleBorder').call([], {
            'borderRadius': refer('BorderRadius.circular').call(
              [literalNum(borderRadius?.toInt() ?? 0)],
            )
          })
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
          "fontSize": "${textStyle?.fontSize}",
          "color": "${textStyle?.color?.toHex}"
        }
      }
    },
    "style": {
      "padding": "${padding?.top}",
      "backgroundColor": "${buttonStyle?.backgroundColor?.resolve({})?.toHex}",
      "shape": {
        "type": "rounded",
        "borderRadius": {
          "radius": "$borderRadius",
          "type": "all"
        }
      },
      "side": {
        "color": "${borderColor?.toHex}",
        "width": "${buttonStyle?.side?.resolve({})?.width}"
      }
    }
  }
}''';
  }
}
