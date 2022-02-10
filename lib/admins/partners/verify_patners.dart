import 'dart:io';
import 'package:easy_homes/reg/screens/home2.dart';
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

class VerifyPartners extends StatefulWidget {
  VerifyPartners({required this.ctyCode});

  final String ctyCode;
  @override
  _VerifyPartnersState createState() => _VerifyPartnersState();
}

class _VerifyPartnersState extends State<VerifyPartners> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;


  Widget animatingBorders() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: kWhiteColor,
      border: Border.all(color: kTextFieldBorderColor),
      borderRadius: BorderRadius.circular(15),

    );
    return PinPut(

      autofocus: true,
      //validator: Variables.validatePin,
      obscureText: '*',
      fieldsCount: 6,
      eachFieldHeight: 20,
      onSubmit: (String pine) {
        Variables.mobilePin = pine;
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

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset('assets/imagesFolder/go_back.svg')
            ),
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

          GestureDetector(
              onTap: () {
                _reSendCode();
              },
              child: RichText(
                text: TextSpan(text: kResendPin,
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.w300,
                      fontSize: ScreenUtil().setSp(
                          16, ),
                      color: kBlackColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: kResendPin2,
                        style: GoogleFonts.oxanium(
                          fontSize: ScreenUtil().setSp(
                              kFontSize, ),
                          color: kBlueColor,
                        ),
                      ),
                    ]
                ),
              )
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


          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.5,
            height: 60.h,
            child: Platform.isIOS ?

            CupertinoButton(
              onPressed: () {
                moveToNext();
              },
              color: kTextFieldBorderColor,
              child: Text(kNextBtn,

                style: GoogleFonts.oxanium(
                  fontSize: ScreenUtil().setSp(
                      22, ),
                  color: kWhiteColor,
                ),
              ),
              borderRadius: BorderRadius.circular(6.0),)

                : RaisedButton(
              onPressed: () {
                moveToNext();
              },
              color: _pinPutController.text == ''
                  ? kTextFieldBorderColor
                  : kPinColor,
              child: Text(kNextBtn,

                style: GoogleFonts.oxanium(
                  fontSize: ScreenUtil().setSp(
                      22, ),
                  color: kWhiteColor,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(6.0),),
            ),
          )

        ],
      ),
    );
  }

  Future<void> moveToNext() async {
    /*check if mobile number is not empty*/
    if (_pinPutController.text == '') {
      Fluttertoast.showToast(
          msg: kPinError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: Variables.verificationId!,
          smsCode: _pinPutController.text);
      UserCredential result = await _auth.signInWithCredential(credential);

     // User result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      if (user != null) {
        registerUser(user);
      }
    }
  }

  void _reSendCode() {
    //Auth the user
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: widget.ctyCode + Variables.mobile!,
      timeout: Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) async {
        Fluttertoast.showToast(
            msg: kPhoneVerification,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);
        Navigator.of(context).push
          (MaterialPageRoute(builder: (context) => RefralScreen()));

        UserCredential result = await _auth.signInWithCredential(credential);
        User? user = result.user;

        if (user != null) {
          registerUser(user);
        }
      },
      verificationFailed: (FirebaseAuthException exception) {
        print(exception.message);
        Fluttertoast.showToast(
            msg: exception.message.toString(),
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      },
      codeSent: (String verificationCode, [int? forceCodeResend]) {
        Variables.verificationId = verificationCode;
        return;
      },
      codeAutoRetrievalTimeout:  (String verificationId) {},
    );
  }

  Future<void> registerUser(User user) async {

    Navigator.of(context).pushReplacement
      (MaterialPageRoute(builder: (context) => HomeScreenSecond()));


  }

}


