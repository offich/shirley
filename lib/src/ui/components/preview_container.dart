import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/preview/preview_code_view.dart';
import 'package:shirley/src/ui/components/preview/preview_widget_view.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class PreviewContainer extends HookWidget {
  const PreviewContainer({
    super.key,
    required this.code,
    required this.json,
    required this.theme,
  });

  final String code;
  final String json;
  final HighlighterTheme theme;

  @override
  Widget build(BuildContext context) {
    final hightlighter = useState(Highlighter(language: 'dart', theme: theme));

    useEffect(() {
      hightlighter.value = Highlighter(language: 'dart', theme: theme);

      return;
    }, [theme]);

    const primaryColor = Color.fromRGBO(228, 23, 73, 1);

    return DefaultTabController(
      length: 2,
      child: Column(
        spacing: 24.0,
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
              Tab(child: Text('Preview')),
              Tab(child: Text('Code')),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PreviewWidgetView(json: json),
                  PreviewCodeView(code: code, theme: theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
