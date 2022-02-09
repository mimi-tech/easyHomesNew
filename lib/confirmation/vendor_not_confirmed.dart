import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/confirmation/confirm_btn.dart';
import 'package:easy_homes/confirmation/rate_vendor.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class NotConfirmBottomSheet extends StatefulWidget {
  @override
  _NotConfirmBottomSheetState createState() => _NotConfirmBottomSheetState();
}

class _NotConfirmBottomSheetState extends State<NotConfirmBottomSheet> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Column(
          children: <Widget>[
            spacer(),
            Text(kConfirmText,
              style:GoogleFonts.oxanium(
                fontWeight:FontWeight.bold,
                fontSize: ScreenUtil().setSp(kFontSize, ),
                color: kDoneColor,
               /* shadows: [
                  Shadow(
                    blurRadius: 11.0,
                    color: kBlackColor,
                    offset: Offset(2.0, 2.0),
                  ),
                ],*/
              ),
            ),
            spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: TextWidgetAlign(
                name: 'Hi '+ Variables.userFN! + " "+ 'you mean your order have not been delivered?',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,
              ),
            ),




            spacer(),

            YesNoBtn(no:(){confirmingVendor();}, yes: (){
              Navigator.pop(context);
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.scale,
                      alignment: Alignment.bottomCenter,
                      child: SupportScreen()));
            }),

          spacer(),


          ],
        ),
      ),
    );
  }

  void confirmingVendor() {
    /*customer is saying that vendor has delivered the gas*/

    /*update the user reg to true*/
    FirebaseFirestore.instance.collection
('userReg').doc(Variables.userUid).set({
      'uc':true,

    },SetOptions(merge: true)).whenComplete(() {
      Navigator.pop(context);

      //display a dialog for rating the vendor

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: RateVendor()));
    }).catchError((onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    });
  }



}
