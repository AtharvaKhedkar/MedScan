import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medscan/widgets/specimenTile.dart';

import '../constants.dart';

class Specimen extends StatefulWidget {
  @override
  _SpecimenState createState() => _SpecimenState();
}

class _SpecimenState extends State<Specimen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void specimenToFirestore() {
    final formattedDate = formatter.format(now);
    final formattedTime = now.hour.toString() + ":" + now.minute.toString();

    FirebaseFirestore.instance.collection("Specimens").doc(_scanBarcode).set(
      {
        'sampleName': sample,
        'uid': patientID,
        'date': formattedDate,
        'time': formattedTime,
      },
    );
  }

  var now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  String sample;
  String exceptionMsg = '';
  String _scanBarcode;

  Future<void> scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(
        () => _scanBarcode = barcode,
      );
      specimenToFirestore();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          exceptionMsg = 'The user did not grant the camera permission!';
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Specimens")
              .where('uid', isEqualTo: patientID)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var specimenData = snapshot.data.docs[index].data();
                      return SpecimenTile(
                        specimenData: specimenData,
                      );
                    },
                    itemCount: snapshot.data.docs.length,
                  )
                : SizedBox.shrink();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo[200],
        label: Text('Add Specimen'),
        icon: Icon(Icons.add),
        tooltip: 'Add Specimen',
        onPressed: () {
          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: Text("Add Specimen"),
            content: Container(
              height: 200,
              child: TextField(
                onChanged: (value) {
                  sample = value;
                },
                decoration: InputDecoration(hintText: "Specimen Name"),
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              MaterialButton(
                onPressed: () {
                  scanBarcode();
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
      ),
    );
  }
}
