import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/screens/password.dart';
import 'package:easy_homes/reg/screens/verifyEmail.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  TextEditingController _email = TextEditingController();
  bool checkedValue = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool bgImage = false;

  bool _publishModal = false;
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);

  String get filePath => 'profilePix/${DateTime.now()}';
  double percent = 0.6;

  Widget indicator() {
    return Platform.isIOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }

  Color btnColor = kTextFieldBorderColor;

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }


  Widget mainBody() {
    if (bgImage == false) {
      return SingleChildScrollView(
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
            RegText(title: kEmail,),
            spacer(),
            Text(kEmailReceipt,
              textAlign: TextAlign.center,
              style: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kLightAshColor,
              ),
            ),
            spacer(),
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
                    if (Variables.email == '') {
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
                    if (Variables.email == '') {
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

            /*displaying Next button*/
            spacer(),
            Btn(nextFunction: () {
              moveToNext();
            }, bgColor: btnColor,),

          ],
        ),
      );
    } else {
      return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/imagesFolder/ss4.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .width * 0.08,
                    ),
                    child: SizedBox(
                      child: Image(
                        width: 200.0,
                        height: 100.0,
                        image: AssetImage(
                          'images/brand.png',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 100, top: 50, right: 100),
                    child: LinearPercentIndicator(
                      width: 157.w,
                      animation: true,
                      animationDuration: 1000,
                      lineHeight: 10.0,
                      percent: percent,

                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.red,
                    ),
                  ),
                ]
            )
          ]
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
        child: Platform.isIOS ? CupertinoPageScaffold(
            child: ProgressHUDFunction(
                inAsyncCall: _publishModal,
                progressIndicator: indicator(),
                child: mainBody())
        ) : Scaffold(
            body: _publishModal?CupertinoProgressHud() :mainBody()
        )
    );
  }

  Future<void> moveToNext() async {
    /*check if mobile number is not empty*/

    if ((Variables.email == null) || (Variables.email == '')) {
      Fluttertoast.showToast(
          msg: kEmailError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {
      //check if email is valid

      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(Variables.email!);
      if (emailValid == true) {

        //check if email do exist

        /*check if email exist in database*/
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        setState(() {
          _publishModal = true;
        });
        try {
          final QuerySnapshot data =  await FirebaseFirestore.instance.collection('userReg')

              .where('email', isEqualTo: Variables.email!.trim())
              .get();

          final List<DocumentSnapshot> doc = data.docs;

          if(doc.length == 1){
            setState(() {
              _publishModal = false;
            });
            Fluttertoast.showToast(
                msg: 'Sorry email address already exist',
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: kBlackColor,
                timeInSecForIosWeb: 10,
                textColor: kRedColor);
          }else {
            //generate the email code
            Random random = new Random();
            int emailCode = random.nextInt(900000) + 100000;
            VariablesOne.emailCode = emailCode;
            //send email code to this email

            String urlCheck = VariablesOne.emailEndpoint;
            Map<String, String> headersCheck = {
              "Content-type": "application/json",
              "authorization": "12345"//"${dotenv.env['SECRETE']}"
            };
            var bodyCheck = json.encode ({
              'email': Variables.email!.trim(),
              'message': "Your code is $emailCode",
              'subject': "EasyHomes email verification code",
            });
// make POST request
            Response responseCheck = await post(Uri.parse(urlCheck), headers: headersCheck, body: bodyCheck);
            if(responseCheck.statusCode == 200) {

              setState(() {
                _publishModal = false;
              });
              Navigator.of(context).push
                (MaterialPageRoute(builder: (context) => VerifyEmailAddress()));
            }else{

              setState(() {
                _publishModal = false;
              });
              VariablesOne.notifyFlutterToastError(title: kError);
            }


          }
        }catch(e){
          print(e);

          setState(() {
            _publishModal = false;
          });
        VariablesOne.notifyFlutterToastError(title: kError);
        }
      } else {
        Fluttertoast.showToast(
            msg: kEmailError2,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }
  }
}



