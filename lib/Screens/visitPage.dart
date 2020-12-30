import 'package:flutter/material.dart';
import 'package:medscan/widgets/custom_clippers/index.dart';
import 'package:medscan/widgets/task/TaskList.dart';

class VisitScreen extends StatelessWidget {
  final visitData;
  final visitDate;
  final visitNumber;
  VisitScreen({this.visitData, this.visitDate, this.visitNumber});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WhiteTopClipper(),
            child: Container(
              color: Colors.grey,
            ),
          ),
          ClipPath(
            clipper: GreyTopClipper(),
            child: Container(
              color: Colors.blueAccent,
            ),
          ),
          ClipPath(
            clipper: BlueTopClipper(),
            child: Container(
              color: Colors.white24,
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Spacer(),
                Text(
                  'Visit $visitNumber',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(
                  height: 300,
                ),
                TaskList(visitData),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
