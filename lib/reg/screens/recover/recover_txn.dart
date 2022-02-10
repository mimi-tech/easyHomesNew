

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/logins.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/block_text.dart';
import 'package:easy_homes/utils/encrypt.dart';
import 'package:easy_homes/utils/back_logo.dart';


import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';


import 'package:pinput/pin_put/pin_put.dart';
//import 'package:telephony/telephony.dart';

 final key = encrypt.Key.fromLength(32);
 final iv = encrypt.IV.fromLength(16);
 final encrypter = encrypt.Encrypter(encrypt.AES(key));

class RecoverTxn extends StatefulWidget {
  RecoverTxn({required this.doc});

  final List<DocumentSnapshot> doc;

  @override
  _RecoverTxnState createState() => _RecoverTxnState();
}

class _RecoverTxnState extends State<RecoverTxn> {

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
bool block = false;

late int count;
  //final Telephony telephony = Telephony.instance;





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
bool _publishModal = false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(


        body: ProgressHUDFunction(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                spacer(),

               BackLogo(),

                spacer(),

                RegText(title: kTxnText,),
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
              progress == true?
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
          ),
        )));
  }

  Future<void> moveToNext() async {
    final decrypted = Encryption.decryptAES(widget.doc[0]['tx']);
    final decryptedPas = Encryption.decryptAES(widget.doc[0]['ps']);

    if ((_pinPutController.text.length == null) || (_pinPutController.text.length == 0)) {
      VariablesOne.notifyFlutterToastError(title: 'Please enter your Transaction pin');


    }else if(decrypted == _pinPutController.text){
      Services.sendSms(
        phoneNumber: widget.doc[0]['ph'],
        message: "Password - $decryptedPas",
      );

      setState(() {
        _publishModal = false;
      });


      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
            (route) => false,
      );


    }else{

      Variables.counter++;
      if(Variables.counter == 3){
        setState(() {
          progress = true;
        });
      }


         //writeCounter();
        Fluttertoast.showToast(
            msg: 'Sorry incorrect pin',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);


      if(Variables.counter >= 4) {
//        block account

        try {
          FirebaseFirestore.instance.collection('userReg')
              .doc(widget.doc[0]['ud'])
              .set({
            'bl': true,
          },SetOptions(merge: true));
          setState(() {

            progress = false;
            block = true;
          });

          Future.delayed(const Duration(seconds: 7), () {
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                builder: (BuildContext context) => SupportScreen(),
              ),
                  (route) => false,
            );

          });

        } catch (e) {
        VariablesOne.notifyFlutterToastError(title: kError);
        }
      }

       /* String tec = 'This is more than good';
 final e = Encryption.encryptAes('hjmb');
        print(e.base16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));

        final encrypted = encrypter.encrypt(tec, iv: iv);
        final decrypted = encrypter.decrypt(encrypted, iv: iv);
        print(decrypted);
        print(encrypted.base64);*/
      }


    }



  /*Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }
*/

  /*Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      print('This is counter $contents');
      count = int.parse(contents);
      return int.parse(contents);


    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }*/

  /*Future<File> writeCounter() async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }*/

  }




