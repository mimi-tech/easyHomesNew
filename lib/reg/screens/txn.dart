
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/email.dart';
import 'package:easy_homes/reg/screens/referal.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pinput/pin_put/pin_put.dart';


class TxnScreen extends StatefulWidget {
  @override
  _TxnScreenState createState() => _TxnScreenState();
}

class _TxnScreenState extends State<TxnScreen> {

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();


  final TextEditingController _reEntertController = TextEditingController();


  final FocusNode _reEnterFocusNode = FocusNode();
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }
  Color btnColor = kTextFieldBorderColor;


  late String rePin;
  bool progress = false;
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



  Widget reEnterPin() {
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
        rePin = pine;
      },

      onChanged: (String pine){
        if(_pinPutController.text == _reEntertController.text){
          setState(() {
            btnColor = kLightBrown;
          });
        }else{
          setState(() {
            btnColor = kTextFieldBorderColor;
          });
        }
      },
      focusNode: _reEnterFocusNode,
      controller: _reEntertController,
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
    return progress == true?Loading():SafeArea(child: Scaffold(


        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              spacer(),

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    alignment: Alignment.centerLeft,
                    child: PlatformIconButton(
                        icon: Icon(Icons.arrow_back_ios,size: 30,),
                        onPressed: (){
                          Navigator.pop(context);
                        }
                    ),
                ),
              ),
              Center(child: SvgPicture.asset('assets/imagesFolder/email.svg')),
              spacer(),

              TextWidget(
                name: 'Create Your Transaction Pin',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: animatingBorders(),
              ),


              spacer(),
              TextWidget(
                name: 'Re-Enter Your Transaction Pin',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: reEnterPin(),
              ),
              spacer(),

              GestureDetector(
                onTap: () {
                  _pinPutController.text = '';
                  _reEntertController.text = '';

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

              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: TextWidget(
                  name: kTxnNote,
                  textColor: kRadioColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w400,
                ),
              ),

              spacer(),
              Btn(nextFunction: () {
                moveToNext();
              }, bgColor: btnColor,),



              spacer(),

            ],
          ),
        )));
  }

  Future<void> moveToNext() async {

    if ((_reEntertController.text.length == 0) || (_pinPutController.text.length == 0)) {
      Fluttertoast.showToast(
          msg: 'Please enter your Transaction pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);

    }else if (_reEntertController.text != _pinPutController.text ){
      Fluttertoast.showToast(
          msg: 'Pin does not match',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    }else{

Variables.txn = _pinPutController.text;



Navigator.of(context).push
  (MaterialPageRoute(builder: (context) => RefralScreen()));



    }
  }
}
