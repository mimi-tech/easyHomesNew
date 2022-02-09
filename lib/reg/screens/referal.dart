import 'dart:io';

import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/email.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';

class RefralScreen extends StatefulWidget {
  @override
  _RefralScreenState createState() => _RefralScreenState();
}

class _RefralScreenState extends State<RefralScreen> {
  TextEditingController _referal = TextEditingController();
bool checkedValue = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool bgImage = false;

  bool _publishModal = false;
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);

  String get filePath => 'profilePix/${DateTime.now()}';
  double percent = 0.6;
  Widget indicator() {
    return Platform.isIOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }
  Color btnColor = kTextFieldBorderColor;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

 late  DocumentSnapshot result;


  @override
  Widget build(BuildContext context) {


    return SafeArea(
        child: PlatformScaffold(
body: ModalProgressHUD(
  inAsyncCall: _publishModal,
  child:   WillPopScope(
    onWillPop: () => Future.value(false),
    child: SingleChildScrollView(
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
              child: PlatformIconButton(
                  icon: Icon(Icons.arrow_back_ios,size: 30,),
                  onPressed: (){
                    Navigator.pop(context);
                  }
              ),
            ),
          ),
          spacer(),
          Center(child: SvgPicture.asset('assets/imagesFolder/email.svg')),
          RegText(title: kReferal,),
          spacer(),

          Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: Platform.isIOS
                  ? CupertinoTextField(
                controller: _referal,
                autocorrect: true,
                autofocus: true,
                maxLines: null,
                keyboardType: TextInputType.text,
                cursorColor: (kTextFieldBorderColor),
                style: Fonts.textSize,
                placeholderStyle: GoogleFonts.oxanium(
                  fontSize: ScreenUtil().setSp(
                      kFontSize, ),
                  color: kHintColor,
                ),
                placeholder: 'Referral Code',
                onChanged: (String value) {
                  Variables.referal = value;
                  if (Variables.referal == '') {
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
                controller: _referal,
                autocorrect: true,
                autofocus: true,
                maxLines: null,
                cursorColor: (kTextFieldBorderColor),
                keyboardType: TextInputType.text,
                style: Fonts.textSize,
                decoration: Variables.RferialInput,
                onChanged: (String value) {
                  Variables.referal = value;
                  if (Variables.referal == '') {
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
          BtnSecond(title: kVerify, nextFunction: () {
            moveToNext();
          }, bgColor: btnColor,),

          spacer(),
          RaisedButton(
            onPressed: (){
              VariablesOne.skip = true;
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EmailScreen()));



            },
            color:kDoneColor,
            child: Text('Skip',

              style:GoogleFonts.oxanium(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(kFontSize, ),
                color: kWhiteColor,
              ),
            ),

          ),

        ],
      ),
    ),
  ),
),
        )

    );
  }

  Future<void> moveToNext() async {
    /*check if mobile number is not empty*/

    if ((Variables.referal == null) || (Variables.referal == '')) {
      Fluttertoast.showToast(
          msg: kReferalText,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {

      /*check if email exist in database*/
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      setState(() {
        _publishModal = true;
      });
      try {
        final QuerySnapshot data =  await FirebaseFirestore.instance.collection('userReg')

            .where('ref', isEqualTo: Variables.referal!.trim())
            .get();

        final List<DocumentSnapshot> doc = data.docs;

        if(doc.length == 0){
          setState(() {
            _publishModal = false;
          });
          Fluttertoast.showToast(
              msg: 'Sorry invalid referral code',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: kBlackColor,
              textColor: kRedColor);
        }else {
          VariablesOne.skip = false;

          VariablesOne.docRef = doc;
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EmailScreen()));
        }
      }catch (e){
        setState(() {
          _publishModal = false;
        });
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }
  }
}



