import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/reset_trans_pin.dart';
import 'package:easy_homes/dashboard/trans_pin.dart';

import 'package:easy_homes/dashboard/vendor/payment.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class TransactionBox extends StatefulWidget {
  TransactionBox({required this.bookings});

  final String bookings;

  @override
  _TransactionBoxState createState() => _TransactionBoxState();
}

class _TransactionBoxState extends State<TransactionBox> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[


        spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                spacer(),
                TextWidgetAlign(
                  name: kWalletBal.toUpperCase(),
                  textColor: kRadioColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
                spacer(),

                MoneyFormatColors(
                  color: kTextColor,
                  title: TextWidgetAlign(
                    name: '${VariablesOne.numberFormat.format(Variables.currentUser[0]['wal']).toString()}',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,
                  ),
                ),

                spacer(),
              ],
            ),
          ),
        ),
        spacer(),
      ],
    );
  }
}

class TransactionBoxSecond extends StatefulWidget {
  TransactionBoxSecond({required this.bookings});

  final String bookings;

  @override
  _TransactionBoxSecondState createState() => _TransactionBoxSecondState();
}

class _TransactionBoxSecondState extends State<TransactionBoxSecond> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        spacer(),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                spacer(),
                TextWidgetAlign(
                  name: kWalletBal.toUpperCase(),
                  textColor: kRadioColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
                MoneyFormatColors(
                  color: kTextColor,
                  title: TextWidget(
                    name: '${VariablesOne.numberFormat.format(Variables.currentUser[0]['wal']).toString()}',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextWidget(
                      name: 'Total bookings'.toUpperCase(),
                      textColor: kLightBrown,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                    TextWidget(
                      name: widget.bookings,
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ],
                ),

                spacer(),
              ],
            ),
          ),
        ),
        spacer(),
      ],
    );
  }
}



class WalletBox extends StatefulWidget {
  WalletBox({required this.title,required this.amount,});

  final String title;
  final String amount;

  @override
  _WalletBoxState createState() => _WalletBoxState();
}

class _WalletBoxState extends State<WalletBox> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 10,
        child: Column(
          children: <Widget>[
            spacer(),
            TextWidgetAlign(
              name: widget.title,
              textColor: kRadioColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),
            MoneyFormatColors(
              color: kTextColor,
              title: TextWidgetAlign(
                name: widget.amount,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
            ),


            spacer(),
          ],
        ),
      ),
    );
  }
}
