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
