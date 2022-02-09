import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/logins.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BlockUser extends StatefulWidget {
  @override
  _BlockUserState createState() => _BlockUserState();
}

class _BlockUserState extends State<BlockUser> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Column(
    children: <Widget>[
      space(),
      TextWidgetAlign(
        name: kBlockUser.toUpperCase(),
        textColor: kLightBrown,
        textSize: kFontSize,
        textWeight: FontWeight.bold,
      ),

      space(),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: '${Variables.userFN!} ${Variables.userLN} ',
            style: GoogleFonts.oxanium(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil()
                  .setSp(kFontSize, ),
              color: kDoneColor,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Do you wish for your account to be blocked? To unblock your account, you will visit any of our office or call',
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize, ),
                  color: kTextColor,
                ),
              ),

              TextSpan(
                text: '${Variables.cloud!['ph']}',
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize, ),
                  color: kDoneColor,
                ),
              )
            ]),
      ),

      space(),

      YesNoBtn(no: (){Navigator.pop(context);}, yes: (){_blockAccount();}),
      space(),

    ])));
  }

  void _blockAccount() {

    try {
      FirebaseFirestore.instance.collection('userReg').doc(Variables.currentUser[0]['ud']).set({
        'bl': true,
      },SetOptions(merge: true));
      _auth.signOut();


      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
            (route) => false,
      );
      VariablesOne.notifyFlutterToast(title: 'Account blocked Successfully');

    } catch (e) {
      VariablesOne.notifyFlutterToastError(title: kError);
    }
  }
}
