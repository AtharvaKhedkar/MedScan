import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medscan/authentication_screen/authservice.dart';
import 'package:medscan/authentication_screen/login_screen.dart';
import 'package:medscan/constants.dart';

import 'homescreen.dart';

class BarcodeScanScreen extends StatefulWidget {
  @override
  _BarcodeScanScreenState createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  String _scanBarcode;
  bool isLoading = false;
  String exceptionMsg = '';

  Future<void> scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(
        () => _scanBarcode = barcode,
      );
      isLoading = true;
      userExists();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(
          () {
            exceptionMsg = 'The user did not grant the camera permission!';
          },
        );
      } else {
        setState(() => exceptionMsg = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => exceptionMsg =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => exceptionMsg = 'Unknown error: $e');
    }
  }

  void userExists() {
    FirebaseFirestore.instance
        .collection('Patients')
        .doc(_scanBarcode)
        .get()
        .then(
      (DocumentSnapshot documentSnapshot) {
        isLoading = false;
        if (documentSnapshot.exists) {
          setState(() {
            patientID = _scanBarcode;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          showAlertDialog(context, buttontext: Text('Ok'), onbuttonPressed: () {
            Navigator.pop(context);
          },
              titletext: Text("Patient Does Not exist"),
              content: Text("Make sure the Patient ID is correct"));
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child: SpinKitWave(
                type: SpinKitWaveType.start,
                color: Colors.black38,
                size: 40.0,
              ),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Welcome Doctor'),
              actions: <Widget>[
                TextButton.icon(
                  label: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    AuthService().signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ],
            ),
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/scan.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 17,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 8,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Scan Barcode Below',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: kTitleTextColor,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                scanBarcode();
                              },
                              color: kOrangeColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Scan Barcode',
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'OR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black38,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) {
                                _scanBarcode = value;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Barcode ID',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              onPressed: () {
                                print(_scanBarcode);
                                isLoading = true;
                                userExists();
                              },
                              color: kOrangeColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Go',
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
