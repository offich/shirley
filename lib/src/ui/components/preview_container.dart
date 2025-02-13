import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shirley/src/ui/components/dynamic_widget.dart';
import 'package:shirley/src/ui/components/shirley_snack_bar.dart';
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

    final copying = useState(false);

    const primaryColor = Color.fromRGBO(228, 23, 73, 1);
    const secondaryColor = Color.fromRGBO(245, 88, 123, 1);
    const fourthlyColor = Color.fromRGBO(255, 245, 145, 1);

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [DynamicWidget(jsonString: json)],
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SelectableText.rich(
                          hightlighter.value.highlight(code),
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
                              copying.value
                                  ? Icons.hourglass_empty
                                  : Icons.copy,
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
                                  showSnackBar(context, 'Copied Failure',
                                      isError: true);
                                }
                              }
                            },
                          ),
                        ),
                      )
                    ],
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
