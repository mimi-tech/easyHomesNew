import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/cylinder_images.dart';
import 'package:easy_homes/bookings/first_check/cylinder_qty.dart';
import 'package:easy_homes/bookings/constructors/image_construct.dart';
import 'package:easy_homes/bookings/constructors/cylinder_image_second.dart';
import 'package:easy_homes/bookings/constructors/image_construct_new.dart';
import 'package:easy_homes/bookings/fifth_check/fifth_estimate.dart';
import 'package:easy_homes/bookings/first_check/first_estimate.dart';
import 'package:easy_homes/bookings/third_check/third_estimate.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class FifthNewCylinderSize extends StatefulWidget {
  @override
  _FifthNewCylinderSizeState createState() => _FifthNewCylinderSizeState();
}

class _FifthNewCylinderSizeState extends State<FifthNewCylinderSize> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        bottomNavigationBar:BookingsBottomAppBar(nextColor: kLightBrown,next: (){_nextFunction();},),

        appBar: BookingAppBar(title: Variables.buyingGasType!,),
        body: SingleChildScrollView(
          child: Column(
            children: [
              NewCylinderQuantityConstruct(qty: Variables.cylinderCountSecond,title:kCylinderQtyText),
              SizedBox(height: 30,),
              SecondCylinderImages(),
            ],
          ),
        )));
  }

  void _nextFunction() {

    setState(() {});
    if(Variables.secondKGItems.length == 0){
      Fluttertoast.showToast(
          msg: kCylinderSizeText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else{
      Navigator.push(context, PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.bottomCenter,
          child: FifthEstimate()));
    }
  }
}
