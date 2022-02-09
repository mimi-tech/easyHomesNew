import 'dart:io';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/partners/sec_generate_key.dart';
import 'package:easy_homes/admins/third_modal.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sticky_headers/sticky_headers.dart';
class VerifySales extends StatefulWidget {
  @override
  _VerifySalesState createState() => _VerifySalesState();
}

class _VerifySalesState extends State<VerifySales> {
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
  bool progress2 = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 600),
      curve: Curves.decelerate,
      child: Column(
        children: <Widget>[
          spacer(),


          spacer(),checkEmail==true?TextWidgetAlign(name: 'Confirmed Admin'.toUpperCase(),
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

                  text: 'Do you want to make this user your staff ',

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
          progress == true?PlatformCircularProgressIndicator(): checkEmail == true?Text(''):BtnSecond(title: kVerify, nextFunction: () {


            moveToNext();
          }, bgColor: btnColor,),


          checkEmail == true? BtnSecond(title: 'Proceed', nextFunction: () {


            nextModal();
          }, bgColor: kDoneColor,):Text(''),

          spacer(),
        ],
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
        final QuerySnapshot result = await FirebaseFirestore.instance
.collection('userReg')
            .where('email', isEqualTo: email!.trim())

            .get();
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
          for (DocumentSnapshot document in documents) {
            if (document['ca'] == null) {
              setState(() {
                firstName = document['fn'];
                lastName = document['ln'];
                uid = document['ud'];
                progress = false;
                checkEmail = true;
              });
            }else{
              Navigator.pop(context);
              Fluttertoast.showToast(
                  msg: kPinError8,
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 10,
                  backgroundColor: kBlackColor,
                  textColor: kRedColor);
            }
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

  void nextModal() {
      List<dynamic> stations = <dynamic>[];

setState(() {
  Iterable<dynamic> cc =  PageConstants.getCompanies.where((element) => element['ud'] == Variables.userUid);
  stations.clear();
stations.addAll(cc);
});
if(stations.length == 0){
  Navigator.pop(context);
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ClassicGeneralDialogWidget(
        titleText: 'Gas station'.toUpperCase(),
        contentText: 'Sorry you have no gas station',
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kLightBrown)

              ),

              onPressed:(){
               Navigator.pop(context);},
              child:TextWidget(
                name:'Ok',
                textColor: kWhiteColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              )),
        ],
        onPositiveClick: () {
          Navigator.of(context).pop();
        },
        onNegativeClick: () {
          Navigator.of(context).pop();
        },
      );
    },
    animationType: DialogTransitionType.slideFromLeftFade,
    curve: Curves.fastOutSlowIn,
    duration: Duration(seconds: 1),
  );

}else{
  Navigator.pop(context);
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
   child: SingleChildScrollView(
     child: StickyHeader(
                header:  Stack(
                  alignment: Alignment.center,
                  children: [
                    AdminHeader(title: 'Gas station(s)'.toUpperCase()),
                    Align(
                      alignment: Alignment.topRight,

                      child: IconButton(icon: Icon(Icons.cancel,color: kRedColor), onPressed: (){
                       Navigator.pop(context);
                      }),
                    ),
                  ],
                ),


                content: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: stations.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: (){
                            getSales(index,context);
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(icon: Icon(Icons.radio_button_unchecked,color: kLightBrown), onPressed: (){

                                  }),
                                  Column(
                                    children: [
                                      ReadMoreTextConstruct(title: stations[index]['biz'], colorText: kTextColor),
                                      ReadMoreTextConstruct(title: stations[index]['add'], colorText: kDoneColor),

                                    ],
                                  )
                                ],
                              ),

                              Divider(),

                            ],
                          ),
                        );
                      }),
                ),
   ),
  ),
            ],
          ),
        ),
      ));




  }}

  void getSales(int index,BuildContext context,) {
    Navigator.pop(context);

    showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'Create gas station sales personnel'.toUpperCase(),
          contentText: '${Variables.userFN!} you are about to make $firstName $lastName your sales personnel for ${PageConstants.getCompanies[index]['biz']} gas station at ${PageConstants.getCompanies[index]['add']}',
          onPositiveClick: () {
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
          actions: [
            progress2?PlatformCircularProgressIndicator():ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kRadioColor)

                ),

                onPressed:(){
                  Navigator.pop(context);},
                child:TextWidget(
                  name:'No',
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                )),

            progress2?Text(''): ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kLightBrown)

                ),

                onPressed:(){
                  createSales(index,context);
                  },
                child:TextWidget(
                  name:'Yes',
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                )),
          ],

        );


      },
      animationType: DialogTransitionType.slideFromRightFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );

  }

  void createSales(int index,BuildContext context,) {

    @override
    void setState(fn) {
      if(mounted) {
        super.setState(fn);
        progress2 = true;

      }}
    try{
      FirebaseFirestore.instance.collection
('userReg').doc(uid).set({
        'ca':PageConstants.getCompanies[index]['id'],
        'co':0,
        'cbi':PageConstants.getCompanies[index]['ud'],
        'biz':PageConstants.getCompanies[index]['biz'],
        'sa':true,
        'sac':PageConstants.getCompanies[index]['cc'],
        'sad':PageConstants.getCompanies[index]['add'],

      },SetOptions(merge: true));
      setState(() {
        progress2 = false;
      });

      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'successful',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }catch (e){
      setState(() {
        progress2 = false;
      });

    VariablesOne.notifyFlutterToastError(title: kError);
    }
  }
}
