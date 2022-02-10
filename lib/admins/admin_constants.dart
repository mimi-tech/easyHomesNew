import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminConstants{
  static String? category;
  static String? categoryType;
  static String? bizName;
  static String? businessType;
  static bool? create;

  static String? pickedCountry;
  static String? pickedState;
  static String? partner = 'partner';
  static String? owner = 'owner';
  static String? currentUserUid;
  static String? ownerUid ;
  static String? getAdminUid ;
  static String business = 'business';
  static String eUid = "${dotenv.env["OWNERS_UID"]}";
  static String admin = 'admin';
  static int noAdminCreated = 0;
static GeoPoint? point;
  static String? textAddress;


  static String businessLocation = '';
  static Coordinates? businessPosition;
  static String? businessSubLocation;

  static double? lat;
  static double? log;


  static  List<String> subCity = <String> [];
  static  List<String> city = <String> [];
  static  List<String> state = <String> [];
  static  List<String> country = <String> [];
  static  List<String> address = <String> [];
  static  List<double> latitude = <double> [];
  static  List<double> longitude = <double> [];
  //static  List<String> latLog = <Position> [];


  /*partner regstring vendor*/
  static  List<dynamic> vendorCollection = <dynamic> [];

  static  List<dynamic> companyCollection = <dynamic> [];

//list for getting vendor details
  static  List<dynamic> vendorDetails = <dynamic> [];

  static  List<dynamic> appliedVendorList = <dynamic> [];

  static bool appliedColor = false;






  ///Email decoration
  static final emailInput = InputDecoration(

      hintText: 'Enter user Email',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );

  ///Email decoration
  static final bankName = InputDecoration(

      hintText: 'Bank Name',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );

  ///city decoration
  static final cityInput = InputDecoration(

      hintText: 'Enter business city',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );




  ///business name decoration
  static final bizInput = InputDecoration(

      hintText: 'Enter Partnership business name',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );


  ///key name decoration
  static final keyInput = InputDecoration(
    suffixIcon: Icon(Icons.content_copy),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );

}