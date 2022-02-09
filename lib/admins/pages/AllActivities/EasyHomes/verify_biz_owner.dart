import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/reset_biz_pin.dart';
import 'package:easy_homes/admins/partners/sec_generate_key.dart';
import 'package:easy_homes/admins/third_modal.dart';
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
class VerifyBusinessOwner extends StatefulWidget {
  @override
  _VerifyBusinessOwnerState createState() => _VerifyBusinessOwnerState();
}

class _VerifyBusinessOwnerState extends State<VerifyBusinessOwner> {
  TextEditingController _email = TextEditingController();
  Color btnColor = kTextFieldBorderColor;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  String firstName = '';
  String lastName = '';
  String? uid;
  String? email;
  bool checkEmail = false;
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 600),
      curve: Curves.decelerate,
      child: Column(
        children: <Widget>[
          spacer(),


          spacer(),checkEmail==true?
          TextWidgetAlign(name: 'Confirmed business owner'.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,):

          TextWidgetAlign(name: 'Enter the business email'.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),

          spacer(),
          firstName == ''? Text(''): Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(

                  text: 'Do you want to create another business pin for ',

                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.normal,
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kTextColor,
                  ),

                  children: <TextSpan>[
                    TextSpan(text: firstName + " "+ lastName,
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                            kFontSize, ),
                        color: kDoneColor,
                      ),)
                  ]
              ),
            ),
          ),
          spacer(),

          checkEmail == true?Container():Container(
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
                  email = value;
                  if (email == '') {
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
                  email = value;
                  if (email == '') {
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
          progress == true?PlatformCircularProgressIndicator(): checkEmail == true?Text(''):

          Column(
            children: [
              BtnSecond(title: kVerify, nextFunction: () {


                moveToNext();
              }, bgColor: btnColor,),
                 spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(

                    text: 'Note ',

                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                      color: kBlackColor,
                    ),

                    children: <TextSpan>[
                      TextSpan(text: 'You want to create another business pin for this business account. Please verify the account before proceeding. Thanks.',
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(kFontSize, ),
                          color: kTextColor,
                        ),)
                    ]
                ),
              ),
            ],
          ),


          checkEmail == true? BtnSecond(title: 'Proceed', nextFunction: () {


            nextModal();
          }, bgColor: kDoneColor,):Text(''),

          spacer(),
        ],
      ),
    ));
  }

  Future<void> moveToNext() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    /*check if this email already exist*/

    if ((Variables.email == null) || (Variables.email == '')) {
      Fluttertoast.showToast(
          msg: kMobileError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }  else {
      setState(() {
        progress = true;
      });

      try{
        final QuerySnapshot result = await FirebaseFirestore.instance.collection('userReg')
            .where('email', isEqualTo: email!.trim())

            .get();
        final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
          setState(() {
            progress = false;
          });
          Fluttertoast.showToast(
              msg: 'Sorry this user does not exist',
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 10,
              backgroundColor: kBlackColor,
              textColor: kRedColor);

        }else{
          for (DocumentSnapshot document in documents) {
            setState(() {
              firstName = document['fn'];
              lastName = document['ln'];
              uid = document['ud'];
              progress = false;
              checkEmail = true;
            });
          }

        }
      }catch(e){
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }



    }

  }

  void nextModal() {
    setState(() {
      AdminConstants.businessType = AdminConstants.admin;
    });
    Navigator.pop(context);


    Platform.isIOS?showPlatformModalSheet(
      context: context,

      builder: (_) => PlatformWidget(
        cupertino: (_, __) => BusinessRestKey(userUid: uid!),
      ),
    ):showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) => BusinessRestKey(userUid: uid!)
    );



  }
}
