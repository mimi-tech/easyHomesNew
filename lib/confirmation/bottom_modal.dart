import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/confirmation/confirm_btn.dart';
import 'package:easy_homes/confirmation/rate_vendor.dart';
import 'package:easy_homes/confirmation/vendor_not_confirmed.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';

class ConfirmBottomSheet extends StatefulWidget {
  @override
  _ConfirmBottomSheetState createState() => _ConfirmBottomSheetState();
}

class _ConfirmBottomSheetState extends State<ConfirmBottomSheet> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  bool progress = false;
  bool progress2 = false;
  bool dismiss = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVendor();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: progress? PlatformCircularProgressIndicator()

            :Column(
          children: <Widget>[
            spacer(),
        Text(kConfirmText,
          style:GoogleFonts.oxanium(
            fontWeight:FontWeight.bold,
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kDoneColor,
            /*shadows: [
              Shadow(
                blurRadius: 18.0,
                color: kBlackColor,
                offset: Offset(2.0, 2.0),
              ),
            ],*/
          ),
        ),
       spacer(),
            TextWidget(
              name: '$kThanks ${Variables.currentUser[0]['fn']}  ${Variables.currentUser[0]['ln']}',
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.normal,
            ),


            spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: TextWidget(
                name: 'Your gas order has it been delivered by ${Variables.vendorRating!['vfn']} ${Variables.vendorRating!['vln']} ',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,
              ),
            ),

            spacer(),

            progress2?PlatformCircularProgressIndicator(): YesNoBtn(no: (){noConfirming();}, yes: (){confirmingVendor();}),

            spacer(),

          ],
        ),
      ),
    );
  }

  void confirmingVendor() {
 setState(() {
   progress2 = true;
 });
    FirebaseFirestore.instance
        .collection('userReg')
        .doc(Variables.currentUser[0]['ud'])
        .set({
      'uc': true,
    },SetOptions(merge: true));
 setState(() {
   progress2 = false;
 });
    showRatingDialog();

  }


  void noConfirming() {

    /*customer is saying that gas has not been delivered*/
    Navigator.pop(context);


    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          NotConfirmBottomSheet()
        ],
      );
    })

        : showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => NotConfirmBottomSheet()
    );

  }

  void showRatingDialog() {


    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            child: RateVendor()));



  }

  Future<void> getVendor() async {
    setState(() {
      progress = true;
      // Variables.dismiss = false;

    });
    /*customer is saying that vendor has delivered the gas*/


    final QuerySnapshot result = await  FirebaseFirestore.instance
        .collection('customer')
        .where('vid', isEqualTo:Variables.vendorUid)
        .get();
    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){

    }else {
     for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {progress = false;
        });

        Variables.vendorRating = document;

      }
  }



}}



