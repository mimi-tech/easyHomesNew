//import 'package:card_scanner/card_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/number_filter.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderNewCardForm extends StatefulWidget {
  OrderNewCardForm({ required this.takeMoney});
  final Function takeMoney;
  @override
  _OrderNewCardFormState createState() => _OrderNewCardFormState();
}

class _OrderNewCardFormState extends State<OrderNewCardForm> {
  var _formKey = new GlobalKey<FormState>();
  //var numberController = new TextEditingController();
  var _paymentCard = PaymentCardDetails();
  var _autoValidate = false;
  var buffer;
  TextEditingController _exp = TextEditingController();
  TextEditingController _cvv = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController numberController =  TextEditingController();

  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05,);
  }
 //late CardDetails _cardDetails;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(
          decoration: BoxDecoration(
            color: kLightBrown,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  topLeft: Radius.circular(6),

              )
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextWidgetAlign(
                    name: 'Card details'.toUpperCase(),
                    textColor: kBlackColor,
                    textSize: 20,
                    textWeight: FontWeight.bold,
                  ),
                ),


                Flexible(
                  fit: FlexFit.loose,
                  child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:  Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topRight,
                                child: TextWidgetAlign(
                                  name: 'Scan card'.toUpperCase(),
                                  textColor: kLightBlue,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.normal,
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: numberController,
                                autocorrect: true,
                                cursorColor: (kTextFieldBorderColor),
                                textInputAction: TextInputAction.next,

                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(19),
                                  CardNumberInputFormatter()
                                ],
                                style: Fonts.countSize,
                                //controller: numberController,
                                decoration:InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:kWhiteColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.cyan),
                                  ),


                                  prefixIcon:  CardUtils.getCardIcon(_paymentCard.type!),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: (){scanCard();},
                                        child: SvgPicture.asset('assets/imagesFolder/photograph.svg',height: 20,width: 20,color: kBlackColor,)),
                                  ),

                                  labelText: 'Card number',
                                  labelStyle:GoogleFonts.oxanium(
                                    fontSize: ScreenUtil().setSp(kFontSize14, ),
                                    color: kWhiteColor,
                                  ),

                                ),

                                onSaved: (String? value) {
                                  _paymentCard.number = CardUtils.getCleanedNumber(value!);
                                  VariablesOne.paymentCardNumber = CardUtils.getCleanedNumber(value);
                                },
                                onChanged: (String value) {
                                  _paymentCard.number = CardUtils.getCleanedNumber(value);
                                  VariablesOne.paymentCardNumber = CardUtils.getCleanedNumber(value);
                                  },
                                validator: CardUtils.validateCardNum,
                              ),


                              space(),



                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.3,

                                    child: TextFormField(
                                      controller: _exp,
                                      autocorrect: true,
                                      textInputAction: TextInputAction.next,
                                      style: Fonts.countSize,

                                      cursorColor: (kTextFieldBorderColor),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,

                                        LengthLimitingTextInputFormatter(4),
                                        CardMonthInputFormatter()
                                      ],
                                      decoration:InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color:kWhiteColor),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.cyan),
                                        ),

                                        labelText: 'MM / YY',
                                        labelStyle:GoogleFonts.oxanium(
                                          fontSize: ScreenUtil().setSp(kFontSize14, ),
                                          color: kWhiteColor,
                                        ),

                                      ),



                                      validator: CardUtils.validateDate,
                                      onChanged: (value) {
                                        List<int> expiryDate = CardUtils.getExpiryDate(value);
                                        _paymentCard.month = expiryDate[0];
                                        _paymentCard.year = expiryDate[1];

                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.3,

                                    child: TextFormField(
                                      controller: _cvv,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,

                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      style: Fonts.countSize,

                                      decoration:InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color:kWhiteColor),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.cyan),


                                        ),
                                        labelText: 'CVV',
                                        labelStyle:GoogleFonts.oxanium(
                                          fontSize: ScreenUtil().setSp(kFontSize14, ),
                                          color: kWhiteColor,
                                        ),
                                      ),



                                      validator: CardUtils.validateCVV,
                                      keyboardType: TextInputType.number,

                                      onSaved: (value) {
                                        _paymentCard.cvv = int.parse(value!);
                                      },

                                    ),
                                  ),
                                ],
                              ),
                              space(),


                            ],
                          )
                      )
                  ),
                ),

                NewBtn(nextFunction:() {

                  _checkCard();
                },
                  bgColor: kBlackColor,
                  title: 'Add',
                ),



              ]),
        ),
      ),
    );

  }

  Future<void> scanCard() async {
   /* var cardDetails = await CardScanner.scanCard(
        scanOptions: CardScanOptions(scanCardHolderName: true, scanExpiryDate: true));

    if (!mounted)
      return;
    setState(() {
      _cardDetails = cardDetails;
    });
    if(_cardDetails != null){

      setState(() {
        numberController.text = _cardDetails.cardNumber;

        _exp.text = _cardDetails.expiryDate;

        buffer = new StringBuffer();
        for (int i = 0; i < numberController.text.length; i++) {
          buffer.write(numberController.text[i]);
          var nonZeroIndex = i + 1;
          if (nonZeroIndex % 4 == 0 && nonZeroIndex != numberController.text.length) {
            buffer.write('  '); // Add double spaces.
          }}
        numberController.text = buffer.toString();
      });

    }*/
  }

  void _checkCard() {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
VariablesOne.notifyFlutterToastError(title: 'Please fill all the fields');
    } else {
      form.save();

    setState(() {
        Variables.currentUser[0]['ccn'] = numberController.text.trim();
        Variables.currentUser[0]['ccv'] = _cvv.text.trim();
        Variables.currentUser[0]['cyr'] = _paymentCard.year;
        Variables.currentUser[0]['cmt'] = _paymentCard.month;
        Variables.currentUser[0]['ls'] = _paymentCard.number!.substring(0,6);
      });

    widget.takeMoney();

    //add the card to db
     //saveCardToDB();
    }
  }


}
