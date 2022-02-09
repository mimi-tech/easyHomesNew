

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/work/constructors/change_prize.dart';
import 'package:easy_homes/work/constructors/verify_construct.dart';
import 'package:easy_homes/work/example.dart';
import 'package:easy_homes/work/stations/sales_details.dart';
import 'package:easy_homes/work/stations/view_bookings.dart';
import 'package:easy_homes/work/stations/view_upcoming.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';

class StationsBottomNavBar extends StatefulWidget {
  @override
  _StationsBottomNavBarState createState() => _StationsBottomNavBarState();
}

class _StationsBottomNavBarState extends State<StationsBottomNavBar> {
  var currentDate =  DateTime.now();

bool status = true;

bool checkTrue = false;

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

              IconButton(icon: Icon(
                Icons.money,color: kBlackColor,
              ), onPressed: (){
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.bottomCenter,
                        child: SalesDetails()));
              }),


              IconButton(icon: Icon(
                Icons.schedule,color: kBlackColor,
              ), onPressed: (){
                Platform.isIOS ?
                /*show ios bottom modal sheet*/
                showCupertinoModalPopup(

                    context: context, builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    actions: <Widget>[
                      ViewUpcoming()
                    ],
                  );
                })

                    : showModalBottomSheet(
                    isDismissible: false,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => ViewUpcoming()
                );
              }),

              CustomSwitch(
                activeColor: kGreenColor,
                value: status,
                onChanged: (value) async {

                  setState(() {

                    status = value;
                    Variables.status = status;
                  });

                  if(status == false){

                    /*get the location*/
                    FirebaseFirestore.instance.collection('AllBusiness').doc(Variables.currentUser[0]['ca']).update({
                          'ol':false,

                        });
                  }else{

                    FirebaseFirestore.instance.collection('AllBusiness').doc(Variables.currentUser[0]['ca']).update({
                      'ol':true,

                    });


                  }

                }
              ),




              Badge(
                badgeContent:TextWidget(
                  name: VariablesOne.gasOrderCount.toString(),
                  textColor: kWhiteColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,
                ),
                child:IconButton(icon: Icon(Icons.view_agenda_rounded), onPressed: (){
                  Platform.isIOS ?
                  /*show ios bottom modal sheet*/
                  showCupertinoModalPopup(

                      context: context, builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      actions: <Widget>[
                        ViewBookings()
                      ],
                    );
                  })

                      : showModalBottomSheet(
                      isDismissible: false,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => ViewBookings()
                  );
                }),

                toAnimate: true,
                badgeColor: kRedColor,
                shape: BadgeShape.circle,
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,

              ),

        IconButton(icon: SvgPicture.asset('assets/imagesFolder/small_cy.svg',), onPressed: (){
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => ChangeGasPrice()
          );
        }),
             /* Badge(
                badgeContent: MoneyFormatColors(
                    color: kWhiteColor,
                    title: TextWidget(
                  name: '300',
                  textColor: kWhiteColor,
                  textSize: 12,
                  textWeight: FontWeight.bold,
                )),
                child:IconButton(icon: SvgPicture.asset('assets/imagesFolder/small_cy.svg',), onPressed: (){
                  Platform.isIOS ?
                  *//*show ios bottom modal sheet*//*
                  showCupertinoModalPopup(

                      context: context, builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      actions: <Widget>[
                        ViewBookings()
                      ],
                    );
                  })

                      : showModalBottomSheet(
                      isDismissible: false,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => ViewBookings()
                  );
                }),

                toAnimate: true,
                badgeColor: kGreenColor,
                shape: BadgeShape.circle,
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,

              ),

*/



            ],
          ),

        )
    );

  }

  void confirmGas() {

    showDialog(
      barrierDismissible: false,
        context: context,
        builder:(context)=> Platform.isIOS ?
        CupertinoAlertDialog(
          title: TextWidget(
            name: 'Confirm products'.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          content:  Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextWidget(
              name: 'Are you sure your gas station has gas and cylinder',
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),
          ),



          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                turnOn();
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidget(
              name: 'Confirm products'.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          )
          ,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextWidget(
                name: 'Are you sure your gas station has gas and cylinder',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),
            YesNoBtn(no: (){
              setState(() {
                checkTrue = true;
              });
              Navigator.pop(context);},yes: (){turnOn();},),
          ],
        ));

  }

  void turnOn() {
    setState(() {
      status = true;
    });
    Navigator.pop(context);
    FirebaseFirestore.instance.collection
('AllBusiness').doc(Variables.currentUser[0]['ca']).update({
      'ol':true,

    });
  }







}
