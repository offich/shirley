import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/dynamic_widget.dart';
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

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabAlignment: TabAlignment.fill,
            indicatorSize: TabBarIndicatorSize.tab,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [DynamicWidget(jsonString: json)],
                ),
                SelectableText.rich(hightlighter.value.highlight(code)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
