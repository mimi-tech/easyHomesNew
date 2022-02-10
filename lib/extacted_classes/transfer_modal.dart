import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/reg/screens/transfer.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/block_text.dart';
import 'package:easy_homes/utils/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pin_put/pin_put.dart';
class TransferModal extends StatefulWidget {
  @override
  _TransferModalState createState() => _TransferModalState();
}

class _TransferModalState extends State<TransferModal> {

  Color btnColor = kTextFieldBorderColor;
  TextEditingController _email = TextEditingController();

  bool checkVerify = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }
late DocumentSnapshot document;
  bool progress = false;
  String firstName = '';
  String lastName = '';
  String? uid;
  String? email;
  bool checkEmail = false;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
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
    return SingleChildScrollView(

        child: AnimatedPadding(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            duration: const Duration(milliseconds: 600),
            curve: Curves.decelerate,
            child: checkEmail==true?
                Column(
                  children: <Widget>[
                    spacer(),
                    TextWidgetAlign(
                      name: 'Hello ${Variables.userFN!} ${Variables.userLN}',
                      textColor: kLightBrown,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(

                            text: 'You are about to do a transfer for ',

                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.normal,
                              fontSize: ScreenUtil().setSp(
                                  kFontSize, ),
                              color: kTextColor,
                            ),

                            children: <TextSpan>[
                              TextSpan(text: firstName + " "+ lastName,
                                style: GoogleFonts.oxanium(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(
                                      22, ),
                                  color: kDoneColor,
                                ),)
                            ]
                        ),
                      ),
                    ),
                    spacer(),


                    YesNoBtn(no: (){Navigator.pop(context);}, yes: (){
                      Navigator.pop(context);
                      nextModal();

                    }),


                    spacer(),
                  ],
                )

                :Column(
                children: <Widget>[
                  spacer(),
                  TextWidgetAlign(
                    name: 'Provide user Details',
                    textColor: kLightBrown,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,
                  ),
                  Divider(),

                  //spacer(),
                  TextWidget(
                    name:  'Enter your transaction pin',

                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w400,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: animatingBorders(),
                  ),
                  GestureDetector(
                    onTap: () => _pinPutController.text = '',
                    child: Text(kEditMobileClear,
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(
                            kFontSize, ),
                        color: kLightBrown,
                      ),
                    ),
                  ),
                  /*displaying Next button*/


                  spacer(),
                  TextWidget(
                    name:  'Enter the recipient email address',

                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w400,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: Platform.isIOS
                          ? CupertinoTextField(
                        controller: _email,
                        autocorrect: true,
                        autofocus: true,

                        keyboardType: TextInputType.emailAddress,
                        cursorColor: (kTextFieldBorderColor),
                        style: Fonts.textSize,
                        placeholderStyle: GoogleFonts.oxanium(
                          fontSize: ScreenUtil().setSp(
                              kFontSize, ),
                          color: kHintColor,
                        ),
                        placeholder: 'Email',
                        onChanged: (String value) {
                          Variables.email = value;
                          if ((Variables.email == '') || (_pinPutController.text.isEmpty)) {
                            setState(() {
                              btnColor = kTextFieldBorderColor;
                            });
                          } else {
                            setState(() {
                              btnColor = kLightBrown;
                            });
                          }
                        },
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorder),
                            border: Border.all(color: kLightBrown)),
                      )
                          : TextField(
                        controller: _email,
                        autocorrect: true,
                        autofocus: true,
                        cursorColor: (kTextFieldBorderColor),
                        keyboardType: TextInputType.emailAddress,
                        style: Fonts.textSize,
                        decoration: Variables.emailInput,
                        onChanged: (String value) {
                          Variables.email = value;
                          if ((Variables.email == '') || (_pinPutController.text.isEmpty)) {
                            setState(() {
                              btnColor = kTextFieldBorderColor;
                            });
                          } else {
                            setState(() {
                              btnColor = kLightBrown;
                            });
                          }
                        },
                      )),

                  warning == true?
                  WarningText():Text(''),

                  block == true ?
                  BlockText():Text(''),
                  /*displaying Next button*/

                  progress == true
                      ? PlatformCircularProgressIndicator()
                      : BtnSecond(title: kVerify, nextFunction: () {
                    moveToNext();
                  }, bgColor: btnColor,),



                  spacer(),


                ]
            )
        )
    );
  }

  Future<void> moveToNext() async {

    if ((_email.text == null) || (_email.text.length == 0)) {
      Fluttertoast.showToast(
          msg: 'Please enter the recipient email address',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    } else  if ((_pinPutController.text == null) || (_pinPutController.text.length == 0)) {
      Fluttertoast.showToast(
          msg: 'Please enter your Transaction pin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);

    }else{
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      setState(() {
        progress = true;
      });
      try {
        final QuerySnapshot result = await FirebaseFirestore.instance.collection('userReg')
            .where('email', isEqualTo: _email.text.trim())
            .get();
        final List <DocumentSnapshot> documents = result.docs;
if(documents.length != 1){
          setState(() {
            progress = false;
          });
          Fluttertoast.showToast(
              msg: 'Sorry this user does not exist',
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 10,
              backgroundColor: kBlackColor,
              textColor: kRedColor);

        }else{
          final decrypted = Encryption.decryptAES(Variables.currentUser[0]['tx']);

          //check if transaction pin is the same
          if(_pinPutController.text == decrypted) {
            for ( document in documents) {
              setState(() {
                firstName = document['fn'];
                lastName = document['ln'];
                uid = document['ud'];
                progress = false;
                checkEmail = true;
              });
            }
          }else{
            setState(() {
              progress = false;
            });
            Variables.counter++;
            if (Variables.counter == 3) {
              setState(() {
                warning = true;
              });
            }
            Fluttertoast.showToast(
                msg: 'Sorry incorrect credentials',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 10,
                backgroundColor: kBlackColor,
                textColor: kRedColor);


            if (Variables.counter >= 4) {
//        block account

              try {
                FirebaseFirestore.instance.collection('userReg')
                    .doc(Variables.currentUser[0]['ud'])
                    .set({
                  'bl': true,
                },SetOptions(merge: true));
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                setState(() {
                  warning = false;
                  block = true;
                });

                Future.delayed(const Duration(seconds: 5), () {
                  Navigator.pushReplacement(context, PageTransition(
                      type: PageTransitionType.scale,
                      alignment: Alignment.bottomCenter,
                      child: SupportScreen()));
                });
              } catch (e) {
              VariablesOne.notifyFlutterToastError(title: kError);
              }
            }

          }
        }

      }catch(e){
        print(e.toString());
      }
    }


    }

  void nextModal() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            child: TransferScreen(doc:document)));

  }
  }

