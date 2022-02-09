import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/reset_trans_pin.dart';
import 'package:easy_homes/dashboard/trans_pin.dart';
import 'package:easy_homes/dimes/dimen.dart';
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

class CreateUnblockedPin extends StatefulWidget {
  @override
  _CreateUnblockedPinState createState() => _CreateUnblockedPinState();
}

class _CreateUnblockedPinState extends State<CreateUnblockedPin> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
bool progress = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
                child: AnimatedPadding(
                    padding: MediaQuery.of(context).viewInsets,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.decelerate,
                    child: Column(children: <Widget>[
                      spacer(),
                      Text(
                        'Hello ${Variables.userFN!.toUpperCase()}',
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize2, ),
                          color: kDoneColor,

                        ),
                      ),
                      spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: Text(kunBlockText,
                            textAlign: TextAlign.justify,
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize, ),
                            color: kTextColor,

                          ),
                        ),
                      ),
                      spacer(),
                      progress == true?Center(child: PlatformCircularProgressIndicator()):Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: kRadioColor,
                            onPressed: () {_noThanks();},
                            child: TextWidget(
                              name: 'No, Thanks',
                              textColor: kWhiteColor,
                              textSize: kFontSize,
                              textWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          RaisedButton(
                            color: kLightBrown,
                            onPressed: () {_createPin();},
                            child: TextWidget(
                              name: 'Create new Pin',
                              textColor: kWhiteColor,
                              textSize: kFontSize,
                              textWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      spacer(),
                    ])));
  }

  void _noThanks() {
    /*update blt to false meaning the user dont want to create a new pin*/

    setState(() {
      progress  = true;
    });
   try{
     FirebaseFirestore.instance.collection
('userReg').doc(Variables.userUid).update({
       'blt':false,
     });
     setState(() {
       progress  = false;
     });
     Navigator.pop(context);
   }catch(e){
     setState(() {
       progress  = false;
     });
     Fluttertoast.showToast(
         msg: kError,
         toastLength: Toast.LENGTH_LONG,
         timeInSecForIosWeb: 5,
         backgroundColor: kBlackColor,
         textColor: kRedColor);
   }
  }

  void _createPin() {
    setState(() {
      progress  = true;
    });
    try{
      FirebaseFirestore.instance.collection
('userReg').doc(Variables.userUid).update({
        'blt':false,
      });
      setState(() {
        progress  = false;
      });
      Navigator.pop(context);
      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: TransactionPin()));

    }catch(e){
      setState(() {
        progress  = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }
}
