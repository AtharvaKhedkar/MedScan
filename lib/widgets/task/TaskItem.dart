import 'package:flutter/material.dart';

class TaskItem extends StatefulWidget {
  TaskItem({this.title});
  final String title;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool completed = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        completed = !completed;
        setState(() {});
      },
      leading: Image(
          image: completed
              ? AssetImage('assets/icons/completed.png')
              : AssetImage('assets/icons/non-completed.png')),
      title: Text(
        widget.title,
        style: TextStyle(
            fontSize: 16.0,
            decoration:
                completed ? TextDecoration.lineThrough : TextDecoration.none,
            color: completed ? Colors.grey[300] : Colors.black,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
