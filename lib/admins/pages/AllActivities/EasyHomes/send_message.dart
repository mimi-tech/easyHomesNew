import 'dart:io';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mailer/mailer.dart';


class EasySendMessage extends StatefulWidget {

  @override
  _EasySendMessageState createState() => _EasySendMessageState();
}

class _EasySendMessageState extends State<EasySendMessage> {
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05,);
  }
  String radioItem = '';
  TextEditingController _messages = TextEditingController();
  TextEditingController _heading = TextEditingController();
  var date = DateTime.now();
  Color btnColor = kTextFieldBorderColor;
  String? message;
  String? heading;
  var currentDate = new DateTime.now();
  bool _publishModal  = false;

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
        leading: PlatformIconButton(
        icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
    onPressed: () {Navigator.pop(context);}),
          title: LogoDesign(),
        ),
        body: ModalProgressHUD(
      inAsyncCall: _publishModal,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          child: Column(
            children: <Widget>[

              space(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: ( kMessageEmail2),
                    style:GoogleFonts.oxanium(
                      fontWeight:FontWeight.bold,
                      fontSize: ScreenUtil().setSp(kFontSize, ),
                      color: kLightBrown,
                    ),

                    children: <TextSpan>[
                      TextSpan(
                        text: kSosure.toString().toUpperCase(),
                        style:GoogleFonts.oxanium(
                          fontWeight:FontWeight.bold,
                          fontSize: ScreenUtil().setSp(kFontSize, ),
                          color: kDoneColor,
                        ),
                      ),
                    ]
                ),
              ),
             // space(),

              RadioListTile(
                groupValue: radioItem,
                title:TextWidget(
                  name: kVendor,
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w400,
                ),
                value: kVendor,
                onChanged: (dynamic val) {
                  setState(() {
                    radioItem = val;
                  });
                },
              ),

              RadioListTile(
                groupValue: radioItem,
                title: TextWidget(
                  name: kCustomer,
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w400,
                ),
                value: kCustomer,
                onChanged: (dynamic val) {
                  setState(() {
                    radioItem = val;
                  });
                },
              ),



              space(),



              Container(

                  child: Platform.isIOS
                      ? CupertinoTextField(
                    controller: _heading,
                    autocorrect: true,
                    maxLines: null,
                    maxLength: null,
                    keyboardType: TextInputType.text,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    placeholderStyle: GoogleFonts.pacifico(
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),
                      color: kHintColor,
                    ),
                    placeholder:  'message heading...',
                    onChanged: (String value) {
                      heading = value;

                    },
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorder),
                        border: Border.all(color: kLightBrown)),
                  )
                      : TextField(
                    controller: _heading,
                    autocorrect: true,
                    maxLines: null,
                    maxLength: null,
                    cursorColor: (kTextFieldBorderColor),
                    keyboardType: TextInputType.text,
                    style: Fonts.textSize,
                    decoration: Variables.headingInput,
                    onChanged: (String value) {
                      heading = value;

                    },
                  )),

              space(),

              Container(

                  child: Platform.isIOS
                      ? CupertinoTextField(
                    controller: _messages,
                    autocorrect: true,
                    //maxLength: null,

                    maxLines: null,
                    keyboardType: TextInputType.text,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    placeholderStyle: GoogleFonts.pacifico(
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),
                      color: kHintColor,
                    ),
                    placeholder: 'type message...',
                    onChanged: (String value) {
                      message = value;
                      if (_messages.text.length < 20) {
                        setState(() {
                          btnColor = kTextFieldBorderColor;
                        });
                      } else {
                        setState(() {
                          btnColor = kDoneColor;
                        });
                      }
                    },
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorder),
                        border: Border.all(color: kLightBrown)),
                  )
                      : TextField(
                    controller: _messages,
                    autocorrect: true,
                     maxLines: null,
                    maxLength: null,
                    cursorColor: (kTextFieldBorderColor),
                    keyboardType: TextInputType.text,
                    style: Fonts.textSize,
                    decoration: Variables.messageInput,
                    onChanged: (String value) {
                      message = value;
                      if (_messages.text.length < 20) {
                        setState(() {
                          btnColor = kTextFieldBorderColor;
                        });
                      } else {
                        setState(() {
                          btnColor = kDoneColor;
                        });
                      }
                    },
                  )),


              space(),
              SizedBtn(title:'Send',nextFunction: () {
                sends();
              }, bgColor: btnColor,),
              space(),

            ],
          ),
        ),
      ),
    )));
  }

  void sends() {
    if(_messages.text.length == 0){
      Fluttertoast.showToast(
          msg: 'Please your message should not be less than 20 characters',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);

    }else if(radioItem == ''){
      Fluttertoast.showToast(
          msg: 'Please select whom this message is for',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
      }else if (_heading.text.length == 0) {
      Fluttertoast.showToast(
          msg: 'Please your message should have a heading',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else{
  try{
    /*send message*/
    setState(() {
      _publishModal = true;
    });
   DocumentReference documentReference =  FirebaseFirestore.instance.collection
('message').doc();
   documentReference.set({
      'id':documentReference.id,
     'ms':message,
     'hd':heading,
       //'biz':widget.items[0]['biz'],
     //'ud':widget.items[0]['ud'],
     'ven':radioItem == kVendor ?true:false,
     'cus':radioItem == kCustomer?true:false,
     //'bt':radioItem == kBoth?true:false,

     'ts':DateTime.now(),
     'tss':DateTime.now().toString(),
     'tm': DateFormat('h:mm:a').format(currentDate),
     'day': DateTime.now().day,
     'mth': DateTime.now().month,
     'yr': DateTime.now().year,
    //'ph':widget.items[0]['ph'],
     'dtm':DateFormat('EEEE, d MMM, yyyy').format(date),

    });


    //send to email
    if(radioItem == kVendor) {
      FirebaseFirestore.instance
          .collection('userReg')
          .where('ven', isEqualTo: true)
          .get()
          .then((value) {
        value.docs.forEach((result) {
          //sendEmailVendor(result);
          Services.sendMail(
              email: result.data()['email'],
              message: "<h2 style='color:orange;'>$kCompanyNames</h2>\n<p style='colors:LightGray;font-size:12px;'>${_messages.text.trim()}</p>",
              subject: '${_heading.text.trim()} 😀'
          );
        });
        setState(() {
          _publishModal = false;
        });
      });
    }else{
      FirebaseFirestore.instance.collection('userReg').get().then((value) {
        value.docs.forEach((result) {
          //sendEmailVendor(result);
          Services.sendMail(
              email: result.data()['email'],
              message: "<h2 style='color:orange;'>$kCompanyNames</h2>\n<p style='colors:LightGray;font-size:12px;'>${_messages.text.trim()}</p>",
              subject: '${_heading.text.trim()} 😀'
          );
        });
        setState(() {
          _publishModal = false;
        });
      });
    }


  }catch(e){
    setState(() {
      _publishModal = false;
    });
  VariablesOne.notifyFlutterToastError(title: kError);
  }

  }
    }

  // Future<void> sendEmailVendor(QueryDocumentSnapshot<Map<String, dynamic>> result)  async {
  //   Services.sendMail(
  //       email: result.data()['email'],
  //       message: "<h2 style='color:orange;'>$kCompanyNames</h2>\n<p style='colors:LightGray;font-size:12px;'>${_messages.text.trim()}</p>",
  //       subject: '${_heading.text.trim()} 😀'
  //   );
  // }


}




