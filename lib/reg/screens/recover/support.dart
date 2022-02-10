import 'dart:io';

import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/logins.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:url_launcher/url_launcher.dart';
class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05,);
  }
  //final Telephony telephony = Telephony.instance;

  String radioItem = '';
  TextEditingController _messages = TextEditingController();
  TextEditingController _heading = TextEditingController();
  var date = DateTime.now();
  Color btnColor = kTextFieldBorderColor;
  String? message;
  String? heading;
  var currentDate = new DateTime.now();
  bool _publishModal = false;
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(

        appBar: PlatformAppBar(
          backgroundColor: kWhiteColor,
          leading:Platform.isIOS?
               PlatformIconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);},)
              :IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);},color: kBlackColor,),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                name: kSupport.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),

              VendorPix(pix: Variables.currentUser[0]['pix'], pixColor: Colors.transparent)
            ],
          ),
        ),
        body: ProgressHUDFunction(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              space(),
              LogoDesign(),
              space(),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Headings(title: kSupportText,)),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Platform.isIOS
                      ? CupertinoTextField(
                    controller: _heading,
                    autocorrect: true,

                    maxLines: null,
                    keyboardType: TextInputType.text,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    placeholderStyle: GoogleFonts.pacifico(
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),
                      color: kHintColor,
                    ),
                    placeholder: 'message heading...',
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
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Headings(title: kSupportText2,)),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Platform.isIOS
                      ? CupertinoTextField(
                    controller: _messages,
                    autocorrect: true,

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


              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: GestureDetector(

                    onTap: () async {
                      var url = "tel:${Variables.cloud!['ph']}";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: RichText(

                      text: TextSpan(text: "Don't want to send an email? ",
                          style: GoogleFonts.oxanium(
                            fontSize: ScreenUtil().setSp(
                                kFontSize14, ),
                            color: kBlackColor,
                          ),

                          children: <TextSpan>[
                            TextSpan(
                              text: 'Call support',
                              style: GoogleFonts.pacifico(
                                fontSize: ScreenUtil().setSp(
                                    kFontSize, ),
                                color: kDoneColor,
                              ),
                            ),
                          ]
                      ),


                    )),
              ),
              space(),

              Center(
                child: SizedBtn(title: 'Send', nextFunction: () {
                  sends();
                }, bgColor: btnColor,),
              ),
              GestureDetector(

                  onTap: (){
                    _auth.signOut();
                    Navigator.of(context).push
                      (MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Login here',
                        style: GoogleFonts.pacifico(
                          fontSize: ScreenUtil().setSp(
                              kFontSize, ),
                          color: kLighterBlue,
                        ),
                      ),
                    ),
                  )),
            ],
          )


          ),
        )));
  }

  Future<void> sends() async {
    if ((_messages.text.length == 0) || (_messages.text.length < 20)) {
      Fluttertoast.showToast(
          msg: 'Please your message should not be less than 20 characters',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 5,
          textColor: kRedColor);
    } else if ((_heading.text.isEmpty) || (_heading.text.length == null)) {
      Fluttertoast.showToast(
          msg: 'Please your message should have a heading',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 5,
          textColor: kRedColor);
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      setState(() {
        _publishModal = true;
      });
      // Create our message.


      Services.sendMail(
          email: Variables.email!.trim(),
          message:"<h3 style='color:orange;'>$kCompanyNames</h3>\n<p style='colors:LightGray;font-size:12px;'>${_messages.text.trim()}</p> <p style='colors:LightGray;font-size:8px;><strong style='color:darkBlue;font-size:8px;'>From: </strong>${Variables.currentUser[0]['fn']} ${Variables.currentUser[0]['fn']} </p> <p style='colors:LightGray;font-size:8px;><strong style='color:darkBlue;font-size:8px;'>Mobile: </strong>${Variables.currentUser[0]['ph']} <p style='colors:LightGray;font-size:8px;><strong style='color:darkBlue;font-size:8px;'>Email: </strong>${Variables.currentUser[0]['email']}  </p> ",
          subject: "Request to become a vendor 😀"
      );


      }


    }
  }

