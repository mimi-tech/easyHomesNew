import 'dart:io';
import 'package:easy_homes/reg/constants/dialog.dart';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';

import 'package:easy_homes/utility/auth.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/utils/encrypt.dart';
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
import 'package:uuid/uuid.dart';




class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController _password = TextEditingController();
  TextEditingController _reEnterPassword = TextEditingController();

  bool checkedValue = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool bgImage = false;
  var uuid = Uuid();
  bool _publishModal = false;
  late UploadTask uploadTask;
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
   String url = '';
  String get filePath => 'profilePix/${DateTime.now()}';
  double percent = 0.6;

  Widget indicator() {
    return Platform.isIOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }

  Color btnColor = kTextFieldBorderColor;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
String? reEnterpassword;
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
                  ),),
            ),
            Center(child: SvgPicture.asset('assets/imagesFolder/unlock.svg')),
            RegText(
              title: kPassword,
            ),
            spacer(),
            Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Platform.isIOS
                    ? CupertinoTextField(
                        controller: _password,
                        autocorrect: true,
                        autofocus: true,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        cursorColor: (kTextFieldBorderColor),
                        style: Fonts.textSize,
                        placeholderStyle: GoogleFonts.oxanium(
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kHintColor,
                        ),
                        placeholder: 'Password',
                        onChanged: (String value) {
                          Variables.password = value;

                        },
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorder),
                            border: Border.all(color: kLightBrown)),
                      )
                    : TextField(
                        controller: _password,
                        autocorrect: true,
                        autofocus: true,
                  keyboardType: TextInputType.text,

                  cursorColor: (kTextFieldBorderColor),
                        obscureText: true,
                        style: Fonts.textSize,
                        decoration: Variables.passwordInput,
                        onChanged: (String value) {
                          Variables.password = value;

                        },
                      )),

            //re enter password


            spacer(),
            RegText(
              title: 'Re-enter password',
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Platform.isIOS
                    ? CupertinoTextField(
                  controller: _reEnterPassword,
                  autocorrect: true,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  cursorColor: (kTextFieldBorderColor),
                  style: Fonts.textSize,
                  placeholderStyle: GoogleFonts.oxanium(
                    fontSize: ScreenUtil()
                        .setSp(kFontSize, ),
                    color: kHintColor,
                  ),
                  placeholder: 'Re-enter Password',
                  onChanged: (String value) {
                    Variables.password = value;
                    reEnterpassword = value;
                    if ((_password.text.length < 6) || (_reEnterPassword.text != _password.text)) {
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
                  controller: _reEnterPassword,
                  autocorrect: true,
                  cursorColor: (kTextFieldBorderColor),
                  obscureText: true,
                  style: Fonts.textSize,
                  keyboardType: TextInputType.text,

                  decoration: Variables.reEnterPasswordInput,
                  onChanged: (String value) {
                   reEnterpassword = value;
                    if ((_password.text.length < 6) || (_reEnterPassword.text != _password.text)) {
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: RichText(
                text: TextSpan(
                    text: 'Note: ',
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          ScreenUtil().setSp(13, ),
                      color: kDoneColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: kPassHnt,
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(13, ),
                          color: kRadioColor,
                        ),
                      )
                    ]),
              ),
            ),

            /*displaying Next button*/
            spacer(),
            DoneBtn(
              done: () {
                moveToNext();
              },
              bgColor: btnColor,
            ),
          ],
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imagesFolder/ss4.png'),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 140.0, right: 50, left: 100),
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
          )
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
        child: Platform.isIOS
            ? CupertinoPageScaffold(
                child: ProgressHUDFunction(
                    inAsyncCall: _publishModal,
                    progressIndicator: indicator(),
                    child: mainBody()))
            : Scaffold(
                body: _publishModal?CupertinoProgressHud() :mainBody()

    ));
  }

  Future<void> moveToNext() async {
    /*check if mobile number is not empty*/

    if ((Variables.password == null) || (Variables.password == '')) {
      Fluttertoast.showToast(
          msg: kPasswordError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else if (_password.text.length <= 5) {
      Fluttertoast.showToast(
          msg: 'Password should not be less than 6 characters',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else if (_password.text != _reEnterPassword.text) {
      Fluttertoast.showToast(
          msg: 'Password does not match',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else {
      var v1 = uuid.v1();
      /*check if email exist in database*/
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      setState(() {
        bgImage = true;
      });
      try {

        final newUser = firebaseAuth.createUserWithEmailAndPassword(
            email: Variables.email!.trim(), password: Variables.password!.trim());

        newUser.catchError((e) {
          String exception = Auth.getExceptionText(e);

           setState(() {
        bgImage = false;
      });
          Fluttertoast.showToast(
              msg: exception,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackColor,
              textColor: kRedColor);
        });

        newUser.then((value) async {
          User? currentUser =  FirebaseAuth.instance.currentUser;

          if(Variables.image != null){
            Reference ref = FirebaseStorage.instance.ref().child(filePath);
            uploadTask = ref.putFile(Variables.image!);
            final TaskSnapshot downloadUrl = await uploadTask;
          url  = await downloadUrl.ref.getDownloadURL();

          }
          //hash password

          final encryptedPass = Encryption.encryptAes(_password.text);
          final encryptedTxn = Encryption.encryptAes(Variables.txn);
          var capitalizedValue = Variables.fName!.substring(0, 1).toUpperCase();
          FirebaseFirestore.instance.collection('userReg').doc(currentUser!.uid).set({
            'fn': Variables.fName,
            'ln': Variables.lName,
            'email': Variables.email,
            'ph': Variables.ctyCode! + Variables.mobile!,
            'cc':Variables.ctyCode,
            'p2':Variables.mobile!,
            'pix': url,
            'date': date,
            'ref': v1,
            'refact': 0,
            'er':0,
            'ud': currentUser.uid,
            'wal': 0,
            'ven': false,
            'tx': encryptedTxn.base64,
            'ps':encryptedPass.base64,
            'sk':capitalizedValue,
            'ord':0
          });

//send the user ref to database
          //check if the user taped on skip
          VariablesOne.notify(title: 'Registering in progress...');

          if(VariablesOne.skip  == false) {
            FirebaseFirestore.instance.collection('userReg')
                .doc(VariablesOne.docRef[0]['ud'])
                .set({
              'refact': VariablesOne.docRef[0]['refact'] + 100,
              'refc':VariablesOne.docRef[0]['refc'] + 1
            },SetOptions(merge: true));


            /*store user ref in database*/
            FirebaseFirestore.instance.collection('promotion').add({

              'ud': VariablesOne.docRef[0]['ud'],
              'fn': Variables.fName,
              'pix': url,
              'ln': Variables.lName,
              'ti': kTitle,
              //'amt':100,
              'dt': '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
              'ts': DateTime.now(),
              'tm': DateTime.now().toString(),
            });
//store the referal amount the user history

            DocumentReference documentReference = FirebaseFirestore.instance.collection('History').doc();
            documentReference.set({
              'id': documentReference.id,
              'ud': VariablesOne.docRef[0]['ud'],
              'amt': 100,
              'ts': DateTime.now().toString(),
              'dp': 'referral',
            });


            //send an email to the newly registered user
            VariablesOne.notify(title: 'Sending mail...');
            Services.sendMail(
                email: Variables.email!.trim(),
                message: "<h3 style='color:orange;'>SOSURE GAS</h3>\n<p style='colors:LightGray;font-size:12px;'>Dear <strong style='color:darkBlue;'>${Variables.fName} ${Variables.lName},</strong>thank you for registering with us, and we promise to serve you better.<p>Don't hesitate to contact our support when need arises <span style='color:orange;'>SOSURE GAS</span> will continue to give you updates on our promo services. Thanks</p></p>",
                subject: "EasyHomes Registration 😀"
            );
            setState(() {
              percent = 1.0;
              _showDialog();
            });


          }else{

            //when the user skip the referral

            //send an email to the newly registered user
            VariablesOne.notify(title: 'Sending mail...');

            Services.sendMail(
                email: Variables.email!.trim(),
                message: "<h3 style='color:orange;'>SOSURE GAS</h3>\n<p style='colors:LightGray;font-size:12px;'>Dear <strong style='color:darkBlue;'>${Variables.fName} ${Variables.lName},</strong>thank you for registering with us, and we promise to serve you better.<p>Don't hesitate to contact our support when need arises <span style='color:orange;'>SOSURE GAS</span> will continue to give you updates on our promo services. Thanks</p></p>",
                subject: "EasyHomes Registration 😀"
            );
            setState(() {
              percent = 1.0;
              _showDialog();
            });




          }

        });

      } catch (e) {
        setState(() {
          bgImage = false;
        });
        String exception = Auth.getExceptionText(Exception(e));
        setState(() {
          bgImage = false;
        });
        Fluttertoast.showToast(
            msg: exception,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }
  }

  _showDialog() {
    Platform.isIOS
        ? showDialog(
        context: context,

      builder: (context) => CupertinoAlertDialog(
      content: RegDialog(),

        actions: <Widget>[
    CupertinoDialogAction(
    child: Text('Ok',

      style:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: CupertinoColors.activeBlue,
      ),
    ),
    onPressed: () {
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreenSecond(),
        ),
            (route) => false,
      );
    },

        )
    ]))
        :showDialog(
        context: context,
        builder: (context) =>  SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                children: <Widget>[
                  RegDialog(),
                ],
              ));
  }


}

/*


}*/
