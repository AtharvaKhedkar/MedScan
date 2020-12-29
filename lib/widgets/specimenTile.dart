import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecimenTile extends StatelessWidget {
  SpecimenTile({Key key, this.specimenData}) : super(key: key);
  final dynamic specimenData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Card(
        elevation: 5,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                specimenData['sampleName'],
                style:
                    GoogleFonts.montserrat(fontSize: 16, color: Colors.black54),
              ),
              Text(
                "Date: ${specimenData['date']}",
                style:
                    GoogleFonts.montserrat(fontSize: 14, color: Colors.black54),
              ),
              Text(
                "Time: ${specimenData['time']}",
                style:
                    GoogleFonts.montserrat(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
