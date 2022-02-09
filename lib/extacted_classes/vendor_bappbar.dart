

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/vendor/upcoming_bookings.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/work/example.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';

class VendorBottomNavBar extends StatefulWidget {
  @override
  _VendorBottomNavBarState createState() => _VendorBottomNavBarState();
}

class _VendorBottomNavBarState extends State<VendorBottomNavBar> {
  var currentDate =  DateTime.now();

   StreamSubscription<LocationData>? locationSubscription;
  bool status = Variables.status;
late  Timer _timer;
  static Geoflutterfire geo = Geoflutterfire();
  Location location = new Location();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateVendorCount();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(locationSubscription != null){
       locationSubscription!.cancel();

    }
    if(_timer != null){
      _timer.cancel();

    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
      child: VariablesOne.offline?Container(
        height: 56.h,
      ):Container(

          height: 56.h,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

   IconButton(icon: Icon(Icons.message), onPressed: (){
     setState(() {
       VariablesOne.isUpcoming = true;
     });
     Navigator.push(context, PageTransition(
         type: PageTransitionType.scale,
         alignment: Alignment.bottomCenter,
         child: UpcomingBookings()));


   }),



              CustomSwitch(
                activeColor: kGreenColor,
                value: status,
                onChanged: (value) async {

                  setState(() {
                    status = value;
                    Variables.status = value;
                  });

                  if(status == false){
                    print('ffffffff');

                    if(locationSubscription != null){
                      locationSubscription!.cancel();
                    }
                    if(_timer != null){
                      _timer.cancel();

                    }
                    FirebaseFirestore.instance
                        .collectionGroup('companyVendors')
                        .where('vId', isEqualTo: Variables.userUid)
                        .get().then((value) {
                      value.docs.forEach((result) {
                        result.reference.update({
                          'ol': false,

                        });
                      });
                    });

                    FirebaseFirestore.instance
                        .collection("vendorCount")
                        .doc(Variables.userUid).set({
                      'ol': false,
                      'tm': DateFormat('h:mm\na').format(currentDate),
                    },SetOptions(merge: true));



                    //Navigator.pop(context);
                  /*  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreenSecond(),
                      ),
                          (route) => false,
                    );*/

                  }else{
                    print('tttttttt');
                    FirebaseFirestore.instance
                        .collectionGroup('companyVendors')
                        .where('vId', isEqualTo: Variables.userUid)
                        .get().then((value) {
                      value.docs.forEach((result) {
                        result.reference.update({
                          'ol': true,

                        });
                      });
                    });


                    FirebaseFirestore.instance
                        .collection("vendorCount")
                        .doc(Variables.userUid).set({
                      'ol': true,
                      'tm': DateFormat('h:mm\na').format(currentDate),
                    },SetOptions(merge: true));
                  }
                },
              ),

              Badge(
                badgeContent: Text(Variables.missedCall.toString()),
                child: Icon(Icons.call),
                  toAnimate: true,
                badgeColor: kRedColor,
                shape: BadgeShape.circle,
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,

              )


            ],
          ),

        ),

    );

  }

  Future<void> updateVendorCount() async {
    late LocationData currentLat;


    /*start listening for location change*/
      locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
        currentLat = currentLocation;
        print(currentLat);

        /*periodically update the vendors location in database*/


      });
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        GeoFirePoint point = geo.point(latitude: currentLat.latitude!.toDouble(), longitude: currentLat.longitude!.toDouble());

        try {
          FirebaseFirestore.instance
              .collectionGroup('companyVendors')
              .where('vId', isEqualTo: Variables.userUid)
              .get().then((value) {
            value.docs.forEach((result) {
              result.reference.update({
                'log': currentLat.longitude,
                'lat': currentLat.latitude,
                'vPos': point.data,
              });
            });
          });
        } catch (e) {
          print('this is e ${e.toString()}');
        }
      });
  }


}
