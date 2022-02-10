import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/block_text.dart';
import 'package:easy_homes/utils/encrypt.dart';
import 'package:easy_homes/withdrawal/bank_details.dart';
import 'package:easy_homes/withdrawal/stored_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

class CheckTxn extends StatefulWidget {
  @override
  _CheckTxnState createState() => _CheckTxnState();
}

class _CheckTxnState extends State<CheckTxn> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  bool warning = false;
  bool block = false;
  bool progress = false;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
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
    return SingleChildScrollView(

        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 600),
            curve: Curves.decelerate,
            child: Column(
                children: <Widget>[
                  spacer(),

                  GestureDetector(
                    onTap: (){Navigator.pop(context);},
                    child: Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.cancel,color: kRedColor,size: 30,)
                    ),
                  ),
                  spacer(),

                  TextWidgetAlign(
                    name: 'Hello ${Variables.userFN! } ${Variables.userLN }'.toUpperCase(),
                    textColor: kLightBrown,
                    textSize: 22,
                    textWeight: FontWeight.bold,
                  ),


                  spacer(),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: TextWidgetAlign(
                      name: kTxnText,
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                  spacer(),

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
                  warning == true?
                  WarningText():Text(''),

                  block == true ?
                  BlockText():Text(''),

                  progress == true?Center(child: PlatformCircularProgressIndicator()): BtnSecond(title: 'Next', nextFunction: () {

                    moveToNext();
                  }, bgColor: kDoneColor,),



                  spacer(),



                ]
            )
        )
    );
  }

  void moveToNext() {
    //decript pin

    final decrypted = Encryption.decryptAES(Variables.currentUser[0]['tx']);


    if ((_pinPutController.text.length == null) || (_pinPutController.text.length == 0)) {
      Fluttertoast.showToast(
          msg: 'Please enter your Transaction pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    } else if (decrypted != _pinPutController.text) {
      Variables.counter++;
      if (Variables.counter == 3) {
        setState(() {
          warning = true;
        });
      }


      Fluttertoast.showToast(
          msg: 'Sorry incorrect pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);


      if (Variables.counter >= 4) {
//        block account

        try {
          FirebaseFirestore.instance.collection
('userReg')
              .doc(Variables.currentUser[0]['ud'])
              .set({
            'bl': true,
          },SetOptions(merge:true));
          setState(() {
            warning = false;
            block = true;
          });

          Future.delayed(const Duration(seconds: 7), () {
            Navigator.pushReplacement(context, PageTransition(
                type: PageTransitionType.fade,
                alignment: Alignment.bottomCenter,
                child: SupportScreen()));
          });
        } catch (e) {
        VariablesOne.notifyFlutterToastError(title: kError);
        }
      }
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      //let the user now withdraw

      if(Variables.currentUser[0]['bAN'] == null){

        //prompt the user to enter his txn pin

             Navigator.pop(context);

        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: UserWithdrawalDetails()));

      }else{
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StoredWithdrawalDetails()));

      }



    }}}
