import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/partners/biz_code.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
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

class ChangeGasPrice extends StatefulWidget {
  @override
  _ChangeGasPriceState createState() => _ChangeGasPriceState();
}

class _ChangeGasPriceState extends State<ChangeGasPrice> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  Color btnColor = kTextFieldBorderColor;
  TextEditingController _gasPrize = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Constant1.stationDocuments != null){
    setState(() {
      _gasPrize.text = Constant1.stationDocuments![0]['gas'].toString();
    });}
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Container(
    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
    child: Column(
    children: <Widget>[
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



      YesNoBtnDynamic(no: (){Navigator.pop(context);}, yes: (){moveToNext();},yesText: 'Ok',noText: kCancel,),
      spacer(),
      ]))));
  }

  void moveToNext() {
    //update the gas prize per kg for this gas station

    try{
if(Constant1.changeGasPrize){
  //This is coming from the business owner
  FirebaseFirestore.instance.collection('AllBusiness')
      .where('ud', isEqualTo:  Variables.currentUser[0]['ud'])
      .get().then((value) {

    value.docs.forEach((result) {

      result.reference.set({
        'gas': _gasPrize.text.trim(),
      },SetOptions(merge: true));
    });
  });
  Navigator.pop(context);
  Constant1.changeGasPrize = false;
  VariablesOne.notifyFlutterToast(title: 'Prize updated successfully');

}else {
  //This is coming from the sales personnel

  FirebaseFirestore.instance.collection('AllBusiness').doc(
      Variables.currentUser[0]['ca']).set({
    'gas': int.parse(_gasPrize.text.trim()),

  }, SetOptions(merge: true));

  Navigator.pop(context);
  //VariablesOne.notifyFlutterToast(title: 'Prize changed successfully');


}}catch (e){
      Constant1.changeGasPrize = false;

    }
  }
}
