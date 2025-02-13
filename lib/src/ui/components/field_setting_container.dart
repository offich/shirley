import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FieldSettingContainer extends HookWidget {
  const FieldSettingContainer({super.key, required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final buttonTextEditingController =
        useTextEditingController(text: 'content');

    final content = useState('');

    return DefaultTabController(
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
                      color: backgroundColor,
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
                        controller: buttonTextEditingController,
                        onChanged: (value) {
                          content.value = value;
                        },
                      ),
                    )
                  ])
                ]),
                Column(children: [SizedBox.shrink()]),
                Column(children: [SizedBox.shrink()]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
