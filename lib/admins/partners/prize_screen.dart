import 'package:easy_homes/admins/partners/biz_code.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class InputGasPrize extends StatefulWidget {
  @override
  _InputGasPrizeState createState() => _InputGasPrizeState();
}

class _InputGasPrizeState extends State<InputGasPrize> {

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  Color btnColor = kTextFieldBorderColor;
  TextEditingController _gasPrize = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Column(

              children: <Widget>[
                spacer(),
                spacer(),
                LogoDesign(),
                spacer(),
                spacer(),
                AnimationSlide(
                  title: TextWidgetAlign(
                    name:kGasP,
                    textColor: kDoneColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,
                  ),
                ),

                spacer(),
                spacer(),
                /*getting the code*/
                Platform.isIOS
                    ? Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: CupertinoTextField(
                    keyboardType: TextInputType.number,

                    controller: _gasPrize,
                    autocorrect: true,
                    autofocus: true,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    maxLength: 10,
                    placeholderStyle: GoogleFonts.oxanium(
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),
                      color: kHintColor,
                    ),
                    placeholder: 'Enter amount',
                    onChanged: (String value) {
                      VendorConstants.gasPrize = int.parse(value);
                      if (_gasPrize.text.length <= 0) {
                        setState(() {
                          btnColor = kTextFieldBorderColor;
                        });
                      } else {
                        setState(() {
                          btnColor = kLightBrown;
                        });
                      }
                    },
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorder),
                        border: Border.all(color: kLightBrown)),
                  ),
                )
                    : TextField(
                  keyboardType: TextInputType.number,


                  controller: _gasPrize,
                  autocorrect: true,
                  autofocus: true,
                  maxLength: 10,

                  cursorColor: (kTextFieldBorderColor),
                  style: Fonts.textSize,
                  decoration: VendorConstants.gasPrizeInput,
                  onChanged: (String value) {
                    VendorConstants.gasPrize = int.parse(value);

                    if (_gasPrize.text.length <= 0) {
                      setState(() {
                        btnColor = kTextFieldBorderColor;
                      });
                    } else {
                      setState(() {
                        btnColor = kLightBrown;
                      });
                    }
                  },

                ),
                spacer(),


                spacer(),




                Btn(nextFunction: () {
                  moveToNext();
                }, bgColor: btnColor,),
                spacer(),
              ],

            ),
          ),
        )));
  }

  void moveToNext() {
    if(( _gasPrize.text == '')  || ( _gasPrize.text == null)){
      Fluttertoast.showToast(
          msg: 'Please enter amount. Thanks',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 6,
          textColor: kRedColor);
    } else{
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: RegisterBusinessCode()));

    }
  }
}
