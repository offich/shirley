import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/shirley_snack_bar.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class PreviewCodeView extends HookWidget {
  const PreviewCodeView({
    super.key,
    required this.code,
    required this.theme,
  });

  final String code;
  final HighlighterTheme theme;

  @override
  Widget build(BuildContext context) {
    final hightlighter = useState(Highlighter(language: 'dart', theme: theme));

    useEffect(() {
      hightlighter.value = Highlighter(language: 'dart', theme: theme);

      return;
    }, [theme]);

    final formattedCode = useState('');

    useEffect(() {
      formattedCode.value = DartFormatter(
        languageVersion: DartFormatter.latestLanguageVersion,
        indent: 2,
      ).format(code);

      return;
    }, [code]);

    final copying = useState(false);

    const secondaryColor = Color.fromRGBO(245, 88, 123, 1);
    const fourthlyColor = Color.fromRGBO(255, 245, 145, 1);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SelectableText.rich(
            hightlighter.value.highlight(formattedCode.value),
            style: TextStyle(fontSize: 14),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: SizedBox(
            width: 28,
            height: 28,
            child: IconButton(
              style: IconButton.styleFrom(
                foregroundColor: fourthlyColor,
                backgroundColor: secondaryColor,
              ),
              padding: EdgeInsets.all(0.0),
              icon: Icon(
                copying.value ? Icons.hourglass_empty : Icons.copy,
                size: 20,
              ),
              onPressed: () async {
                copying.value = true;

                try {
                  final data = ClipboardData(text: code);
                  await Clipboard.setData(data);

                  copying.value = false;

                  if (context.mounted) {
                    showSnackBar(context, 'Copied Text!!');
                  }
                } catch (e) {
                  copying.value = false;

                  if (context.mounted) {
                    showSnackBar(context, 'Copied Failure', isError: true);
                  }
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
