import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/partners/business_screen.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/admins/partners/partner_screen.dart';

import 'package:easy_homes/admins/second_modal.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/animation_text.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/auth.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class FirstModal extends StatefulWidget {
  @override
  _FirstModalState createState() => _FirstModalState();
}

class _FirstModalState extends State<FirstModal> {

  Color btnColor = kTextFieldBorderColor;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool checkVerify = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  bool progress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Variables.mobile = null;
  }
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
          child: Column(
    children:<Widget>[
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextWidget(
              name: kLoginText,
              textColor: kBlackColor,
              textSize: kFontSize,
              textWeight: FontWeight.normal,
            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  PageTransition(
                      type: PageTransitionType
                          .scale,
                      alignment: Alignment
                          .bottomCenter,
                      child: HomeScreenSecond()));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                alignment: Alignment.topRight,
                child: Icon(Icons.cancel,size: 30,)),
          )
        ],
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

              },
            )),


      spacer(),
      Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Platform.isIOS
                ? CupertinoTextField(
              controller: _password,
              autocorrect: true,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              cursorColor: (kTextFieldBorderColor),
              style: Fonts.textSize,
              placeholderStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kHintColor,
              ),
              placeholder: 'Password',
              onChanged: (String value) {
                Variables.password = value;
                if (Variables.password == '') {
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
              controller: _password,
              autocorrect: true,
              autofocus: true,
              cursorColor: (kTextFieldBorderColor),
              obscureText: true,
              style: Fonts.textSize,
              decoration: Variables.passwordInput,
              onChanged: (String value) {
                Variables.password = value;
                if (Variables.password == '') {
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
      /*displaying Next button*/

      progress == true
            ? PlatformCircularProgressIndicator()
            : BtnSecond(title: 'Login', nextFunction: () {
          moveToNext();
      }, bgColor: btnColor,),

      spacer(),

    ],
          ),
        )
        );







  }


  Future<void> moveToNext() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

String? uid;
String? pin;
String? timestamp;
    if ((Variables.email == null) || (Variables.email == '')) {
      Fluttertoast.showToast(
          msg: kEmailError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else if((Variables.password == null ) || (Variables.password == '')){
      Fluttertoast.showToast(
          msg: kPasswordError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);


    }else {
      try {
        setState(() {
          progress = true;
        });
        final user = await _auth.signInWithEmailAndPassword(
            email: Variables.email!.trim(), password: Variables.password!.trim());
        if (user != null) {
          User? currentUser = FirebaseAuth.instance.currentUser;

          //FirebaseAuth currentUser = await FirebaseAuth.instance.currentUser();

          await FirebaseFirestore.instance.collection('userReg')

              .where('ud', isEqualTo: currentUser!.uid)
              .get().then((value) {
            value.docs.forEach((result) {

              setState(() {
                pin = result.data()['pi'];
                uid = result.data()['ud'];
                AdminConstants.companyCollection.clear();
                AdminConstants.companyCollection.add(result.data());
                AdminConstants.category =  result.data()['cat'];
                AdminConstants.categoryType =  result.data()['ct'];
                AdminConstants.bizName = result.data()['biz'];
                AdminConstants.create = result.data()['create'];
                timestamp = result.data()['ts'];
                AdminConstants.ownerUid = result.data()['ouid'];
                AdminConstants.noAdminCreated = result.data()['ano'];

                Variables.userUid = (result.data()['ud']);
                Variables.userFN = (result.data()['fn']);
                Variables.userEmail = (result.data()['email']);
                Variables.userLN = (result.data()['ln']);
                Variables.userPix = (result.data()['pix']);
                Variables.userPH = (result.data()['ph']);
              });


            });
          });

          setState(() {
            progress = false;
          });
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }

          Navigator.pop(context);
          ///check if key is open
          if(AdminConstants.create == true) {

            setState(() {
              progress = false;
            });
            if (AdminConstants.category == AdminConstants.owner!.toLowerCase()) {

              /*move to owner screen*/

              Navigator.push(context, PageTransition(type: PageTransitionType.scale,
                  alignment: Alignment.bottomCenter,
                  child: OwnerScreen()));
            } else if (AdminConstants.category == AdminConstants.partner!.toLowerCase()) {

              /*move to partner screen*/


              Navigator.push(context, PageTransition(type: PageTransitionType.scale,
                  alignment: Alignment.bottomCenter,
                  child: PartnerScreen()));
            }else if (AdminConstants.category == AdminConstants.business.toLowerCase()) {

              /*move to partner screen*/


              Navigator.push(context, PageTransition(type: PageTransitionType.scale,
                  alignment: Alignment.bottomCenter,
                  child: BusinessScreen()));
            }else if (AdminConstants.category == AdminConstants.admin.toLowerCase()){

              /*move to sectary screen*/
              //check if admin is for owner

              //update admin login time for owner
              try{
                FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid)
                    .set({
                  'lg':DateFormat('a\n h:mm').format(DateTime.now()),
                  'ol':true,
                },SetOptions(merge: true));

              }catch(e){

              }
              if(AdminConstants.categoryType == AdminConstants.owner!.toLowerCase()) {


                //change the uid to the owner uid
                setState(() {
                  AdminConstants.getAdminUid = Variables.userUid;
                  Variables.userUid = AdminConstants.ownerUid!;
                });


                Navigator.push(context, PageTransition(type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: OwnerScreen()));
              }else if (AdminConstants.categoryType == AdminConstants.partner!.toLowerCase()) {

                /*move to partner screen*/
//change the uid to the owner uid
                setState(() {
                  AdminConstants.getAdminUid = Variables.userUid;
                  Variables.userUid = AdminConstants.ownerUid!;
                });

                Navigator.push(context, PageTransition(type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: PartnerScreen()));
              }else if (AdminConstants.categoryType == AdminConstants.business.toLowerCase()) {

                /*move to business screen*/
//change the uid to the owner uid
                setState(() {
                  AdminConstants.getAdminUid = Variables.userUid;
                  Variables.userUid = AdminConstants.ownerUid!;
                });

                Navigator.push(context, PageTransition(type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: BusinessScreen()));
              }
            }

          }else{


          Platform.isIOS?showCupertinoModalPopup(

              context: context, builder: (BuildContext context) {
            return CupertinoActionSheet(
              actions: <Widget>[
                SecondModal(userPin:pin!,userUid:uid!,userCat:AdminConstants.category!,userTs:timestamp!)
              ],
            );
          }):showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => SecondModal(userPin:pin!,userUid:uid!,userCat:AdminConstants.category!,userTs:timestamp!)
          );


        }}
      }catch (e){

        setState(() {
          progress = false;
        });
        print('this is error $e');
        //String exception = Auth.getExceptionText(e);
      VariablesOne.notifyFlutterToastError(title: kError);

      }
    }
  }

}


