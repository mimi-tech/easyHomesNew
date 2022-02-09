import 'dart:convert';

//import 'package:card_scanner/card_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/number_filter.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class NewCardForm extends StatefulWidget {
  NewCardForm({ this.items});
  final List<dynamic>? items;
  @override
  _NewCardFormState createState() => _NewCardFormState();
}

class _NewCardFormState extends State<NewCardForm> {
  var _formKey = new GlobalKey<FormState>();
  //var numberController = new TextEditingController();
  var _paymentCard = PaymentCardDetails();
  var _autoValidate = false;
var buffer;
  TextEditingController _exp = TextEditingController();
  TextEditingController _cvv = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController numberController =  TextEditingController();
  var binLastCardNumber;
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05,);
  }
  //late CardDetails _cardDetails;
  String? cardNumberTogether;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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


 //prefixIcon:  _paymentCard.type! == null?Text(''):CardUtils.getCardIcon(_paymentCard.type!),
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
    cardNumberTogether = CardUtils.getCleanedNumber(value);
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
              onSaved: (value) {
                List<int> expiryDate = CardUtils.getExpiryDate(value!);
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
        TextWidget(
          name: "Note: Your card won't be charged until when your gas is delivered.",
          textColor: kDoneColor,
          textSize: 12,
          textWeight: FontWeight.w500,
        ),
        NewBtn(nextFunction: (){_checkCard();}, bgColor: kBlackColor, title: 'Add'),



    ]);

  }

  Future<void> scanCard() async {
    /*var cardDetails = await CardScanner.scanCard(
        scanOptions: CardScanOptions(scanCardHolderName: true, scanExpiryDate: true));
*/
    /*if (!mounted)
      return;
    setState(() {
      _cardDetails = cardDetails;
    });*/
    /*if(_cardDetails != null){

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

  Future<void> _checkCard() async {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });

    } else {
      form.save();

      //add the card to db
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      //check if card is valid
      var binCardNumber = _paymentCard.number!.substring(0,6);
      binLastCardNumber  = _paymentCard.number!.substring(0,4);

      try{
        String url ="https://api.paystack.co/decision/bin/$binCardNumber";

        http.Response res = await http.get(Uri.parse(url),
            headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});

        if (res.statusCode == 200) {
          final Map<String,dynamic> jsonDecoded = json.decode(res.body);

          savingCard(jsonDecoded);

        }else{
          VariablesOne.notifyErrorBot(title: 'Sorry we could not resolve your card');

        }
      }catch(e){
        VariablesOne.notifyErrorBot(title: 'Sorry we could not resolve your card');

      }

  }
  }

  void savingCard(Map<String, dynamic> jsonDecoded) {
    var binCardNumber = _paymentCard.number!.substring(0,6);

    try{

      DocumentReference doc =  FirebaseFirestore.instance.collection('stack').doc();
      doc.set({
        'id':doc.id,
        'ud':Variables.currentUser[0]['ud'],
        'cc':numberController.text.trim(),
        'cv':_cvv.text.trim(),
        'mt':_paymentCard.month,
        'yr':_paymentCard.year,
        'uu':_cvv.text.trim(),
        'dt':DateTime.now(),
        'su':false,
        'ty':jsonDecoded['data']['brand'].toString().toLowerCase(),
        'fd':jsonDecoded['data']['bin'],
        'la':binLastCardNumber,
      });

      FirebaseFirestore.instance.collection
        ('userReg').doc(Variables.currentUser[0]['ud']).set({
        'pay':false,
        'ccn': numberController.text.trim(),
        'ccv':_cvv.text.trim(),
        'cyr': _paymentCard.year,
        'cmt': _paymentCard.month,
        'ls':binCardNumber,
      },SetOptions(merge: true));

      setState(() {
        Variables.currentUser[0]['ccn'] = numberController.text.trim();
        Variables.currentUser[0]['ccv'] = _cvv.text.trim();
        Variables.currentUser[0]['cyr'] = _paymentCard.year;
        Variables.currentUser[0]['cmt'] = _paymentCard.month;
        Variables.currentUser[0]['ls'] = binLastCardNumber;

        VariablesOne.showCard = false;
      });
      setState(() {
        VariablesOne.showCard = false;

      });
      Fluttertoast.showToast(
          msg: 'Card saved successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

    }catch(e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

      setState(() {
  VariablesOne.showCard = false;

});
    }
  }

}
