import 'dart:io';
import 'dart:math';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/password.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/paint.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
class VerifyEmailAddress extends StatefulWidget {
  const VerifyEmailAddress({Key? key}) : super(key: key);

  @override
  _VerifyEmailAddressState createState() => _VerifyEmailAddressState();
}

class _VerifyEmailAddressState extends State<VerifyEmailAddress> with TickerProviderStateMixin{

  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  Color bgColor = kTextFieldBorderColor;
  AnimationController? controller;
  bool _publishModal = false;
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
    controller!.dispose();
  }

  void startCount() {
    controller!.reverse(
        from: controller!.value == 0.0
            ? 1.0
            : controller!.value);


    controller!.addListener(() {
      if (controller!.value == 0.0) {
       print("timeout ended");
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Column(
              children: [
                space(),
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
            Center(child: SvgPicture.asset('assets/imagesFolder/email.svg')),
            RegText(title:'$kEmailVerify to ${Variables.email}'),
            space(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(kEditEmailAddress,
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
            space(),
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
            space(),


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

    ),
        )));

  }

  void moveToNext() {
    try {
      setState(() {
        _publishModal = false;
      });
      //check if email code is valid
      if(int.parse(_pinPutController.text) == VariablesOne.emailCode){
        Navigator.of(context).push
          (MaterialPageRoute(builder: (context) => PasswordScreen()));
      }else{
        print(VariablesOne.emailCode);
        VariablesOne.notifyFlutterToastError(title: "Sorry incorrect code");
      }


    }catch(e){
      VariablesOne.notifyFlutterToastError(title: kError);
  }
  }

  void _reSendCode(){
    //generate the email code
    Random random = new Random();
    int emailCode = random.nextInt(900000) + 100000;
    VariablesOne.emailCode = emailCode;
    //send email code to this email
    Services.sendMail(
        email: Variables.email!.trim(),
        message: "<h2 style='color:orange;'>$kCompanyNames</h2>\n<p style='colors:LightGray;font-size:12px;'> <strong style='color:darkBlue;'><h3>$emailCode</h3></strong></p>",
        subject: "EasyHomes email verification code"
    );


  }
}
