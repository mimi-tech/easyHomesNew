import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/funds/bankAccount/bank_details.dart';
import 'package:easy_homes/funds/bankAccount/flutterwave_payment_option.dart';
import 'package:easy_homes/funds/bankAccount/transfer_money.dart';
import 'package:easy_homes/funds/bankAccount/ussd_payment.dart';
import 'package:easy_homes/funds/cardDeposit.dart';

import 'package:easy_homes/funds/fund_appbar.dart';
import 'package:easy_homes/funds/store.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PayWithBankAccountFlutterWave extends StatefulWidget {
  @override
  _PayWithBankAccountFlutterWaveState createState() => _PayWithBankAccountFlutterWaveState();
}

class _PayWithBankAccountFlutterWaveState extends State<PayWithBankAccountFlutterWave> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: CardAppBar(),

        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:12.0,right: 12.0),
          child: Center(
            child: AnimationSlide(
              title: TextWidgetAlign(
                name: 'How would you like to fund your wallet?'.toUpperCase(),
                textColor: kTextColor,
                textSize: 20,
                textWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        FlutterwavePaymentOption(
          handleClick: (){
            if(Variables.currentUser[0]['pay'] == true){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardListStore()));

            }else{
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardDeposit()));

            }
          },
          buttonText: "Card",
          buttonColor: kLightBrown,
          buttonIcon: 'assets/imagesFolder/card_logo.svg',
        ),


        FlutterwavePaymentOption(
          buttonColor: kDoneColor,
          handleClick: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CustomerBankDetails()));

          },
          buttonText: "Account",
          buttonIcon:'assets/imagesFolder/bank.svg',

        ),

        FlutterwavePaymentOption(
          handleClick: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: AccountDetailsTransfer()));

          },
          buttonText: "Bank transfer",
          buttonColor: kDarkBlue,
          buttonIcon: 'assets/imagesFolder/card_logo.svg',
        ),

        FlutterwavePaymentOption(
          handleClick: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentWithUSSD()));

          },
          buttonText: "USSD",
          buttonColor: kGreenColor,
          buttonIcon: 'assets/imagesFolder/card_logo.svg',
        ),

      ],
    )));
  }
}
