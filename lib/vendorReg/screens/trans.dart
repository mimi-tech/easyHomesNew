import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/screens/licence.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
class Transport extends StatefulWidget {
  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<Transport> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }
  String radioItem = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Column(
          children: <Widget>[
            spacer(),
           BackLogo(),

            spacer(),

            TextWidgetAlign(
              name: kModeTrans,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
            spacer(),
            spacer(),
            RadioListTile(
              groupValue: radioItem,
              title:TextWidget(
                name: kModeTrans2,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),
              value: 'vehicle',
              onChanged: (dynamic val) {
                setState(() {
                  radioItem = val;
                });
              },
            ),

            RadioListTile(
              groupValue: radioItem,
              title: TextWidget(
                name: kModeTrans3,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),
              value: 'byke',
              onChanged: (dynamic val) {
                setState(() {
                  radioItem = val;
                });
              },
            ),


            RadioListTile(
              groupValue: radioItem,
              title: TextWidget(
                name: kModeTrans4,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),
              value: 'both',
              onChanged: (dynamic val) {
                setState(() {
                  radioItem = val;
                });
              },
            ),


            spacer(),
            spacer(),
            Btn(nextFunction: () {
              moveToNext();
            }, bgColor: kLightBrown,),
          ],
        ),
      )
    )));
  }

  void moveToNext() {
   if(radioItem == ''){
     Fluttertoast.showToast(
         msg: kModeTransError,
         toastLength: Toast.LENGTH_LONG,
         backgroundColor: kBlackColor,
         textColor: kRedColor);
   }else{
     setState(() {
       VendorConstants.moodOfDelivery = radioItem;
     });
     //print(VendorConstants.moodOfDelivery == 'both'?'vehicle':VendorConstants.moodOfDelivery);


     Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorLicence()));

   }
  }
}
