import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/trans_pin.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/utils/block_text.dart';
import 'package:easy_homes/utils/encrypt.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pin_put/pin_put.dart';
class ResetTransactionPin extends StatefulWidget {
  @override
  _ResetTransactionPinState createState() => _ResetTransactionPinState();
}

class _ResetTransactionPinState extends State<ResetTransactionPin> {

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();


  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  String? rePin;
  bool progress = false;
  bool warning = false;
  bool block = false;

  Widget animatingBorders() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: kWhiteColor,
      border: Border.all(color: kTextFieldBorderColor),
      borderRadius: BorderRadius.circular(15),

    );
    return PinPut(

      autofocus: true,
      //validator: Variables.validatePin,
      obscureText: '*',
      fieldsCount: 6,
      eachFieldHeight: 20,
      onSubmit: (String pine) {
        Variables.mobilePin = pine;
      },
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration:
      pinPutDecoration.copyWith(borderRadius: BorderRadius.circular(20)),
      pinAnimationType: PinAnimationType.slide,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: kTextFieldBorderColor,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return progress == true?Loading():SafeArea(child: PlatformScaffold(

        appBar: PlatformAppBar(
          backgroundColor: kWhiteColor,
          leading: GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Icon(Icons.arrow_back, size:30,color: kBlackColor,)),
          title:  TextWidget(
            name: kRestPin.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              spacer(),

              LogoDesign(),

              spacer(),

              TextWidget(
                name: 'Enter Your old Transaction Pin',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: animatingBorders(),
              ),


              spacer(),

              GestureDetector(
                onTap: () {
                  _pinPutController.text = '';

                },
                child: Text(kEditMobileClear,
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kLightBrown,
                  ),
                ),
              ),
              spacer(),
              GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  Constant1.showTxnInfo(context: context, submit: (){}, text1: 'Transaction Pin'.toUpperCase(), text2: 'Hi ${Variables.userFN!}, $kForgotTxn2', text3: 'OK, Got it');
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(kForgotTxn,

                      style: GoogleFonts.pacifico(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(
                            kFontSize14, ),
                        color: kLightBlue,
                      ),
                    ),
                  ),
                ),
              ),


              warning?
              WarningText():Text(''),

              block == true ?
              BlockText():Text(''),


              spacer(),
              BtnSecond(title: kVerify, nextFunction: () {
                moveToNext();
              }, bgColor: kDoneColor,),



              spacer(),

            ],
          ),
        )));
  }

  void moveToNext() {

    //decript pin

    final decrypted = Encryption.decryptAES(Variables.currentUser[0]['tx']);
print(decrypted);

    if ((_pinPutController.text.length == null) || (_pinPutController.text.length == 0)) {
      Fluttertoast.showToast(
          msg: 'Please enter your old Transaction pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);

    }else if (decrypted != _pinPutController.text ){
      Variables.counter++;
      if(Variables.counter == 3){
        setState(() {
          warning = true;
        });
      }


      Fluttertoast.showToast(
          msg: 'Sorry incorrect pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);


      if(Variables.counter >= 4) {
//        block account

        try {
          FirebaseFirestore.instance.collection('userReg')
              .doc(Variables.currentUser[0]['ud'])
              .set({
            'bl': true,
          },SetOptions(merge: true));
          setState(() {
            warning = false;
            block = true;
          });

          Future.delayed(const Duration(seconds: 7), () {
            Navigator.pushReplacement(context, PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: SupportScreen()));
          });
        } catch (e) {
        VariablesOne.notifyFlutterToastError(title: kError);
        }
      }



    }else{
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: TransactionPin()));
    }
  }
}
