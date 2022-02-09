import 'dart:io';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/screens/txn.dart';
import 'package:easy_homes/reg/screens/mobile.dart';
import 'package:easy_homes/reg/screens/user_profile.dart';
import 'package:easy_homes/utility/paint.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/referal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyChangeMobileScreen extends StatefulWidget {
  VerifyChangeMobileScreen({required this.otpCode});

  final Function otpCode;
  @override
  _VerifyChangeMobileScreenState createState() => _VerifyChangeMobileScreenState();
}

class _VerifyChangeMobileScreenState extends State<VerifyChangeMobileScreen>  with TickerProviderStateMixin {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Color bgColor = kTextFieldBorderColor;





  Widget animatingBorders() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: kWhiteColor,
      border: Border.all(color: kTextFieldBorderColor),
      borderRadius: BorderRadius.circular(15),

    );



    return PinPut(

      autofocus: true,
      validator: Variables.validatePin,
      obscureText: '*',
      fieldsCount: 6,
      eachFieldHeight: 20,
      onSubmit: (String pine) {
        Variables.mobilePin = pine;
      },
      onChanged: (String pin){
        if(_pinPutController.text.length == 0){
          setState(() {
            bgColor = kTextFieldBorderColor;
          });
        }else{
          setState(() {
            bgColor = kLightBrown;
          });
        }
      },
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration:
      pinPutDecoration.copyWith(borderRadius: BorderRadius.circular(20)),
      pinAnimationType: PinAnimationType.slide,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: kTextFieldBorderColor,
        ),
      ),
    );
  }

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }





  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);


    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: SingleChildScrollView(
    child: Container(
      child: Column(
        children: <Widget>[
          spacer(),
          Stack(
            alignment: Alignment.topRight,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(

                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset('assets/imagesFolder/go_back.svg')
                ),
              ),



            ],
          ),
          Center(child: SvgPicture.asset('assets/imagesFolder/mobile.svg')),
          RegText(title: kMobileVerify + '+234' + Variables.mobile!,),
          spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(kEditMobile,
              style: GoogleFonts.oxanium(
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kLightBrown,
              ),
            ),
          ),

          spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: animatingBorders(),
          ),
          GestureDetector(
            onTap: () => _pinPutController.text = '',
            child: Text(kEditMobileClear,
              style: GoogleFonts.oxanium(
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kLightBrown,
              ),
            ),
          ),
          /*displaying Next button*/
          spacer(),


          NewBtn(nextFunction: widget.otpCode as void Function(), bgColor: bgColor, title: kNextBtn)

        ],
      ),
    )
    ));
  }






}


