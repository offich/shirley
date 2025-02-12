import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class DynamicWidget extends HookWidget {
  const DynamicWidget({required this.jsonString, super.key});

  final String jsonString;

  @override
  Widget build(BuildContext context) {
    final jsonWidgetData = useState<JsonWidgetData?>(null);

    useEffect(() {
      final widgetJson = jsonDecode(jsonString);

      jsonWidgetData.value = JsonWidgetData.fromDynamic(
        widgetJson,
        registry: JsonWidgetRegistry.instance,
      );

      return;
    }, [jsonString]);

    return jsonWidgetData.value != null
        ? jsonWidgetData.value!.build(context: context)
        : const SizedBox.shrink();
  }
}
