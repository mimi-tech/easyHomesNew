import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

class Constant1{
  static bool checkPickedCall = false;
  static bool checkGasService = false;
  static bool checkGasStationConfirm = false;
  static AudioPlayer audioPlayer = AudioPlayer();
  static dynamic venLat;
  static dynamic venLog;
  static bool continueWork = false;
  static bool changeGasPrize = false;
  static int rejectedGasDeliveryCount = 0;
 static  List<DocumentSnapshot>? workingDocuments;
 static  List<DocumentSnapshot>? stationDocuments;

  searchByFirstName(String searchField) {
    return FirebaseFirestore.instance.collection('userReg')
        .where('sk', isEqualTo: searchField.substring(0, 1).toUpperCase())
        .orderBy('date',descending: true)
        .get();
  }

  /*static  showRating({required submit})  {
    //popup a attachments toast
    BotToast.showAttachedWidget(
        attachedBuilder: (_) => Container(
          height: 100,
          child: Card(
            color: kBlackColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextWidgetAlign(
                    name: 'Hi ${Variables.currentUser[0]['fn']} your vendor is returning your gas cylinder 😀',
                    textColor: kLightBrown,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),

                NewBtn(nextFunction: submit, title: 'ok', bgColor: kLightBrown)
              ],
            ),
          ),
        ),
        duration: Duration(minutes: 5),
        target: Offset(520, 520));

  }*/


static YYDialog showRating({required context,required submit}) {
return YYDialog().build(context)
..width = 220
..borderRadius = 4
..gravityAnimationEnable = true
..gravity = Gravity.right
..duration = Duration(milliseconds: 600)


..text(
padding: EdgeInsets.all(18),
text: 'Ongoing Booking',
color: kLightBrown,
fontSize: 18.0,
fontWeight: FontWeight.bold,
alignment: Alignment.center,

)..text(
padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
text: 'Hello ${Variables.userFN!} your gas cylinder has been refiled. The vendor will get to you shortly.😀',
color: kTextColor,
fontSize: 18.0,
fontWeight: FontWeight.normal,
alignment: Alignment.center,
)
..doubleButton(
padding: EdgeInsets.only(right: 10.0),
gravity: Gravity.right,
text1: "OK, Got it",
color1: kDoneColor,
fontSize1: 18.0,
fontWeight1: FontWeight.bold,
  onTap1: submit,

)
..show();
}



  static YYDialog showSideDialog({required context,required yes,required no}) {
    return YYDialog().build(context)
      ..width = 250
      ..borderRadius = 4
      ..gravityAnimationEnable = true
      ..gravity = Gravity.right
      ..duration = Duration(milliseconds: 600)


      ..text(
        padding: EdgeInsets.all(18),
        text: 'Vendor work',
        color: kLightBrown,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        alignment: Alignment.center,

      )..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
        text: 'Hi ${Variables.currentUser[0]['fn']}, are you done for today or you want to take a break?',
        color: kTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        alignment: Alignment.center,
      )
      ..doubleButton(
        padding: EdgeInsets.all(8),
        gravity: Gravity.center,
        text1: 'Yes I am done',
        color1: kDoneColor,
        fontSize1: 18.0,
        fontWeight1: FontWeight.bold,
        onTap1: yes,

      )

      ..doubleButton(
        padding: EdgeInsets.all(8),
        gravity: Gravity.center,
        text1: "No I m'not done yet",
        color1: kLightBrown,
        fontSize1: 18.0,
        fontWeight1: FontWeight.bold,
        onTap1: no,

      )
      ..show();
  }



  static YYDialog showContinueBooking({required context,required submit}) {
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 4
      ..gravityAnimationEnable = true
      ..gravity = Gravity.right
      ..duration = Duration(milliseconds: 600)


      ..text(
        padding: EdgeInsets.all(18),
        text: 'Ongoing Booking',
        color: kLightBrown,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        alignment: Alignment.center,

      )..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
        text: 'Hi ${Variables.userFN!}, sorry your gas delivery was interrupted, tap continue.',
        color: kTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        alignment: Alignment.center,
      )
      ..doubleButton(
        padding: EdgeInsets.only(right: 10.0),
        gravity: Gravity.right,
        text1: "OK, Continue",
        color1: kDoneColor,
        fontSize1: 18.0,
        fontWeight1: FontWeight.bold,
        onTap1: submit,

      )
      ..show();
  }



  static YYDialog showTxnInfo({required context,required submit,required text1,required text2,required text3}) {
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 4
      ..gravityAnimationEnable = true
      ..gravity = Gravity.right
      ..duration = Duration(milliseconds: 600)


      ..text(
        padding: EdgeInsets.all(18),
        text: text1,
        color: kLightBrown,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        alignment: Alignment.center,

      )..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
        text: text2,
        color: kTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        alignment: Alignment.center,
      )
      ..doubleButton(
        padding: EdgeInsets.only(right: 10.0),
        gravity: Gravity.right,
        text1: text3,
        color1: kDoneColor,
        fontSize1: 18.0,
        fontWeight1: FontWeight.bold,
        onTap1: submit,

      )
      ..show();
  }




}
