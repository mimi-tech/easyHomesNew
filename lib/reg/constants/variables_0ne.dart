import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/cancel_booking.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/reg/screens/logins.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
class VariablesOne{
  static int marker = 100;
  static int callDuration = 10;
  static int limit = 5;
  static String? subLocality;
  static bool decline = true;
  static bool playState = false;
  static AudioPlayer audioPlayer = AudioPlayer();
  static String emailEndpoint = "https://easyhomes-message-service.herokuapp.com/send_email";
  static AudioCache player = AudioCache();
  static bool orderEnded  = false;
static String? ctyCode;

static late DocumentSnapshot documentData;
  static late DocumentSnapshot cachedOrder;

  static  List<DocumentSnapshot> docRef = <DocumentSnapshot>[];

  static  List<String> allCompany = <String>['All'];

  static bool allColor = true;
  static int? selected;

  static  List<String> letters = <String>['a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z 1,2,3,4,5,6,7,8,9,0'];
static bool offline = false;
static var deliveryFee = 0;

 static final numberFormat = new NumberFormat("#,##0.00", "en_US");

static String? checkOne;
  static String? paymentCardNumber;

  static bool  checkOneTrue = false;
  static bool  checkOneTrue2 = false;

  static bool searchHeight = false;
  static bool showCard = false;

static int gasOrderCount = 0;
static bool gasConfirmed = false;
static bool isUpcoming = false;
  static bool reMatchingScreen = false;

static bool skip = false;
static   String radioItem = '';

  static bool checkPayment = false;
static bool doubleOrder = false;

static dynamic changedTotal;
static dynamic changedGas;
static bool updatedOrderTrue = false;
  static const authorizationBearer = "Authorization";
  static final TextEditingController name = new TextEditingController();
  static dynamic emailCode;
  static bool fundingOrder = false;
static bool firstEntering = false;

static dynamic upcomingDocId;

  static List<String> banksLists = <String>[];

  static List<String> banksListsCode = <String>[];
  static int vendorCount = 0;
  static dynamic stationCount = 0;
  static int onlineVendorCount = 0;
  static dynamic onlineStationCount = 0;
  static dynamic ongoingOrderCount = 0;

 /* static Future<void> marketBackgroundHandler(
      {Map<String, dynamic> message}) async {
    String screen = message["data"]["screen"];
  }*/
  static notify({required title})async{
    // String title;
    BotToast.showSimpleNotification(title: title,
        backgroundColor: kBlackColor,
        duration: Duration(seconds: 5),
        titleStyle: GoogleFonts.oxanium(
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil()
              .setSp(kFontSize, ),
          color: kGreenColor,
        ));
  }

  static notifyErrorBot({required title})async{
    // String title;
    BotToast.showSimpleNotification(title: title,
        backgroundColor: kBlackColor,
        duration: Duration(seconds: 5),
        titleStyle: GoogleFonts.oxanium(
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil()
              .setSp(kFontSize, ),
          color: kRedColor,
        ));
  }


  static notifyRejectedErrorBot({required title})async{
    // String title;
    BotToast.showSimpleNotification(title: title,
        backgroundColor: kBlackColor,
        duration: Duration(seconds: 15),
        titleStyle: GoogleFonts.oxanium(
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil()
              .setSp(kFontSize, ),
          color: kYellow,
        ));
  }

  static notifyFlutterToast({required title})async{
    // String title;
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: kBlackColor,
        textColor: kGreenColor);
  }

  static notifyFlutterToastError({required title})async{
    // String title;
    Fluttertoast.showToast(
      timeInSecForIosWeb: 5,
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: kBlackColor,
        textColor: kRedColor);
  }

  static showMyDialog({required yesClick, required noClick,required context}){
    showDialog(
        context: context,
        builder: (context) =>
        SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
       title: TextWidgetAlign(
         name: 'Transaction Error'.toUpperCase(),
         textColor: kLightBrown,
         textSize: 20,
         textWeight: FontWeight.bold,
       ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextWidgetAlign(
            name: 'Dear ${Variables.currentUser[0]['fn']} there is an error in your transaction, we suggest that you make your payment with any of these. Thank you',
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w500,
          ),
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NewBtn(nextFunction:noClick, bgColor: kLightBrown, title: 'New card'),
            NewBtn(nextFunction:yesClick, bgColor: kGreenColor, title: 'Cash')
          ],
        )
      ],
        ));
  }



  static showMyTrans({required yesClick, required context}){
    showDialog(
        context: context,
        builder: (context) =>
        SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: TextWidgetAlign(
            name: 'Means of delivery'.toUpperCase(),
            textColor: kLightBrown,
            textSize: 20,
            textWeight: FontWeight.bold,
          ),
          children: <Widget>[
            RadioListTile(
              groupValue: radioItem,
              title:TextWidget(
                name: kModeTrans2,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),
              value: 'vehicle',
              onChanged: (dynamic val) {
                radioItem = val;

              },
            ),

            RadioListTile(
              groupValue: radioItem,
              title: TextWidget(
                name: kModeTrans3,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w400,
              ),
              value: 'byke',
              onChanged: (dynamic val) {
                radioItem = val;

              },
            ),

            Container(
margin: EdgeInsets.symmetric(horizontal: 30)

                ,                child: NewBtn(nextFunction:yesClick, bgColor: kLightBrown, title: 'Ok'))
          ],
        ));
  }

  static showMyVendorVerify({required yesClick,required context}) {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name: kVerifyVendor2.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: ('Are you sure '),
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kTextColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${AdminConstants.vendorDetails[0]['fn']
                            .toString()
                            .toUpperCase()} ${AdminConstants
                            .vendorDetails[0]['ln'].toString().toUpperCase()}',
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kDoneColor,
                        ),
                      ),


                      TextSpan(
                        text: (' have been screened and trained to become a vendor?'),
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kTextColor,
                        ),
                      ),


                    ]),
              ),
            ),

SizedBox(height: 10,),

          ]),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kDone),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kDone),
              onPressed: yesClick
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidget(
              name: kVerifyVendor2.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[


            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: ('Are you sure '),
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kTextColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${AdminConstants.vendorDetails[0]['fn'].toString().toUpperCase()} ${AdminConstants.vendorDetails[0]['ln'].toString().toUpperCase()}',
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kDoneColor,
                        ),
                      ),


                      TextSpan(
                        text: (' have been screened and trained to become a vendor?'),
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kTextColor,
                        ),
                      ),


                    ]),
              ),
            ),

SizedBox(height: 10,),
            YesNoBtn(no: () {
              Navigator.pop(context);
            }, yes: yesClick
            )

          ],
        ));
  }


  static showRejectDialog({ required yesClick, required noClick,required context}){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: TextWidgetAlign(
            name: 'Gas Delivery Error'.toUpperCase(),
            textColor: kLightBrown,
            textSize: 20,
            textWeight: FontWeight.bold,
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: ('Hi ${Variables.currentUser[0]['fn']}, are you sure that '),
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kTextColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${Variables.transit!['cm'].toString().toUpperCase()} ',
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize, ),
                              color: kDoneColor,
                            ),
                          ),


                          TextSpan(
                            text: (' have not given the right quantity of gas?'),
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize, ),
                              color: kTextColor,
                            ),
                          ),



                        ]),


                  ),
                  SizedBox(height: 30,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidgetAlign(
                        name: 'Please call ',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.normal,
                      ),

                      GestureDetector(
                        onTap: () async {
                          var url = "tel:${Variables.cloud!['ph']}";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: TextWidgetAlign(
                          name: '${Variables.cloud!['ph']}',
                          textColor: kDoneColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 30,),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NewBtn(nextFunction:noClick, bgColor: kRedColor, title: 'No'),
                NewBtn(nextFunction:yesClick, bgColor: kDoneColor, title: 'Yes'),

              ],
            )
          ],
        ));
  }


  static void getLocation({required context}) async {
    //check if the user has entered inside the app


    User? currentUser = FirebaseAuth.instance.currentUser;

    try {

      Position position = await Geolocator.getCurrentPosition();
      Variables.myPosition = position;


      List<Placemark> newPlace = await placemarkFromCoordinates(position.latitude, position.longitude);

      // this is all you need
      Placemark placeMark = newPlace[0];
      String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;//Owerri
      String? administrativeArea = placeMark.administrativeArea;//Imo
      String? postalCode= placeMark.postalCode;
      String? country = placeMark.country;//country

      String? ns = placeMark.thoroughfare;
      String address = "$name $subLocality $ns $locality $administrativeArea $postalCode state, $country";

      Variables.myPosition = position;
      Variables.buyerAddress = address;
      AdminConstants.businessSubLocation = ns;
      Variables.locality = locality;
      Variables.administrative = administrativeArea;
      Variables.country = country;
      Variables.customerLat = position.latitude;
      VariablesOne.subLocality = subLocality;
      // update _address

     /* setState(() {
        progress = false;
      });*/
      if(currentUser == null){
        Navigator.of(context).pushReplacement
          (MaterialPageRoute(builder: (context) => LoginScreen()));
      }else{
        VariablesOne.firstEntering = true;

        Navigator.of(context).pushReplacement
          (MaterialPageRoute(builder: (context) => HomeScreenSecond()));
      }
    }catch (e){
      if(currentUser == null){
        Navigator.of(context).pushReplacement
          (MaterialPageRoute(builder: (context) => LoginScreen()));
      }else{
        VariablesOne.firstEntering = true;

        Navigator.of(context).pushReplacement
          (MaterialPageRoute(builder: (context) => HomeScreenSecond()));
      }

    }
  }

}
