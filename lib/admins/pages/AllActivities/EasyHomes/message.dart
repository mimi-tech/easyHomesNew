import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/send_message.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

class VerifyMessage extends StatefulWidget {
  @override
  _VerifyMessageState createState() => _VerifyMessageState();
}

class _VerifyMessageState extends State<VerifyMessage> {
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05,);
  }
  TextEditingController _email = TextEditingController();
  Color btnColor = kTextFieldBorderColor;
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Column(
          children: <Widget>[
            space(),

            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: TextWidgetAlign(name: kMessageEmail.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),
            ),

            space(),

            Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Platform.isIOS
                    ? CupertinoTextField(
                  controller: _email,
                  autocorrect: true,

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

            /*displaying Next button*/
            space(),
        progress == true?PlatformCircularProgressIndicator(): SizedBtn(title:'Verify',nextFunction: () {
              moveToNext();
            }, bgColor: btnColor,),

            space(),
          ],
        ),
      ),
    );
  }

  Future<void> moveToNext() async {
    if ((Variables.email == null) || (Variables.email == '')) {
      Fluttertoast.showToast(
          msg: kEmailError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {
      //check if email is valid

      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(Variables.email!);
      if (emailValid == true) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {
          progress = true;
        });
        /*check in the database if the email exist*/

        try{
          final QuerySnapshot result = await FirebaseFirestore.instance
.collection('userReg')
              .where('email',isEqualTo: _email.text.trim())

              .get();

          final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
            setState(() {
              progress = false;
            });
            Fluttertoast.showToast(
                msg: 'Sorry this email does not exist',
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: kBlackColor,
                textColor: kRedColor);
          }else{
            Navigator.pop(context);
            Navigator.push(context,
                PageTransition(
                    type: PageTransitionType
                        .scale,
                    alignment: Alignment
                        .bottomCenter,
                    child: EasySendMessage()));
          }
        }catch(e){
        VariablesOne.notifyFlutterToastError(title: kError);
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
