import 'dart:io';
import 'package:easy_homes/reg/screens/recover/recover_pass.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/Screens/logins.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/auth.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }
  Color btnColor = kTextFieldBorderColor;
  TextEditingController _email = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _publishModal = false;
  bool link = false;
  String name = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: ProgressHUDFunction(
      inAsyncCall: _publishModal,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            spacer(),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Stack(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      alignment: Alignment.topLeft,
                      child: SvgPicture.asset('assets/imagesFolder/go_back.svg')),
                  LogoDesign(),
                ],
              ),
            ),
            RegText(title: kEmail,),
            spacer(),
            Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Platform.isIOS
                    ? CupertinoTextField(
                  controller: _email,
                  autocorrect: true,
                  autofocus: true,

                  keyboardType: TextInputType.emailAddress,
                  cursorColor: (kTextFieldBorderColor),
                  style: Fonts.textSize,
                  placeholderStyle: GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kHintColor,
                  ),
                  placeholder: 'Email',
                  onChanged: (String value) {
                    Variables.email = value;
                    if (Variables.email == '') {
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
                  controller: _email,
                  autocorrect: true,
                  autofocus: true,
                  cursorColor: (kTextFieldBorderColor),
                  keyboardType: TextInputType.emailAddress,
                  style: Fonts.textSize,
                  decoration: Variables.emailInput,
                  onChanged: (String value) {
                    Variables.email = value;
                    if (Variables.email == '') {
                      setState(() {
                        btnColor = kTextFieldBorderColor;
                      });
                    } else {
                      setState(() {
                        btnColor = kLightBrown;
                      });
                    }
                  },
                )),
            spacer(),


            SizedBtn(title:'Send',nextFunction: (){moveToNext();},bgColor: btnColor,),

            spacer(),
            spacer(),


            // GestureDetector(
            //   onTap: (){
            //     Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: RecoverPass()));
            //
            //
            //   },
            //   child: Container(
            //     alignment: Alignment.topRight,
            //     margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            //     child: Text( 'Send password to my mobile number not email',
            //
            //       style: GoogleFonts.pacifico(
            //         decoration: TextDecoration.underline,
            //
            //         fontSize: ScreenUtil().setSp(
            //             kFontSize14, ),
            //         color: kDoneColor,
            //       ),
            //     ),
            //   ),
            // ),
        Visibility(
          visible:link,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: TextWidget(name: kEmailLink,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.normal,),
          ),
        ),

          ],
        ),
      ),
    )));
  }

  Future<void> moveToNext() async {
    if(_email.text.length == 0){
      Fluttertoast.showToast(
          msg: kEmailError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else{
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email.text);
      if (emailValid == true) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {
          _publishModal = true;
        });

            try{
            await _auth.sendPasswordResetEmail(email: _email.text.trim());

            setState(() {
              link = true;
              _publishModal = false;
            });

            Future.delayed(const Duration(seconds: 5), () {

              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.bottomCenter, child: LoginScreen()));

            });

          }catch(e){
              setState(() {
                _publishModal = false;
              });
              String exception = Auth.getExceptionText(Exception(e));
              Fluttertoast.showToast(
                  msg: exception,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: kBlackColor,
                  textColor: kRedColor);

            }




      } else {
        Fluttertoast.showToast(
            msg: kEmailError2,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }
  }
}
