import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/google_auth_signin.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/recover/forgot_password.dart';

import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/reg/screens/profile_pix.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/auth.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  Color btnColor = kTextFieldBorderColor;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _publishModal = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    return SafeArea(child: PlatformScaffold(body: ProgressHUDFunction(
      inAsyncCall: _publishModal,
      child: SingleChildScrollView(

        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imagesFolder/home_bg.png'),
                fit: BoxFit.cover,)),
          child: Column(
            children: <Widget>[


              spacer(),
          LogoDesign(),
              RegText(title: kLoginText,),
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

                    },
                  )),


              spacer(),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Platform.isIOS
                      ? CupertinoTextField(
                    controller: _password,
                    autocorrect: true,
                    autofocus: true,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    placeholderStyle: GoogleFonts.oxanium(
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),
                      color: kHintColor,
                    ),
                    placeholder: 'Password',
                    onChanged: (String value) {
                      Variables.password = value;
                      if ((Variables.password == '') || (_password.text.length < 6)) {
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
                    controller: _password,
                    autocorrect: true,
                    autofocus: true,
                    cursorColor: (kTextFieldBorderColor),
                    obscureText: true,
                    style: Fonts.textSize,
                    decoration: Variables.passwordInput,
                    onChanged: (String value) {
                      Variables.password = value;
                      if ((Variables.password == '') || (_password.text.length < 6)) {
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

              /*displaying Next button*/
              spacer(),

              GestureDetector(

                  onTap: (){

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePixScreen()));
                  },
                  child: RichText(

                    text: TextSpan(text: '$kLoginText2 ',
                        style: GoogleFonts.oxanium(
                          fontSize: ScreenUtil().setSp(
                              kFontSize, ),
                          color: kBlackColor,
                        ),

                        children: <TextSpan>[
                          TextSpan(
                            text: kSignUp,
                            style: GoogleFonts.pacifico(
                              fontSize: ScreenUtil().setSp(
                                  kFontSize, ),
                              color: kLightBrown,
                            ),
                          ),
                        ]
                    ),


                  )),
              spacer(),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ForgotPassword()));

                },
                child: TextWidget(name: kForgotPassword,
                  textColor: kDoneColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.normal,),
              ),


              spacer(),

              BtnSecond(title:'Login',nextFunction: (){moveToNext();},bgColor: btnColor,),
              spacer(),
              Container(
                color: Colors.blue,
                child: SignInButton(
                  Buttons.Google,
                  text: "Sign in with Google",
                  onPressed: () {_signInWithGoogle();},
                  padding: EdgeInsets.all(14.0),
                  elevation: 5.0,
                ),
              ),
              // spacer(),
              // SignInButton(
              //   Buttons.Apple,
              //   text: "Sign in with Apple",
              //   onPressed: () {_signInWithApple();},
              //   padding: EdgeInsets.all(14.0),
              //   elevation: 5.0,
              // ),


            ],
          ),
        ),
      ),
    )));
  }

  Future<void> moveToNext() async {



    if ((Variables.email == null) || (Variables.email == '')) {
      Fluttertoast.showToast(
          msg: kEmailError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else if((Variables.password == null ) || (Variables.password == '')){
      Fluttertoast.showToast(
          msg: kPasswordError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);


    }else {
      try {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        setState(() {
          _publishModal = true;
        });
        final user = await _auth.signInWithEmailAndPassword(
            email: Variables.email!.trim(), password: Variables.password!.trim());
        if (user != null) {
          setState(() {
            _publishModal = false;
          });
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreenSecond(),
            ),
                (route) => false,
          );


        }
      }catch (e){
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
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _publishModal = true;
    });
    User? user = await Authentication.signInWithGoogle(context: context);

    if (user != null) {
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreenSecond(),
        ),
            (route) => false,
      );

    }
    setState(() {
      _publishModal = false;
    });
  }

  // Future<void> _signInWithApple() async {
  //   setState(() {
  //     _publishModal = true;
  //   });
  //
  //
  //
  //
  //   try {
  //
  //     final appleIdCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       // webAuthenticationOptions: WebAuthenticationOptions(
  //       //   clientId: <CLIENT_ID>,
  //       //   redirectUri: Uri.parse(
  //       //   <REDIRECT_URI>,
  //       //   ),
  //       // ),
  //     );
  //
  //     // get an OAuthCredential
  //     final oAuthProvider = OAuthProvider('apple.com');
  //     final credential = oAuthProvider.credential(
  //       idToken: appleIdCredential.identityToken,
  //       accessToken: appleIdCredential.authorizationCode,
  //     );
  //     // use the credential to sign in to firebase
  //     final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
  //     final user = authResult.user;
  //
  //     if (user != null) {
  //       Navigator.pushAndRemoveUntil(context,
  //         MaterialPageRoute(
  //           builder: (BuildContext context) => UserInfoScreen(user: user),
  //         ),
  //             (route) => false,
  //       );
  //       setState(() {
  //         _publishModal = false;
  //       });
  //     }else{
  //       VariablesOne.notifyFlutterToastError(title: "Not been able to login you in");
  //       setState(() {
  //         _publishModal = false;
  //       });
  //     }
  //
  //   }catch(e){
  //     print(e);
  //     VariablesOne.notifyFlutterToastError(title: e.toString());
  //     setState(() {
  //       _publishModal = false;
  //     });
  //   }
  // }

}
