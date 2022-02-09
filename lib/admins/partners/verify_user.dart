import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
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
class VerifyUser extends StatefulWidget {
  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
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
late DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 600),
      curve: Curves.decelerate,
      child: Column(
        children: <Widget>[
          spacer(),


          spacer(),checkEmail==true?TextWidgetAlign(name: 'Confirm Partner'.toUpperCase(),
      textColor: kLightBrown,
      textSize: kFontSize,
      textWeight: FontWeight.bold,): TextWidgetAlign(name: kUserEmail.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),

          spacer(),
      firstName == ''? Text(''): Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(

            text: 'You are creating a partnership pin for ',

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
                      22, ),
                  color: kDoneColor,
                ),)
            ]
        ),
      ),
      ),
          //spacer(),

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
         progress == true?PlatformCircularProgressIndicator(): checkEmail == true?Text(''):BtnSecond(title: kVerify, nextFunction: () {


            moveToNext();
          }, bgColor: btnColor,),


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
      print('ooooo');

      try {
        final QuerySnapshot result = await FirebaseFirestore.instance.collection('userReg')
            .where('email', isEqualTo: email!.trim()).get();
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
           for (document in documents) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            //check if the user has an unregistered business
           if(data['create'] == true) {
             Fluttertoast.showToast(
                 msg: kPinError4,
                 toastLength: Toast.LENGTH_LONG,
                 timeInSecForIosWeb: 10,
                 backgroundColor: kBlackColor,
                 textColor: kRedColor);
           }else if(data['ven'] == true) {
             Fluttertoast.showToast(
                 msg: kPinError5,
                 toastLength: Toast.LENGTH_LONG,
                 timeInSecForIosWeb: 10,
                 backgroundColor: kBlackColor,
                 textColor: kRedColor);
           }else{
             setState(() {
               firstName = data['fn'];
               lastName = data['ln'];
               uid = data['ud'];
               progress = false;
               checkEmail = true;
             });

           }
          }

        }

      }catch(e){
        print(e.toString());
      }
    }

  }


  void nextModal() {
    setState(() {
      AdminConstants.businessType = AdminConstants.partner;
    });
    Navigator.pop(context);


    Platform.isIOS?showPlatformModalSheet(

      context: context,

      builder: (_) => PlatformWidget(
        cupertino: (_, __) => ThirdModal(userUid: uid!,doc: document,),
      ),
    ):showModalBottomSheet(
      isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => ThirdModal(userUid: uid!,doc: document,)
    );



  }
}
