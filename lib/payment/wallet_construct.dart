import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/funds/deposit_amount.dart';
import 'package:easy_homes/funds/funds_bottom.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
class WalletConstruct extends StatefulWidget {
  @override
  _WalletConstructState createState() => _WalletConstructState();
}

class _WalletConstructState extends State<WalletConstruct> {
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
    return   GestureDetector(
      onTap: (){_wallet();},
      child: Card(
        color:  kDarkBlue2,
        elevation: elevation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: <Widget>[
              space(),
              Row(
                children: <Widget>[
                  space(),

                  Variables.currentUser[0]['mp'] == kWallet?
                  IconButton(icon: Icon(
                    Icons.radio_button_checked,color: kBlackColor,
                  ), onPressed: (){})

                      :IconButton(icon: Icon(
                    Icons.radio_button_unchecked,color: kWhiteColor,
                  ), onPressed: (){_wallet();}),


                  spaceWidth(),
                  SvgPicture.asset('assets/imagesFolder/wallet3.svg'),
                  spaceWidth(),
                  TextWidget(
                    name: kWallet,
                    textColor: kWhiteColor,
                    textSize: 22,
                    textWeight: FontWeight.w400,
                  ),
                  space(),
                ],
              ),

              space(),
              space(),



              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 30),
                      child: GestureDetector(
                          onTap: (){
                            Platform.isIOS ?
                            /*show ios bottom modal sheet*/
                            showCupertinoModalPopup(

                                context: context, builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                actions: <Widget>[
                                  FundWallet()
                                  //DepositAmount()
                                ],
                              );
                            })

                                : showModalBottomSheet(
                                isDismissible: false,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => FundWallet()
                            );

                          },
                          child: SvgPicture.asset('assets/imagesFolder/fund_btn.svg'))),
                  Spacer(),
                  RichText(
                    text: TextSpan(
                        text: (kWallet.toUpperCase()),
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kSkyBlue,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${' bal'.toLowerCase()} \n',
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize14, ),
                              color: kSkyBlue,
                            ),
                          ),
                          TextSpan(
                            text: ('#${VariablesOne.numberFormat.format(Variables.currentUser[0]['wal']).toString()}'),
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize14, ),
                              color: kWhiteColor,
                            ),
                          )


                        ]),
                  )

                ],
              ),
              space(),
              space(),
            ],
          ),
        ),
      ),
    );

  }
  void _wallet() {

    try{
      FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid).set({
        'mp':kWallet,
      },SetOptions(merge: true));
      setState(() {
        Variables.currentUser[0]['mp'] = kWallet;
        Variables.mop = kWallet;
      });

      Navigator.pop(context);
      BotToast.showSimpleNotification(title: '$kPMtext $kWallet',
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
