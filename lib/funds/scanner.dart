//import 'package:card_scanner/card_scanner.dart';
import 'package:credit_card_slider/card_background.dart';
import 'package:credit_card_slider/card_network_type.dart';
import 'package:credit_card_slider/credit_card_widget.dart';
import 'package:credit_card_slider/validity.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/headings.dart';
import 'package:easy_homes/funds/validator.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class CardScan extends StatefulWidget {
  @override
  _CardScanState createState() => _CardScanState();
}

class _CardScanState extends State<CardScan> {
  //late CardDetails _cardDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scanCard();
  }

  Widget space() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.02,
    );
  }
  var buffer;
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _amount = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _exp = TextEditingController();
  TextEditingController _cvv = TextEditingController();

  String amount = '0';
  String? number;
  String? exp;
  String? cvv;

  String cardNumber = '';
  String expiryDate = 'MM / YY';
  String cardHolderName = '';
  String cvvCode = 'xxx';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          child: CreditCard(
            roundedCornerRadius: 4,
            cardBackground: SolidColorCardBackground(kBlackColor),
            cardNetworkType: CardNetworkType.mastercard,
            cardHolderName: cardHolderName,
            cardNumber:buffer.toString(),

            cardHolderNameColor: kYellow,
            numberColor: kYellow,
            validityColor: kYellow,
            validity: Validity(
              validThruMonth: 1,
              validThruYear: 21,
            ),
          ),
        ),
        space(),
        space(),
        Center(
          child: TextWidgetAlign(
            name: 'Your card details'.toUpperCase(),
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
        ),
        space(),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHeading(
                  title: 'Enter the amount you want to deposit ',
                ),
                TextFormField(
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
                    amount = value!;
                  },
                  validator: Validator.validateAMount,
                ),

                space(),

                ///for card number

                FormHeading(
                  title: 'Enter your card number ',
                ),
                TextFormField(
                  controller: _number,
                  autocorrect: true,
                  cursorColor: (kTextFieldBorderColor),
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    CreditCardNumberInputFormatter()
                  ],
                  style: Fonts.textSize,
                  decoration: Variables.cardInput,
                  onSaved: (String? value) {
                    number = value;
                  },
                  validator: Validator.validateCard,
                ),

                space(),

                ///for Cvv number

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        children: [
                          FormHeading(
                            title: 'Expiring date',
                          ),
                          TextFormField(
                            controller: _exp,
                            autocorrect: true,
                            cursorColor: (kTextFieldBorderColor),
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              CreditCardExpirationDateFormatter()
                            ],
                            style: Fonts.textSize,
                            decoration: Variables.ExpInput,
                            onSaved: (String? value) {
                              exp = value;

                            },
                            validator: Validator.validateExp,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        children: [
                          FormHeading(
                            title: 'Cvv',
                          ),
                          TextFormField(
                            controller: _cvv,
                            autocorrect: true,
                            cursorColor: (kTextFieldBorderColor),
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              CreditCardCvcInputFormatter()
                              // for mobile
                            ],
                            style: Fonts.textSize,
                            decoration: Variables.cvvInput,
                            onSaved: (String? value) {
                              cvv = value;
                            },
                            validator: Validator.validateCvv,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: LocationBtn(
              nextFunction: () {
                _deposit();
              },
              bgColor: kLightBrown,
              title: 'Fund NGN ${_amount.text}'),
        ),
        space(),
      ],
        )),
    );

  }

  Future<void> scanCard() async {
    /*var cardDetails = await CardScanner.scanCard(
        scanOptions: CardScanOptions(scanCardHolderName: true, scanExpiryDate: true));

    if (!mounted)
      return;
    setState(() {
      _cardDetails = cardDetails;
    });
    print('yyyyyy$cardDetails');
    if(_cardDetails != null){

      setState(() {
        _number.text = _cardDetails.cardNumber;

        _exp.text = _cardDetails.expiryDate;
        cardHolderName =  _cardDetails.cardHolderName;

         buffer = new StringBuffer();
        for (int i = 0; i < _number.text.length; i++) {
          buffer.write(_number.text[i]);
          var nonZeroIndex = i + 1;
          if (nonZeroIndex % 4 == 0 && nonZeroIndex != _number.text.length) {
            buffer.write('  '); // Add double spaces.
          }}
        _number.text = buffer.toString();
      });
      print('ooooooooo${_cardDetails.map}');

    }else{
      print('ttttttttt$_cardDetails');

      //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CardDeposit()));
      Fluttertoast.showToast(
          msg: 'Scan failed',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kGreenColor);
    }*/


  }

  void _deposit() {}
}
