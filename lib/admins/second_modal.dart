import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/partners/business_screen.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/admins/partners/partner_screen.dart';
import 'package:easy_homes/admins/partners/register_buisness_first.dart';
import 'package:easy_homes/admins/partners/register_business.dart';
import 'package:easy_homes/admins/partners/sec_screen.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
class SecondModal extends StatefulWidget {
  SecondModal({required this.userPin, required this.userUid, required this.userCat, required this.userTs});
  final String userPin;
  final String userUid;
  final String userCat;
  final String userTs;
  @override
  _SecondModalState createState() => _SecondModalState();
}

class _SecondModalState extends State<SecondModal> {
  TextEditingController _pin = TextEditingController();
  Color btnColor = kTextFieldBorderColor;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  bool progress = false;
  String? verifyPin;
bool isTrueCancel = false;

Widget cancelBusiness(){
  if(AdminConstants.companyCollection[0]['cot'] == null){
    return Text('');
  }else{
    return  GestureDetector(
      onTap: (){
        removeBusiness();
      },
      child: RichText(
        text: TextSpan(
            text: 'Will register later? ',
            style: GoogleFonts.oxanium(
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil()
                  .setSp(kFontSize14, ),
              color: kTextColor,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Cancel',
                style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize, ),
                  color: kDoneColor,
                ),
              )
            ]),
      ),
    );
  }

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
            spacer(),spacer(),
            Center(child: SvgPicture.asset('assets/imagesFolder/unlock.svg')),
            spacer(),
            spacer(),
    TextWidget(name: kPin,
    textColor: kTextColor,
    textSize: kFontSize,
    textWeight: FontWeight.w600,),


            Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Platform.isIOS
                    ? CupertinoTextField(
                  controller: _pin,
                  autocorrect: true,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: (kTextFieldBorderColor),
                  style: Fonts.textSize,
                  placeholderStyle: GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kHintColor,
                  ),

                  onChanged: (String value) {
                    verifyPin= value;
                    if (verifyPin == '') {
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
                  controller: _pin,
                  autocorrect: true,
                  obscureText: true,
                  cursorColor: (kTextFieldBorderColor),

                  style: Fonts.textSize,
                  decoration: Variables.verifyDecoration,
                  onChanged: (String value) {
                    verifyPin= value;
                    if (verifyPin == '') {
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
            spacer(),
            spacer(),
            progress == true?
            PlatformCircularProgressIndicator()
                :BtnThird(title:'Access',nextFunction: () {


              moveToNext();
            }, bgColor: btnColor,),
            spacer(),
            spacer(),

            cancelBusiness(),
            spacer(),



          ],
        ),
      )
      );

  }

  Future<void> moveToNext() async {
if((verifyPin == null) || (verifyPin == '')){


  Fluttertoast.showToast(
      msg: kPinError2,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: kBlackColor,
      textColor: kRedColor);

}else {
  setState(() {
    progress = true;
  });
  User? currentUser = FirebaseAuth.instance.currentUser;
AdminConstants.currentUserUid = currentUser!.uid;
/*get the pin*/


  try {

if((widget.userPin == verifyPin!.trim()) && (widget.userUid == currentUser.uid)) {
//check if document has already been created


 if(AdminConstants.create == true) {

   setState(() {
     progress = false;
   });
   if (widget.userCat == AdminConstants.owner!.toLowerCase()) {

     /*move to owner screen*/

     Navigator.push(context, PageTransition(type: PageTransitionType.scale,
         alignment: Alignment.bottomCenter,
         child: OwnerScreen()));
   } else if (widget.userCat == AdminConstants.partner!.toLowerCase()) {

     /*move to partner screen*/


     Navigator.push(context, PageTransition(type: PageTransitionType.scale,
         alignment: Alignment.bottomCenter,
         child: PartnerScreen()));
   }else if (widget.userCat == AdminConstants.business.toLowerCase()) {

     /*move to partner screen*/


     Navigator.push(context, PageTransition(type: PageTransitionType.scale,
         alignment: Alignment.bottomCenter,
         child: BusinessScreen()));
   }else if (widget.userCat == AdminConstants.admin.toLowerCase()){
     /*check if the key has timeout*//*

     DateTime todayDate = DateTime.parse(widget.userTs);

     final now = DateTime.now();

     final yesterday = DateTime(now.year, now.month, now.day - 2);

     //final aDateTime = ...
     // var dateToCheck;
     final aDate = DateTime(todayDate.year, todayDate.month, todayDate.day);

     if(aDate == yesterday) {
       setState(() {
         progress = false;
       });
       FocusScopeNode currentFocus = FocusScope.of(context);
       if (!currentFocus.hasPrimaryFocus) {
         currentFocus.unfocus();
       }

       Fluttertoast.showToast(

           msg: 'Sorry your key has expired',
           toastLength: Toast.LENGTH_LONG,
           backgroundColor: kBlackColor,
           timeInSecForIosWeb: 10,
           textColor: kRedColor);
       *//*move to sectary back to home screen*//*


       Navigator.pop(context);
       Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.bottomCenter, child: HomeScreenSecond()));
*/

   //}else{
       /*move to sectary screen*/
       //check if admin is for owner

      //update admin login time for owner
       try{
         FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid)
             .set({
           'lg':DateFormat('a\n h:mm').format(DateTime.now()),
           'ol':true,
           'create':true
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
       /*Navigator.pop(context);
       Navigator.push(context, PageTransition(type: PageTransitionType.scale,
           alignment: Alignment.bottomCenter,
           child: SecScreen()));*/


 }else{

   /*check if the key has timeout*/
print('This is A');
   DateTime todayDate = DateTime.parse(widget.userTs);

   final now = DateTime.now();

   final yesterday = DateTime(now.year, now.month, now.day - 2);

   //final aDateTime = ...
   // var dateToCheck;
   final aDate = DateTime(todayDate.year, todayDate.month, todayDate.day);

    if(aDate == yesterday) {
      setState(() {
        progress = false;
      });
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      Fluttertoast.showToast(

          msg: 'Sorry your key has expired',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);

      Navigator.pop(context);

      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreenSecond(),
        ),
            (route) => false,
      );

    }else{
      /*create document for the business*/

      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if ((widget.userCat == 'partner'.toLowerCase()) || (widget.userCat == 'business'.toLowerCase())) {
        Navigator.pushReplacement(context, PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            child: RegisterBusinessScreenOne()));
      }else{
        //This is admin
        print('This is B');


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


    }



 }
}else{
  setState(() {
    progress = false;
  });
  Fluttertoast.showToast(
      msg: kPinError3,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: kBlackColor,
      textColor: kRedColor);

}
  }catch (e){
    setState(() {
      progress = false;
    });
    print(e.toString());
  }
}

  }

  void removeBusiness() {
  //check if business is the first for the user
    try{
      setState(() {
        isTrueCancel = true;
      });
    if(AdminConstants.companyCollection[0]['cot'] == 1){

      //the user will no longer have admin screen
      FirebaseFirestore.instance.collection
('userReg').doc(AdminConstants.companyCollection[0]['ud']).update({
        'biz': FieldValue.delete(),
        'ano': FieldValue.delete(),
        'cat': FieldValue.delete(),
        'cot': FieldValue.delete(),
        'so': FieldValue.delete(),
        'create': FieldValue.delete(),
      });

      Fluttertoast.showToast(
          msg: kRegCancel,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

      Navigator.pop(context);
      setState(() {
        isTrueCancel = false;
      });
    }else{
      FirebaseFirestore.instance.collection
('userReg').doc(AdminConstants.companyCollection[0]['ud']).update({
        'create': true,
         'cot':AdminConstants.companyCollection[0]['cot'] - 1
      });
      Fluttertoast.showToast(
          msg: kRegCancel,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);

      Navigator.pop(context);
      setState(() {
        isTrueCancel = false;
      });
    }

    }catch(e){
      setState(() {
        isTrueCancel = false;
      });
      Navigator.pop(context);

    }
  }
}
