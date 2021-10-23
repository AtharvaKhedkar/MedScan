import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medscan/constants.dart';
import 'package:medscan/widgets/item_tag.dart';
import 'package:medscan/widgets/profile_item.dart';

class PatientProfile extends StatefulWidget {
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  String name;
  List allergies;
  String age;
  String bloodGrp;
  String gender;
  String height;
  String weight;
  List phc;

  bool isLoading;

  void getData() async {
    await FirebaseFirestore.instance
        .collection('Patients')
        .doc(patientID)
        .get()
        .then(
      (value) {
        setState(() {
          allergies = value.data()['Allergies'];
          name = value.data()['Full_Name'];
          bloodGrp = value.data()['Blood_Group'];
          age = value.data()['Age'].toString();
          gender = value.data()['Gender'];
          height = value.data()['Height'].toString();
          weight = value.data()['Weight'].toString();
          phc = value.data()['PHC'];

          isLoading = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;

    getData();
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
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: Text(
                            "Patient Profile",
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      // Name Row
                      ProfileItem(
                        type: "Name",
                        value: name,
                      ),
                      ProfileItem(
                        type: "Age",
                        value: age,
                        suffix: 'yr',
                      ),
                      ProfileItem(
                        type: "Gender",
                        value: gender,
                      ),
                      ProfileItem(
                        type: "Weight",
                        value: weight,
                        suffix: 'kg',
                      ),
                      ProfileItem(
                        type: "Height",
                        value: height,
                        suffix: 'cm',
                      ),
                      ProfileItem(
                        type: "Blood Group",
                        value: bloodGrp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Allergies:",
                            style: GoogleFonts.montserrat(
                              fontSize: 26,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: GridView.builder(
                          //scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: allergies.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      allergies.length > 0 ? 105 : 10,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 2.5),
                          itemBuilder: (BuildContext context, int index) {
                            return ItemTag(
                              allergy: allergies[index],
                            );
                          },
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Pre Health Conditions:",
                            style: GoogleFonts.montserrat(
                              fontSize: 26,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: GridView.builder(
                          //scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: phc.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: phc.length > 0 ? 105 : 10,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 2.5),
                          itemBuilder: (BuildContext context, int index) {
                            return ItemTag(
                              allergy: phc[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
