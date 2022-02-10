import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/comment_modal.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/rating_construct.dart';

import 'package:easy_homes/admins/pages/activity.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/admins/transactions/paymentList.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/encrypt.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';


class GetMyTxn extends StatefulWidget {
  @override
  _GetMyTxnState createState() => _GetMyTxnState();
}

class _GetMyTxnState extends State<GetMyTxn> {
  TextEditingController _email = TextEditingController();
  Color btnColor = kTextFieldBorderColor;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  String firstName = '';
  String lastName = '';
  String? uid;
  String? email;
  bool checkEmail = false;
  bool progress = false;
late DocumentSnapshot document;
     String successText= '';
  int? randomNumber;
  static String username = Variables.cloud!['em'];
  static String password = Variables.cloud!['ps'];
  final smtpServer = gmail(username, password);
bool _publishModal= false;
  //final Telephony telephony = Telephony.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //PageConstants.allVendorCount.clear();
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: PageAddVendor(
            block: kWhiteColor,
            cancel: kWhiteColor,
            rating: kYellow,
            addVendor: kWhiteColor,
          ),

          appBar:SearchBottomAdminAppBar(title: 'Transaction Pin'.toUpperCase(),),

          body:ProgressHUDFunction(
            inAsyncCall: _publishModal,
            child: CustomScrollView(
                slivers: <Widget>[
                  SilverAppBarComments(
                    block: kBlackColor,
                    editPin: kYellow,
                    remove: kBlackColor,
                    suspend: kBlackColor,

                  ),

                  SliverList(
                      delegate: SliverChildListDelegate([
                        spacer(),


                        spacer(),checkEmail==true?TextWidgetAlign(name: 'Confirmed Customer'.toUpperCase(),
                          textColor: kLightBrown,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,): TextWidgetAlign(name: kUserEmail.toUpperCase(),
                          textColor: kLightBrown,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,),

                        spacer(),
                        firstName == ''? Text(''): Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(

                                text: 'Do you want to reset transaction pin for ',

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
                                          kFontSize, ),
                                      color: kDoneColor,
                                    ),),

                                  TextSpan(text: document['ph'],
                                    style: GoogleFonts.oxanium(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(
                                          kFontSize, ),
                                      color: kDarkRedColor,
                                    ),)
                                ]
                            ),
                          ),
                        ),
                        spacer(),

                        checkEmail == true?Container():Container(
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
                                email = value;
                                if (email == '') {
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
                                email = value;
                                if (email == '') {
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
                        spacer(),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextWidgetAlign(
                            name: kNoteTxn,
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),
                        ),


                        spacer(),
                        progress?Center(child: PlatformCircularProgressIndicator()): checkEmail?Column(
                          children: [
                            NewBtn(title: 'Send Pin via SMS', nextFunction: () {


                              sendPinSms();
                            }, bgColor: kDoneColor,),

                            spacer(),

                            NewBtn(title: 'Send Pin via Email', nextFunction: () {


                              sendPinEmail();
                            }, bgColor: kGreenColor,),
                          ],
                        ):BtnThird(title: 'Get user', nextFunction: () {moveToNext();}, bgColor: btnColor,),



                        spacer(),
                        spacer(),
                        spacer(),

                        TextWidgetAlign(
                          name: successText,
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        ),
                        spacer(),



                      ])),
                ]),
          ),
        ));
  }

  Future<void> moveToNext() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    /*check if this email already exist*/

    if ((Variables.email == null) || (Variables.email == '')) {
      Fluttertoast.showToast(
          msg: kMobileError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }  else {
      setState(() {
        progress = true;
      });

      try{
        final QuerySnapshot result = await FirebaseFirestore.instance.collection('userReg').where('email', isEqualTo: email!.trim()).get();
        final List <DocumentSnapshot> documents = result.docs;
        if(documents.length == 0){
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
           for (document in documents) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            setState(() {
              firstName = data['fn'];
              lastName = data['ln'];
              uid = data['ud'];
              progress = false;
              checkEmail = true;
            });
          }

        }
      }catch(e){
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }



    }

  }

  Future<void> sendPinSms() async {
    setState(() {
      _publishModal = true;
    });
    String msg;
    String phoneNo;
    Random random = new Random();
    randomNumber = random.nextInt(1000000);
    //final bool? result = await telephony.requestPhoneAndSmsPermissions;
    //bool? canSendSms = await telephony.isSmsCapable;
    msg = 'Your new pin $randomNumber';
    phoneNo =  document['ph'];

    /*if ((result!) && (canSendSms!)) {

      try{
        telephony.sendSms(
            to: phoneNo,
            message: msg,
        );
        Future.delayed(const Duration(seconds: 10), () async {
          _saveNewTxn();

          VariablesOne.notify(title: "Your new pin has been sent to you via sms");
        });

      }catch(e){
        setState(() {
          _publishModal = false;
        });
        VariablesOne.notifyErrorBot(title: kError);
        successText = 'Pin reset is not successful';
      }

    }*/
  }

  Future<void> sendPinEmail() async {
    setState(() {
      _publishModal = true;
    });
    Random random = new Random();
    randomNumber  = random.nextInt(1000000);
    String msgHtml = "<h3 style='color:orange;'>SOSURE GAS</h3>\n<p style='colors:LightGray;font-size:14px;'>Dear <strong style='color:darkBlue;'>${Variables.userFN!} ${Variables.userLN}.</strong>Your new transaction pin is </p><p style='colors:orange;font-size:24px;'> $randomNumber </p><p><span style='color:green;'>Note:</span> Do not allow anyone to see your transaction pin. Thanks</p>";
// Create our message.
    final message = Message()
      ..from = Address(username, kSosure)
      ..recipients.add(document['email'])
      ..subject = 'New Transaction Pin 😀'
      ..html = msgHtml;
    try {
      final sendTitle =  await send(message, smtpServer);
      VariablesOne.notify(title: "Your new pin has been sent to you via email");

      _saveNewTxn();
    }on MailerException catch (e) {
      setState(() {
        _publishModal = false;
        successText = 'Pin reset is not successful';
      });
      VariablesOne.notifyErrorBot(title: kError);
        print('yyyy$e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

  }


 void _saveNewTxn(){
   final encryptedTxn = Encryption.encryptAes(randomNumber.toString());

   try{
     FirebaseFirestore.instance.collection('userReg').doc(document['ud']).update({
       'tx':encryptedTxn.base64,

     });

     setState(() {
       successText = 'Pin reset is successful';
       _publishModal = false;

     });
   }catch(e){
     setState(() {
       successText = 'Pin reset is not successful';
       _publishModal = false;

     });

  }




  }
}
