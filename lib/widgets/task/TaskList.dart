import 'package:flutter/material.dart';

import 'TaskItem.dart';

class TaskList extends StatelessWidget {
  final visitData;
  TaskList(this.visitData);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          child: ListView.builder(
            itemCount: visitData['Medication'].length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TaskItem(
                    title: "${visitData['Medication'][index]['name']}"),
              );
            },
          ),
        ),
        flex: 5);
  }
}
