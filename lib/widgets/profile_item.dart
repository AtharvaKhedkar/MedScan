import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileItem extends StatelessWidget {
  final String type;
  final String value;
  final String suffix;
  const ProfileItem({Key key, this.type, this.value, this.suffix = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          Text(
            "$type:",
            style: GoogleFonts.montserrat(
              fontSize: 26,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            value + " " + suffix,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              color: Colors.black54,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
