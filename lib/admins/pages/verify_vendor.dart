import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/screens/drive.dart';
import 'package:easy_homes/vendorReg/screens/home.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
class VerifyVendor extends StatefulWidget {
  @override
  _VerifyVendorState createState() => _VerifyVendorState();
}

class _VerifyVendorState extends State<VerifyVendor> {
  Widget spacer(){
    return SizedBox(height:MediaQuery.of(context).size.height * 0.005);
  }
  TextEditingController _email = TextEditingController();
  Color btnColor = kTextFieldBorderColor;
  String firstName = '';
  String lastName = '';
  String? uid;
  String? email;
  bool checkEmail = false;
  bool progress = false;
  bool checkLocation = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 600),
      curve: Curves.decelerate,
      child: Column(
        children: <Widget>[
          spacer(),


          spacer(),checkEmail==true?TextWidgetAlign(name: 'Confirmed ongoing vendor'.toUpperCase(),
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

                  text: 'Do you want to register ',

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
                      ),),

              TextSpan(text: ' as your vendor?',
              style: GoogleFonts.oxanium(
                fontWeight: FontWeight.normal,
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kTextColor,
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
          spacer(),
          progress == true?PlatformCircularProgressIndicator(): checkEmail == true?Text(''):BtnSecond(title: kVerify, nextFunction: () {


            moveToNext();
          }, bgColor: btnColor,),


          checkEmail == true? checkLocation == true?PlatformCircularProgressIndicator():BtnSecond (title: 'Proceed', nextFunction: () {


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
    } else {
      bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_email.text);
      if (emailValid == true) {
        setState(() {
          progress = true;
        });

        try {
          final QuerySnapshot result = await FirebaseFirestore.instance.collection('userReg')
              .where('email', isEqualTo: email!.trim())


              .get();
          final List <DocumentSnapshot> documents = result.docs;
                if (documents.length == 0) {
            setState(() {
              progress = false;
            });
            Fluttertoast.showToast(
                msg: 'Sorry this user does not exist',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 10,
                backgroundColor: kBlackColor,
                textColor: kRedColor);
          } else {
           for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {AdminConstants.vendorCollection.clear();
                AdminConstants.vendorCollection.add(document.data());
                firstName = document['fn'];
                lastName = document['ln'];
                uid = document['ud'];
                Variables.userPix = document['pix'];
                progress = false;
                checkEmail = true;
              });
            }
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: kError,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 10,
              backgroundColor: kBlackColor,
              textColor: kRedColor);
        }
      }

      else {
        Fluttertoast.showToast(
            msg: kEmailError2,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }
  }

  Future<void> nextModal() async {
    if((AdminConstants.vendorCollection[0]['ven'] == true)
        ||(AdminConstants.vendorCollection[0]['sa'] ==  true)

    ||(AdminConstants.vendorCollection[0]['reg'] ==  true)
    ||(AdminConstants.vendorCollection[0]['cat'] ==  AdminConstants.admin)
    ||(AdminConstants.vendorCollection[0]['cat'] ==  AdminConstants.business)
    ||(AdminConstants.vendorCollection[0]['cat'] ==  AdminConstants.partner)
        ||(AdminConstants.vendorCollection[0]['cat'] ==  AdminConstants.owner)){
      //Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Sorry this account cannot be used as a vendor',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);

    }else {
      setState(() {
        checkLocation = false;
      });
      Navigator.pop(context);

      Navigator.push(context, PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.bottomCenter,
          child: VendorDriving()));
    }
  }
}
