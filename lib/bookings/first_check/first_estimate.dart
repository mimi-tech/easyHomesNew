import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/estimate_construct.dart';
import 'package:easy_homes/bookings/constructors/estimated_price.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/bookings/constructors/total_cy.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FirstEstimate extends StatefulWidget {
  @override
  _FirstEstimateState createState() => _FirstEstimateState();
}

class _FirstEstimateState extends State<FirstEstimate> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
  double kgSum = 0.0;
  double e = 0.0;
  int? gasPrice;
late  Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Variables.gasEstimatePrice = 0;
    Variables.totalGasKG = 0;

    getTotal();
      if(Variables.kGItems.length == 1){
        List<double> lint = Variables.kGItems.map(double.parse).toList();
        //lint.forEach((e) => e += e);
        e = lint.fold(0, (previous, current) => previous + current);
       // Variables.totalCylinder = e * Variables.cylinderCount;
        kgSum = e * Variables.cylinderCount;
      }else{
    List<double> lint = Variables.kGItems.map(double.parse).toList();
    kgSum = lint.fold(0, (previous, current) => previous + current);
    Variables.totalCylinder = kgSum;


  }}

  Widget mainBody(){
   return SingleChildScrollView(
      child: Column(
        children: [
          spacer(),
          EstimateConstruct(title:kEstimate2,size: kgSum.toString(), kgTotal: '',),
          spacer(),




          Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: TextWidgetAlign(
              name: kGasNote,
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.normal,
            ),
          ),


          Divider(thickness: 2.0,),
          spacer(),
          EstimatedPrice(title:Variables.totalGasKG == 0 || Variables.totalGasKG == null?'0.00':'${numberFormat.format(Variables.gasEstimatePrice)}',price: kEstimatedPrice,),
          spacer(),
          SizedBtn(nextFunction: (){_moveNext();}, bgColor: kLightBrown, title: kNextBtn),
          spacer(),
        ],
      ),
    );
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

        child: Platform.isIOS?
            CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  middle: CupertinoTextAppbar(title: Variables.buyingGasType!,)
              ),
              child: mainBody(),
            )
            :Scaffold(
            appBar: BookingAppBar(title: Variables.buyingGasType!,),
            body: mainBody()));
  }

  void getTotal() {


    _timer = Timer.periodic( Duration(milliseconds: 100), (timer) {

setState(() {
  Variables.gasEstimatePrice = Variables.totalGasKG * Variables.cloud!['gas'];

});

    });
  }

  void _moveNext() {
    if((Variables.totalGasKG == 0) && (Variables.isCheckedFill == false)){

      YYAlertDialogWithDuration();

    }else if((Variables.totalGasKG == null) && (Variables.isCheckedFill == false)) {

      YYAlertDialogWithDuration();

    }else if(Variables.totalGasKG > kgSum){
      BotToast.showSimpleNotification(title: kKGWarning,
          duration: Duration(seconds: 5),
          backgroundColor: kRadioColor,
          titleStyle:TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil()
                .setSp(kFontSize, ),
            color: kDarkRedColor,
          ));
    }else{
      _timer.cancel();
      Variables.grandTotal =  Variables.gasEstimatePrice;
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
