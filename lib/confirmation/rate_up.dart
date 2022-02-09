import 'dart:io';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/confirmation/confirm_btn.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easy_homes/reg/screens/home2.dart';
class RateUpcomingVendor extends StatefulWidget {

  @override
  _RateUpcomingVendorState createState() => _RateUpcomingVendorState();
}

class _RateUpcomingVendorState extends State<RateUpcomingVendor> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  TextEditingController _report = TextEditingController();
  late Color bg1;
 late  Color bg2;
  late Color bg3;
  double rate = 1.0;
  bool show = false;
  String? report;
  bool progress = false;
  bool _publishModal = false;
  Color compTextColor1 = kTextColor;
  Color compTextColor2 = kTextColor;
  Color compTextColor3 = kTextColor;
  double i = 5.0;
  var itemsData = <dynamic>[];



  bool vg = false;
  bool g = false;
  bool b = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVendor();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformScaffold(
        body: SingleChildScrollView(
          child:itemsData.length == 0 && _publishModal == false ?Center(child: PlatformCircularProgressIndicator()):
          itemsData.length == 0 && _publishModal == true ? ErrorTitle(errorTitle:'No rating for this vendor'): Container(
            child: Column(
              children: <Widget>[


                spacer(),
                BackLogo(),

                spacer(),
                spacer(),
                Center(
                  child: TextWidgetAlign(
                    name: kRate.toUpperCase(),
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),
                spacer(),

                Variables.vendorRating!['vpi'] == null?Text(''):VendorPix(pix: Variables.vendorRating!['vpi'], pixColor: Colors.transparent),



                spacer(),


                RatingBar.builder(
                  initialRating: i,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: kLightBrown,
                  ),
                  onRatingUpdate: (rating) {
                    rate = rating;
                  },
                ),
                spacer(),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(

                      text: kService,
                      style:GoogleFonts.oxanium(
                        fontWeight:FontWeight.normal,
                        fontSize: ScreenUtil().setSp(kFontSize, ),
                        color: kTextColor,
                      ),

                      children: <TextSpan>[
                        TextSpan(
                          text: Variables.vendorRating!['vfn'] == null?Text(''): Variables.vendorRating!['vfn'],
                          style:GoogleFonts.oxanium(
                            fontWeight:FontWeight.w900,
                            fontSize: ScreenUtil().setSp(kFontSize, ),
                            color: kTextColor,
                          ),
                        )
                      ]
                  ),
                ),

                spacer(),

                TextWidget(
                  name: kComplement,
                  textColor: kLightBrown,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),

                spacer(),


                /* Container(
                  //width: 100,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ToggleButtons(
                    color: kTextColor,
                    selectedColor: kWhiteColor,
                    fillColor: kDoneColor,
                    splashColor: Colors.lightBlue,
                    highlightColor: Colors.lightBlue,
                    borderColor: kHintColor,
                    borderWidth: 1,
                    selectedBorderColor: Colors.transparent,
                    renderBorder: true,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    disabledColor: Colors.blueGrey,
                    disabledBorderColor: Colors.blueGrey,
                    focusColor: Colors.red,
                    focusNodes: focusToggle,
                    children: <Widget>[
                      TextWidget(
                        name: 'Very good',
                        //textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.normal,
                      ),
                      TextWidget(
                        name: 'Fairly good',
                        //textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.normal,
                      ),
                      TextWidget(
                        name: 'Bad',
                        //textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.normal,
                      ),
                    ],
                    isSelected: isSelected,
                      onPressed: (int index) {
                        setState(() {
                          for (int indexBtn = 0;indexBtn < isSelected.length;indexBtn++) {
                            if (indexBtn == index) {
                              isSelected[indexBtn] = !isSelected[indexBtn];
                            } else {
                              isSelected[indexBtn] = false;
                            }
                          }
                        });
                      }
                  ),
                ),*/




                Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    RateBtn(title: 'Very good',
                      bgColorBorder: bg1,
                      textColor: vg == true?kWhiteColor:kTextColor,
                      nextFunction: (){ setState(() {
                        bg1 = kDoneColor;
                        bg2 = Colors.transparent;
                        bg3 = Colors.transparent;

                        show = false;
                        vg = true;
                        g = false;
                        b = false;
                        print(vg);
                        rate = 5.0;
                        i = 5;
                      });}, bgColor: Colors.transparent,


                    ),

                    RateBtn(title: 'Good',
                      bgColorBorder: bg2,
                      textColor:  g == true?kWhiteColor:kTextColor,
                      nextFunction: (){ setState(() {
                        bg1 = Colors.transparent;
                        bg2 = kDoneColor;
                        bg3 = Colors.transparent;
                        rate = 3.0;
                        i = 4.5;
                        show = false;
                        vg = false;
                        g = true;
                        b = false;

                      });}, bgColor: Colors.transparent,



                    ),

                    RateBtn(title: 'Bad',
                      bgColorBorder: bg3,
                      textColor: b == true?kWhiteColor:kTextColor,
                      nextFunction: (){ setState(() {
                        bg1 = Colors.transparent;
                        bg2 =  Colors.transparent;
                        bg3 = kDoneColor;
                        i = 1;
                        rate = 0;
                        show = true;
                        vg = false;
                        g = false;
                        b = true;
                      });},bgColor: Colors.transparent,


                    ),

                  ],
                ),
                spacer(),
                spacer(),

                Visibility(
                  visible: show,
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      child: Platform.isIOS
                          ? CupertinoTextField(
                        controller: _report,
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
                        placeholder: kWrong,
                        onChanged: (String value) {
                          report = value;

                        },
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorder),
                            border: Border.all(color: kLightBrown)),
                      )
                          : TextField(
                        controller: _report,
                        autocorrect: true,
                        autofocus: true,
                        cursorColor: (kTextFieldBorderColor),

                        style: Fonts.textSize,
                        decoration: Variables.reportInput,
                        onChanged: (String value) {
                          report = value;

                        },
                      )),
                ),
                spacer(),
                spacer(),
                GestureDetector(
                  onTap: (){
                    //update the customer's rating of vendors to true
                    FirebaseFirestore.instance
                        .collection('userReg')
                        .doc(Variables.currentUser[0]['ud'])
                        .set({
                      'uc': true,
                    },SetOptions(merge: true));

                    Navigator.pop(context);},
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: TextWidget(
                      name: 'Not now',
                      textColor: kDoneColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                ),
                spacer(),

                spacer(),
                progress == true?  PlatformCircularProgressIndicator(): SizedBtn(title:kDone,bgColor: kLightBrown, nextFunction: () {rateUser();}),

                spacer(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void rateUser() {
    DateTime now =  DateTime.now();
    var date =  DateFormat("yyyy-MM-dd hh:mm:a").format(now);



    if((report != null) || (_report.text.length != 0)){
      setState(() {
        progress =true;
      });
      /*send to the fireBase the vendors report*/

      try {

        FirebaseFirestore.instance.collection
          ('vendorsError').doc( Variables.vendorRating!['vid']).set({
          'ts':now,
          'dt':DateFormat('EEEE, d MMM, yyyy').format(now),
          'fn': Variables.vendorRating!['vfn'],
          'ln': Variables.vendorRating!['vln'],
          'pix':Variables.vendorRating!['vpi'],
          'ph':Variables.vendorRating!['vph'],
          'cbi': Variables.vendorRating!['cbi'],
          'vid':Variables.vendorRating!['vid'],
          'biz': Variables.vendorRating!['biz'],
        },SetOptions(merge: true));



        FirebaseFirestore.instance.collection
          ('comments')

            .add({


          'ts':now,
          'tt': report,
          'dt':DateFormat('EEEE, d MMM, yyyy').format(now),
          'tm': DateFormat('h:mm:a').format(now),
          'fn': Variables.userFN!,
          'ln': Variables.userLN,
          'pix':Variables.userPix,
          'ph':Variables.userPH,

          'cbi': Variables.vendorRating!['cbi'],

          'vid':Variables.vendorRating!['vid'],
          'yr':DateTime.now().year,
        });


        /*update vendor rating*/
        FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('vId',
            isEqualTo: Variables.vendorRating!['vid'])
            .get().then((value) {
          value.docs.forEach((result) {
            double cal = result.data()['rate'] + rate * 0.2;
            print('this is cal ${cal.roundToDouble()}');
            result.reference.update({
              'rate': cal.roundToDouble(),
            });
          });
        });


        FirebaseFirestore.instance
            .collection('userReg').doc(Variables.vendorRating!['vid']).get()
            .then((result) {

          double cal = result.data()!['rate'] + rate * 0.2;
          result.reference.update({
            'rate': cal.roundToDouble(),

          });
        });

        //update the customer's rating of vendors to true
        FirebaseFirestore.instance
            .collection('userReg')
            .doc(Variables.currentUser[0]['ud'])
            .set({
          'uc': true,
        },SetOptions(merge: true));
        setState(() {
          progress = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreenSecond(),
          ),
              (route) => false,
        );


        Fluttertoast.showToast(
            msg: 'Thank you for rating our vendor',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);
      }catch(e){
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }else{
      /*update vendor rating*/

      try {
        FirebaseFirestore.instance
            .collectionGroup('companyVendors')
            .where('vId',
            isEqualTo: Variables.vendorRating!['vid'])
            .get().then((value) {
          value.docs.forEach((result) {
            double cal = result.data()['rate'] + rate * 0.2;
            result.reference.update({
              'rate': cal.roundToDouble(),

            });
          });
        });


        FirebaseFirestore.instance
            .collection('userReg').doc(Variables.vendorRating!['vid']).get()
            .then((result) {

          double cal = result.data()!['rate'] + rate * 0.2;
          result.reference.update({
            'rate': cal.roundToDouble(),

          });
        });

//update the customer's rating of vendors to true
        FirebaseFirestore.instance
            .collection('userReg')
            .doc(Variables.currentUser[0]['ud'])
            .set({
          'uc': true,
        },SetOptions(merge: true));

        setState(() {
          progress = false;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreenSecond(),
          ),
              (route) => false,
        );

        Fluttertoast.showToast(
            msg: 'Thank you for rating our vendor',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kGreenColor);
      }catch(e){
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: kError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }


    }

  }

  Future<void> getVendor() async {
    /*customer is saying that vendor has delivered the gas*/


    final QuerySnapshot result = await  FirebaseFirestore.instance
        .collection('Upcoming')
        .where('vid', isEqualTo:Variables.vendorUid)
        .get();
    final List <DocumentSnapshot> documents = result.docs;
    if(documents.length == 0){
setState(() {
  _publishModal = true;
});
    }else {
     for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {Variables.vendorRating = document;
          itemsData.add(document.data());
        });


      }
    }
  }
}
