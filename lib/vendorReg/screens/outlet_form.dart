import 'dart:io';
import 'package:easy_homes/utils/capitalize.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/vendorReg/screens/store_address.dart';

import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class OutLetForm extends StatefulWidget {
  @override
  _OutLetFormState createState() => _OutLetFormState();
}

class _OutLetFormState extends State<OutLetForm> {

  TextEditingController _companyName = TextEditingController();

  Color btnColor = kTextFieldBorderColor;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: SingleChildScrollView(
      child: Container(
margin: EdgeInsets.symmetric(horizontal: kHorizontal),
child: Column(
  children: <Widget>[
      spacer(),
     BackLogo(),


      spacer(),
      TextWidget(
        name: kGasOS,
        textColor: kBlackColor,
        textSize: kFontSize,
        textWeight: FontWeight.w600,
      ),

      spacer(),
Platform.isIOS
? CupertinoTextField(
  controller: _companyName,
  autocorrect: true,
  autofocus: true,

  keyboardType: TextInputType.text,
  cursorColor: (kTextFieldBorderColor),
  style: Fonts.textSize,
  placeholderStyle: GoogleFonts.oxanium(
      fontSize: ScreenUtil().setSp(
          kFontSize, ),
      color: kHintColor,
  ),
  placeholder: kCompanyName,
  onChanged: (String value) {
      VendorConstants.companyName = value;
      if( VendorConstants.companyName == '' ){
        setState(() {
          btnColor = kTextFieldBorderColor;
        });
      }else{
        setState(() {
          btnColor = kLightBrown;
        });
      }

  },
  decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorder),
        border: Border.all(color: kLightBrown)),
)
            : TextField(
        controller: _companyName,
        autocorrect: true,
        autofocus: true,
        cursorColor: (kTextFieldBorderColor),
        keyboardType: TextInputType.text,
        style: Fonts.textSize,
        decoration: VendorConstants.companyNameInput,
        onChanged: (String value) {
          VendorConstants.companyName = value;
          if( VendorConstants.companyName == '' ){
            setState(() {
              btnColor = kTextFieldBorderColor;
            });
          }else{
            setState(() {
              btnColor = kLightBrown;
            });
          }
        },

      ),


  /*the company CAC*/

      spacer(),

      /*Platform.isIOS
          ? CupertinoTextField(
        controller: _companyCAC,
        autocorrect: true,
        autofocus: true,

        keyboardType: TextInputType.numberWithOptions(),
        cursorColor: (kTextFieldBorderColor),
        style: Fonts.textSize,
        placeholderStyle: GoogleFonts.oxanium(
          fontSize: ScreenUtil().setSp(
              kFontSize, ),
          color: kHintColor,
        ),
        placeholder: kCompanyCAC,
        onChanged: (String value) {
          VendorConstants.companyCAC = value;
          if ( VendorConstants.companyCAC == '') {
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
      )
          : TextField(
        controller: _companyCAC,
        autocorrect: true,
        autofocus: true,
        cursorColor: (kTextFieldBorderColor),
        keyboardType: TextInputType.text,
        style: Fonts.textSize,
        decoration: VendorConstants.companyCaCInput,
        onChanged: (String value) {
          VendorConstants.companyCAC = value;
          if ( VendorConstants.companyCAC == '') {
            setState(() {
              btnColor = kTextFieldBorderColor;
            });
          } else {
            setState(() {
              btnColor = kLightBrown;
            });
          }
        },

      ),*/

      spacer(),
      Btn(nextFunction: () {
        moveToNext();
      }, bgColor: btnColor,),

  ]),


),
    ),


    ));
  }

  void moveToNext() {

    if((VendorConstants.companyName == null ) || (VendorConstants.companyName == '')){
      Fluttertoast.showToast(
          msg: kCompanyNameError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);

    }else {
      var name =  VendorConstants.companyName!.capitalize();
      VendorConstants.companyName = name;
      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OutletAddress()));


    }



    }


}
