
import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/headings.dart';
import 'package:easy_homes/funds/validator.dart';

import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/withdrawal/bank_details.dart';
import 'package:easy_homes/withdrawal/bvn.dart';
import 'package:easy_homes/withdrawal/check_txn.dart';
import 'package:easy_homes/withdrawal/stored_data.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';



class WithdrawalAmount extends StatefulWidget {
  @override
  _WithdrawalAmountState createState() => _WithdrawalAmountState();
}

class _WithdrawalAmountState extends State<WithdrawalAmount> with SingleTickerProviderStateMixin {



  Widget space() {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.02,
    );
  }

  TextEditingController _amount = TextEditingController();

  late int amount;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            duration: const Duration(milliseconds: 600),
            curve: Curves.decelerate,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  space(),
                  space(),

                  WalletHeading(),
                  Divider(),
                  space(),
                  Center(
                    child: FormHeading(
                      title: 'Enter amount you want to withdrawal'.toUpperCase(),
                    ),
                  ),
                  space(),
                  Platform.isIOS ?
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
                        fontSize: ScreenUtil().setSp(kFontSize14,),
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
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: TextFormField(
                            controller: _amount,
                            autocorrect: true,
                            cursorColor: (kTextFieldBorderColor),
                            keyboardType: TextInputType.text,
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
                  space(),


                  Center(child: NewBtn(nextFunction: (){
                    Navigator.pop(context);
                    Platform.isIOS?payWithBankIos():payWithBank();}, bgColor: kLightBrown, title: 'Next')),
                  space(),
                ])));
  }

  Future<void> payWithBank() async {

    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
          var y = Variables.currentUser[0]['wal'] - amount;
      if( amount >= Variables.currentUser[0]['wal']){
        Fluttertoast.showToast(
            msg: 'Sorry insufficient funds, check your wallet balance',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }else if(y < 500){
        Fluttertoast.showToast(
            msg: "Sorry you can't leave below #500 in your wallet",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }else{
        setState(() {
          Deposit.amount = amount;
        });

        Platform.isIOS ?
        /*show ios bottom modal sheet*/
        showCupertinoModalPopup(

            context: context, builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CheckTxn()
            ],
          );
        })

            : showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            context: context,
            builder: (context) => CheckTxn()
        );



      }
    }}

  payWithBankIos() {
    Deposit.amount = int.parse(_amount.text);
    if ((_amount.text.length == 0) || (amount < 1000)) {
      VariablesOne.notifyFlutterToastError(
          title: "Amount must be more than 1000.00");
    } else {
      showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          context: context,
          builder: (context) => CheckTxn()
      );
      }



  }
  }



