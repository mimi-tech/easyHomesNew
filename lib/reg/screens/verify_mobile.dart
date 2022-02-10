import 'dart:io';
import 'package:easy_homes/reg/screens/txn.dart';
import 'package:easy_homes/reg/screens/mobile.dart';
import 'package:easy_homes/utility/paint.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/referal.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyMobileScreen extends StatefulWidget {
  VerifyMobileScreen({required this.ctyCode});

  final String ctyCode;
  @override
  _VerifyMobileScreenState createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen>  with TickerProviderStateMixin {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  FirebaseAuth _auth = FirebaseAuth.instance;

Color bgColor = kTextFieldBorderColor;
   AnimationController? controller;

  // bool isPlaying = false;

  String get timerString {
    Duration duration = controller!.duration! * controller!.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60)
        .toString()
        .padLeft(1, '0')}';
  }
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync:this,
      //value: 0.1,
      duration: Duration(minutes: 2),
    );



    startCount();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(controller != null){
      controller!.dispose();
    }

  }

  void startCount() {
    controller!.reverse(
        from: controller!.value == 0.0
            ? 1.0
            : controller!.value);


    controller!.addListener(() {
      if (controller!.value == 0.0) {
        Navigator.of(context).pushReplacement
          (MaterialPageRoute(builder: (context) => MobileScreen()));

      }

    });

  }


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




  Widget mainBody() {
    return SingleChildScrollView(
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
                    child: PlatformIconButton(
                        icon: Icon(Icons.arrow_back_ios,size: 30,),
                        onPressed: (){
                          Navigator.pop(context);
                        }
                    ),
                ),
              ),



              Container(
                alignment: Alignment.topRight,
                height: 70.h,
                width: 70.w,
                child: Align(
                  alignment: Alignment.topRight,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: controller!,
                            //builder: (BuildContext context, Widget? child) {  },
                            builder: (BuildContext context,
                                Widget? child) {
                              return CustomPaint(
                                  painter: TimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: kLightBrown
                                  ));
                            },
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment
                                .center,
                            children: <Widget>[

                              AnimatedBuilder(
                                  animation: controller!,
                                  builder: (BuildContext context,
                                      Widget? child) {
                                    return TextWidget(
                                      name: timerString,
                                      textColor: kTextColor,
                                      textSize: 22,
                                      textWeight: FontWeight.normal,
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

             /* GestureDetector(
                child: Container(
                  height: 40.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: kDoneColor,
                    shape: BoxShape.circle,

                  ),
                  child: Center(
                    child: TextWidget(name: '0.0',
                      textColor: kWhiteColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,),
                  ),
                ),
              )*/


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
              color:bgColor,
              child: Text(kNextBtn,

                style: GoogleFonts.oxanium(
                  fontSize: ScreenUtil().setSp(
                      22, ),
                  color: kWhiteColor,
                ),
              ),
              borderRadius: BorderRadius.circular(6.0),)

                : ElevatedButton(
              onPressed: () {
                moveToNext();
              },
              child: Text(kNextBtn),
              style: ElevatedButton.styleFrom(
              primary: bgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(6.0),),
                textStyle: GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(
                      22, ),
                    color: kWhiteColor,
                  ),

              ),

            ),
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);


    return SafeArea(
        child:  Scaffold(
            body: mainBody()
        )
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
      try {
        AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: Variables.verificationId!,
            smsCode: _pinPutController.text);

        UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      if (user != null) {

        registerUser(user);
      }
      }catch(e){

        Fluttertoast.showToast(
            msg: kWrongCode,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }
  }

  void _reSendCode() {
    //Auth the user
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber:  widget.ctyCode + Variables.mobile!,
      timeout: Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) async {
        Fluttertoast.showToast(
            msg: kPhoneVerification,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);
       /* Navigator.of(context).push
          (MaterialPageRoute(builder: (context) => RefralScreen()));*/
        if(controller != null){
          controller!.dispose();

        }
        Navigator.of(context).push
          (MaterialPageRoute(builder: (context) => TxnScreen()));

        //registerUser(user);
      },
      verificationFailed: (FirebaseAuthException exception) {
        print(exception.message);
        Fluttertoast.showToast(
            msg: exception.message!,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      },
      codeSent: (String verificationCode, [int? forceCodeResend]) {
        Variables.verificationId = verificationCode;
        return;
      },
      codeAutoRetrievalTimeout: (String message){},
    );
  }

  Future<void> registerUser(User user) async {
if(mounted){
  controller!.dispose();

}
    _auth.signOut();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TxnScreen()));
    }


    /* Navigator.of(context).pushReplacement
      (MaterialPageRoute(builder: (context) => HomeScreen()));
*/

  }





