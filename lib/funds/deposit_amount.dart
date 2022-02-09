import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/headings.dart';
import 'package:easy_homes/funds/store.dart';
import 'package:easy_homes/funds/validator.dart';
import 'package:easy_homes/funds/cardDeposit.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class DepositAmount extends StatefulWidget {
  @override
  _DepositAmountState createState() => _DepositAmountState();
}

class _DepositAmountState extends State<DepositAmount> {
  Widget space() {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.02,
    );
  }

  TextEditingController _amount = TextEditingController();

  int amount = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Column(
    children: <Widget>[

      space(),
      space(),


      WalletHeading(),
      Divider(),
      space(),
      FormHeading(
        title: 'Enter amount'.toUpperCase(),
      ),

    Platform.isIOS?
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: CupertinoTextField(
        controller: _amount,
        autocorrect: true,
        cursorColor: (kTextFieldBorderColor),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,

        ],

        style: Fonts.textSize,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorder),
            border: Border.all(color: kLightBrown)),

        placeholderStyle: GoogleFonts.oxanium(
          fontSize: ScreenUtil().setSp(kFontSize14, ),
          color: kBlackColor.withOpacity(0.6),
        ),
        placeholder: 'Not less than NGN 1000.00',

        onChanged: (String value) {
          amount = int.parse(value);
        },
      ),
    )
        :Form(
    key: _formKey,
    autovalidateMode: AutovalidateMode.always,
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal:50.0),
    child: TextFormField(
    controller: _amount,
    autocorrect: true,
    cursorColor: (kTextFieldBorderColor),
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly
    ],


    style: Fonts.textSize,
    decoration: Variables.amountInputs,
    onSaved: (String? value) {
    amount = int.parse(value!);

    },

      onChanged: (String value) {
        amount = int.parse(value);

      },
    validator: Validator.validateAMount,
    )
    )
    ),
space(),
      SizedBtn(nextFunction: (){
        Platform.isIOS?
          _takeAmountIos()
            :
        _takeAmount();

        }, bgColor: kLightBrown, title: 'Next'.toUpperCase()),

      space(),

    ]
    )
        )
    );
  }

  void _takeAmount() {

    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        Deposit.amount = amount;
      });
      /*String v = Deposit.amount.toString().padRight(6, '0');
      print(v);*/
//check if user has a registered card
      if(Variables.currentUser[0]['pay'] == true){
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardListStore()));

      }else{
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardDeposit()));

    }}
  }

  _takeAmountIos() {
    Deposit.amount = amount;
    if((_amount.text.length == 0) || (amount < 1000)){
      VariablesOne.notifyFlutterToastError(title: "Amount must be more than 1000.00");
    }else{
      if(Variables.currentUser[0]['pay'] == true){
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardListStore()));

      }else{
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardDeposit()));

      }
    }
  }
}
