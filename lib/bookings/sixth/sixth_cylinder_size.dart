import 'dart:io';

import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/cylinder_images.dart';
import 'package:easy_homes/bookings/first_check/cylinder_qty.dart';
import 'package:easy_homes/bookings/constructors/image_construct.dart';
import 'package:easy_homes/bookings/constructors/new_cylinder_image.dart';
import 'package:easy_homes/bookings/first_check/first_estimate.dart';
import 'package:easy_homes/bookings/second_check/second_estimate.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/extacted_classes/delivery_time.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class SixthCylinderSize extends StatefulWidget {
  @override
  _SixthCylinderSizeState createState() => _SixthCylinderSizeState();
}

class _SixthCylinderSizeState extends State<SixthCylinderSize> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        bottomNavigationBar:BookingsBottomAppBar(nextColor: kLightBrown,next: (){_nextFunction();},),

        appBar: BookingAppBar(title: Variables.buyingGasType!,),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CylinderQuantityConstruct(qty: Variables.cylinderCount,title:kCylinderQtyTextNew),
              SizedBox(height: 30,),
              NewCylinderImages(),
            ],
          ),
        )));
  }

  void _nextFunction() {

    setState(() {});
    if(Variables.kGItems.length == 0){
      Fluttertoast.showToast(
          msg: kCylinderSizeText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else{
      Variables.selectedAmount.forEach((e) => Variables.grandTotal += e);

      //Variables.grandTotal = Variables.selectedAmount.fold(0, (previous, current) => previous + current);


      Platform.isIOS ?
      /*show ios bottom modal sheet*/
      showCupertinoModalPopup(

          context: context, builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            DeliveryTime()
          ],
        );
      })

          : showModalBottomSheet(

          isScrollControlled: true,
          context: context,
          builder: (context) => DeliveryTime()
      );
    }
  }
}
