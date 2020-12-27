import 'package:flutter/material.dart';

class ItemTag extends StatelessWidget {
  final String allergy;

  const ItemTag({Key key, this.allergy}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        //border: Border.all(style: BorderStyle.solid, color: Colors.green),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(
                left: 12,
              ),
              child: Text(
                allergy,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
