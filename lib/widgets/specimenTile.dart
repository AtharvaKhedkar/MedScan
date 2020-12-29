import 'package:flutter/material.dart';

class SpecimenTile extends StatelessWidget {
  SpecimenTile({Key key, this.specimenData}) : super(key: key);
  final dynamic specimenData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black54),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white),
              ),
            ),
            child: Icon(Icons.medical_services, color: Colors.white),
          ),
          title: Text(
            specimenData['sampleName'],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Column(
            children: [
              Row(
                children: <Widget>[
                  Icon(
                    Icons.date_range,
                    color: Colors.amberAccent,
                    size: 18,
                  ),
                  Text("Date: ${specimenData['date']}",
                      style: TextStyle(color: Colors.white))
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.lock_clock,
                    color: Colors.amberAccent,
                    size: 18,
                  ),
                  Text("Time: ${specimenData['time']}",
                      style: TextStyle(color: Colors.white))
                ],
              ),
            ],
          ),
          trailing: Icon(Icons.notes, color: Colors.white, size: 30.0),
        ),
      ),
    );
  }
}
