import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medscan/Screens/visitPage.dart';

import '../constants.dart';

class DailyVisits extends StatelessWidget {
  DailyVisits({@required this.visitDate});
  final visitDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Patients")
            .doc(patientID)
            .collection("Daily Visit")
            .doc(visitDate)
            .snapshots(),
        builder: (context, snapshot) {
          DocumentSnapshot visits = snapshot.data;
          if (snapshot.data == null) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: visits.data().length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    print(visits.data()["Visit ${index + 1}"]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitScreen(
                          visitData: visits.data()["Visit ${index + 1}"],
                          visitDate: visitDate,
                          visitNumber: index + 1,
                        ),
                      ),
                    );
                  },
                  trailing: Icon(Icons.chevron_right),
                  tileColor: Colors.indigo[200],
                  title: Text("Visit ${index + 1}"),
                  subtitle: Row(
                    children: <Widget>[
                      Text("Pulse Rate" +
                          ":   " +
                          visits
                              .data()["Visit ${index + 1}"]["Pulse"]
                              .toString()),
                      Spacer(),
                      Text("Body Temperature" +
                          ":   " +
                          visits
                              .data()["Visit ${index + 1}"]["Temp"]
                              .toString()),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
