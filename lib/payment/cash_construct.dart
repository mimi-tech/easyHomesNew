import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/transfer_modal.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CashConstruct extends StatefulWidget {
  @override
  _CashConstructState createState() => _CashConstructState();
}

class _CashConstructState extends State<CashConstruct> {

  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  Widget spaceWidth() {
    return SizedBox(width: MediaQuery
        .of(context)
        .size
        .width * 0.05);
  }
  var itemsData = <dynamic>[];

  double elevation = 10.0;
  double horizontal = 10.0;
  double left = 70.0;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){_cash();},

      child: Card(
        elevation: elevation,
        color: kGreen2,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              space(),
              Row(
                children: <Widget>[
                  space(),


                  Variables.currentUser[0]['mp'] == kCash?
                  IconButton(icon: Icon(
                    Icons.radio_button_checked,color: kBlackColor,
                  ), onPressed: (){})

                      :IconButton(icon: Icon(
                    Icons.radio_button_unchecked,color: kWhiteColor,
                  ), onPressed: (){_cash();}),

                  spaceWidth(),
                  SvgPicture.asset('assets/imagesFolder/naira.svg'),
                  spaceWidth(),

                  space(),
                ],
              ),
              space(),
              space(),
              GestureDetector(
                  onTap: (){_gotoTransfer();},
                  child: Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setSp(30)),

                      child: SvgPicture.asset('assets/imagesFolder/trans_btn.svg'))),

              space(),
              space(),
            ],
          ),
        ),
      ),
    );

  }
  void _gotoTransfer() {

    Platform.isIOS
        ? showPlatformModalSheet(
      context: context,
      builder: (_) => PlatformWidget(
        cupertino: (_, __) => TransferModal(),
      ),
    )
        : showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) => TransferModal());
  }

  void _cash() {
    try{
      FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid).set({
        'mp':kCash,
      },SetOptions(merge: true));
     setState(() {
       Variables.currentUser[0]['mp'] = kCash;
       Variables.mop = kCash;

     });
      Navigator.pop(context);
      BotToast.showSimpleNotification(title: '$kPMtext $kCash',
          backgroundColor: kBlackColor,
          duration: Duration(seconds: 5),

          titleStyle:TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil()
                .setSp(kFontSize, ),
            color: kGreenColor,
          ));


    }catch (e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }
}
