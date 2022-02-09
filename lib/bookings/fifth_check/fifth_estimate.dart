import 'dart:async';
import 'dart:io';

import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/estimate_construct.dart';
import 'package:easy_homes/bookings/constructors/estimate_price_new.dart';
import 'package:easy_homes/bookings/constructors/estimated_price.dart';
import 'package:easy_homes/bookings/constructors/rent_table.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/delivery_time.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FifthEstimate extends StatefulWidget {
  @override
  _FifthEstimateState createState() => _FifthEstimateState();
}

class _FifthEstimateState extends State<FifthEstimate> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.04);
  }
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
  dynamic kgSum;
  int? gasPrice;
late  Timer _timer;
  int grandTotal = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Variables.totalGasKG = 0;
    Variables.selectedAmount.forEach((e) => Variables.sumCylinder += e);
    //Variables.sumCylinder = Variables.selectedAmount.fold(0, (previous, current) => previous + current);

    getTotal();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
            appBar: BookingAppBar(title: Variables.buyingGasType!,),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  EstimateConstruct(title:kEstimate2, size: '', kgTotal: '',),


                  spacer(),
                  RentTable(num: Variables.cylinderCount.toString(),month: kMonthly,rent: '${numberFormat.format(Variables.sumCylinder)}',),
                  spacer(),
                  EstimatedPrice(title:Variables.totalGasKG == 0 || Variables.totalGasKG == null?'0.00': '${numberFormat.format(grandTotal)}'

                    ,price: kEstimatedPrice2,),
                  spacer(),

                  spacer(),
                  SizedBtn(nextFunction: (){_moveNext();}, bgColor: kLightBrown, title: kNextBtn),
                  spacer(),
                ],
              ),
            )));
  }

  void getTotal() {
    _timer = Timer.periodic( Duration(seconds: 1), (timer) {

      setState(() {
        Variables.gasEstimatePrice = 0;
        Variables.gasEstimatePrice = Variables.totalGasKG * Variables.cloud!['gas'];
        grandTotal = Variables.gasEstimatePrice + Variables.sumCylinder;
      });


    });


  }

  void _moveNext() {
    if((Variables.totalGasKG == 0) && (Variables.isCheckedFill == false)){
      /*Fluttertoast.showToast(
          msg: kGError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);*/
      YYAlertDialogWithDuration();

    }else if((Variables.totalGasKG == null) && (Variables.isCheckedFill == false)) {
      /*Fluttertoast.showToast(
          msg: kGError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);*/
      YYAlertDialogWithDuration();

    }else{
      _timer.cancel();
      Variables.grandTotal =  grandTotal;
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

  YYDialog YYAlertDialogWithDuration() {
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 4
      ..gravityAnimationEnable = true
      ..gravity = Gravity.right
      ..duration = Duration(milliseconds: 600)


      ..text(
        padding: EdgeInsets.all(18),
        text: 'Error',
        color: kLightBrown,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        alignment: Alignment.center,

      )..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
        text: kGError,
        color: kTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        alignment: Alignment.center,
      )
      ..doubleButton(
        padding: EdgeInsets.only(right: 10.0),
        gravity: Gravity.right,
        text1: "OK, Got it",
        color1: kDoneColor,
        fontSize1: 18.0,
        fontWeight1: FontWeight.bold,

      )
      ..show();
  }
}
