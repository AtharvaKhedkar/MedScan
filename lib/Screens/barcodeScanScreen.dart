import 'dart:io';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medscan/authentication_screen/authservice.dart';
import 'package:medscan/authentication_screen/login_screen.dart';
import 'package:medscan/constants.dart';

import 'homescreen.dart';

class BarcodeScanScreen extends StatefulWidget {
  @override
  _BarcodeScanScreenState createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  File pickedImage;
  String _scanBarcode = '';

  Future<void> scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => _scanBarcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _scanBarcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => _scanBarcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => _scanBarcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => _scanBarcode = 'Unknown error: $e');
    }
  }

  void userExists() {
    FirebaseFirestore.instance
        .collection('Patients')
        .doc(_scanBarcode)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          patientID = _scanBarcode;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        showAlertDialog(context, buttontext: Text('Ok'), onbuttonPressed: () {
          Navigator.pop(context);
        },
            titletext: Text("Patient Does Not exist"),
            content: Text("Make sure the Patient ID is correct"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Doctor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Center(
            child: FlatButton.icon(
              icon: Icon(
                Icons.photo_camera,
                size: 100,
              ),
              label: Text(''),
              onPressed: () {
                scanBarcode();
              },
            ),
          ),
          _scanBarcode == ''
              ? Text('Patient ID : ')
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Patient ID : $_scanBarcode',
                      ),
                    ),
                    RaisedButton(
                      color: Colors.blueAccent,
                      onPressed: () {
                        userExists();
                      },
                      child: Text('Go >'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
