import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medscan/Screens/barcodeScanScreen.dart';
import 'package:medscan/Screens/dailyVisit.dart';
import 'package:medscan/Screens/patientProfile.dart';
import 'package:medscan/Screens/specimen_screen.dart';
import 'package:medscan/authentication_screen/authservice.dart';
import 'package:medscan/authentication_screen/login_screen.dart';
import 'package:medscan/theme/extention.dart';
import 'package:medscan/theme/light_color.dart';
import 'package:medscan/theme/text_styles.dart';
import 'package:medscan/theme/theme.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 1;

  List<Widget> _widgetOptions = <Widget>[
    PatientProfile(),
    Home(),
    Specimen(),
  ];

  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[200],
        actions: <Widget>[
          FlatButton.icon(
            label: Text(
              'Next Patient',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.queue_play_next,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BarcodeScanScreen()),
                ModalRoute.withName('/'),
              );
            },
          ),
          FlatButton.icon(
            label: Text(
              'Log Out',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()),
                ModalRoute.withName('/'),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_page),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        items: <Widget>[
          Icon(Icons.portrait, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.medical_services, size: 30),
        ],
        onTap: (index) {
          setState(
            () {
              _page = index;
            },
          );
        },
        animationDuration: Duration(milliseconds: 200),
        color: Colors.indigo[200],
        backgroundColor: Colors.white,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final picker = ImagePicker();
  String uploadedFileUrl;
  String textNote;
  var documentLenght = FirebaseFirestore.instance
      .collection("Patients")
      .doc(patientID)
      .collection("Daily Visit")
      .doc();

  uploadTextNote() {
    FirebaseFirestore.instance.collection('Patients').doc(patientID).update(
      {
        "textNote": FieldValue.arrayUnion([textNote]),
      },
    );
  }

  Widget _dailyVisits() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Daily Visits", style: TextStyles.title.bold),
              Text(
                "",
                style: TextStyles.titleNormal
                    .copyWith(color: Theme.of(context).primaryColor),
              ).p(8).ripple(() {})
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Patients")
                  .doc(patientID)
                  .collection("Daily Visit")
                  .snapshots(),
              builder: (context, snapshot) {
                QuerySnapshot dailyVisits = snapshot.data;
                if (snapshot.data == null) return CircularProgressIndicator();
                return ListView.builder(
                    itemCount: dailyVisits.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DailyVisits(
                                  visitDate:
                                      dailyVisits.docs[index].id.toString(),
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                height: 100,
                                width: 200,
                                color: LightColor.green,
                                child: Center(
                                    child: Text(dailyVisits.docs[index].id))),
                          ),
                        ),
                      );
                    });
              }),
        ),
        SizedBox(
          height: 20,
        ),
        ListTile(
          tileColor: Colors.redAccent,
          title: Text("Add Note"),
          trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                AlertDialog alert = AlertDialog(
                  title: Text("Add Note"),
                  content: Container(
                    height: 100,
                    width: 200,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            textNote = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    GestureDetector(
                        onTap: () {
                          uploadTextNote().then(Navigator.pop(context));
                        },
                        child: Text("Add Note")),
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
                print("Text");
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.indigo[200],
              height: 250,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Patients")
                    .doc(patientID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return CircularProgressIndicator();
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data['textNote'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Patients")
                              .doc(patientID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            DocumentSnapshot notesText = snapshot.data;
                            if (snapshot.data == null)
                              return CircularProgressIndicator();
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: ListTile(
                                trailing: GestureDetector(
                                  onTap: () {
                                    print("TAPPED");
                                    FirebaseFirestore.instance
                                        .collection("Patients")
                                        .doc(patientID)
                                        .update(
                                      {
                                        "textNote": FieldValue.arrayRemove(
                                          [notesText.data()['textNote'][index]],
                                        ),
                                      },
                                    );
                                  },
                                  child: Icon(Icons.delete),
                                ),
                                tileColor: Colors.white30,
                                title:
                                    Text(notesText.data()['textNote'][index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _dailyVisits(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
