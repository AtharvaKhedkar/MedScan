import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medscan/Screens/barcodeScanScreen.dart';
import 'package:medscan/authentication_screen/verify_login.dart';

import 'authservice.dart';
import 'numeric_pad.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNo = "";
  String verificationId;
  bool isLoading = false;

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
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              textTheme: Theme.of(context).textTheme,
            ),
            body: SafeArea(
                child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 130,
                          child: Image.asset('assets/holding-phone.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 64),
                          child: Text(
                            "You'll receive a 6 digit code to verify your phone number.",
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF818181),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 8.2,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 230,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Enter your phone with country code",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "+" + phoneNo,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            isLoading = true;
                            verifyPhone('+' + phoneNo);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Send OTP",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                NumericPad(
                  onNumberSelected: (value) {
                    setState(() {
                      if (value != -1) {
                        if (phoneNo.length < 15) {
                          phoneNo = phoneNo + value.toString();
                        }
                      } else {
                        phoneNo = phoneNo.substring(0, phoneNo.length - 1);
                      }
                    });
                  },
                ),
              ],
            )),
          );
  }

  Future<void> verifyPhone(phoneNumber) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
      isLoading = false;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => BarcodeScanScreen()));
    };
    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      isLoading = false;
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      verificationId = verId;
      isLoading = false;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyLoginScreen(
                  phoneNumber: '+' + phoneNo,
                  verificationId: verificationId,
                )),
      );
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      isLoading = false;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+' + phoneNumber,
        timeout: const Duration(seconds: 20),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
