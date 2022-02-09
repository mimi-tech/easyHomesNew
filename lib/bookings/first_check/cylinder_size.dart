import 'dart:io';

import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/cylinder_images.dart';
import 'package:easy_homes/bookings/first_check/cylinder_qty.dart';
import 'package:easy_homes/bookings/constructors/image_construct.dart';
import 'package:easy_homes/bookings/first_check/first_estimate.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class CylinderSize extends StatefulWidget {
  @override
  _CylinderSizeState createState() => _CylinderSizeState();
}

class _CylinderSizeState extends State<CylinderSize> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:

    Scaffold(
      bottomNavigationBar:BookingsBottomAppBar(nextColor: kLightBrown,next: (){_nextFunction();},),

        appBar: BookingAppBar(title: Variables.buyingGasType!,),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CylinderQuantityConstruct(qty: Variables.cylinderCount, title:kCylinderQtyText),
              SizedBox(height: 30,),
              CylinderImages(),
            ],
          ),
        )

    ));
  }

  void _nextFunction() {
dynamic e;
    setState(() {});

    if(Variables.cylinderCount > 1){

      //getting the total number of cylinders
      List<int> lint = Variables.headQuantityText.map(int.parse).toList();
      //dynamic e = lint.fold(0, (previous, current) => previous + current);

      lint.forEach((e) => e += e);
      if(Variables.kGItems.length == 0){
        Fluttertoast.showToast(
            msg: kCylinderSizeText,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }else if(Variables.cylinderCount != e) {
        VariablesOne.notifyErrorBot(title: 'Please select other cylinder size(s) and enter quantity. Thanks.');
      }else{
        Navigator.push(context, PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            child: FirstEstimate()));
      }

    }else{
      if(Variables.kGItems.length == 0){
        Fluttertoast.showToast(
            msg: kCylinderSizeText,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }else {
        Navigator.push(context, PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            child: FirstEstimate()));
      }

    }

  }
}
