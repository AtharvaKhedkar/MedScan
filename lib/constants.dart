import 'package:flutter/material.dart';

String patientID;

showAlertDialog(BuildContext context,
    {Text buttontext,
    Text titletext,
    Function onbuttonPressed,
    Widget content,
    bool barrierDismisable = false}) {
  // set up the button
  Widget okButton = FlatButton(
    child: buttontext,
    onPressed: onbuttonPressed,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: titletext,
    content: content,
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: barrierDismisable,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



var kBackgroundColor = Color(0xffF9F9F9);
var kWhiteColor = Color(0xffffffff);
var kOrangeColor = Color(0xffEF716B);
var kBlueColor = Color(0xff4B7FFB);
var kYellowColor = Color(0xffFFB167);
var kTitleTextColor = Color(0xff1E1C61);
var kSearchBackgroundColor = Color(0xffF2F2F2);
var kSearchTextColor = Color(0xffC0C0C0);
var kCategoryTextColor = Color(0xff292685);