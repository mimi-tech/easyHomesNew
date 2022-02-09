import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorConstants{
  static String? outLetStore;
  static String? companyName;
  static String? companyCAC;
  static String? companyAddress;
 static String? companyCity;
 static String? companyState;
  static  List<String> companyStores = <String>[];
/*this is to get all the address addeed*/
  static  List<String> companyStoresAddAll = <String>[];
  static String?  vendorDriving;
  static String? issuedLicence;
  static String? ExpiredLicenceDate;
  static String? licenceNumber;
  static String? licenceUrl;
  static String? vendorImage;
  static String? bankName;
  static String? bankNameCode;

  static String? bankAccountName;
  static int? bankAccountNumber;
  static String? bvn;
  static String? code;
  static int? gasPrize;
 static String? selectedBizName;
static String? moodOfDelivery;
 static String? selectedDocumentId;
static String? vendorSearchLocation = '';

/*data needed from the company matched to the vendor*/
static String? bizId;
static String? bizName;
static String? address;
static String? city;
  static String? ph;
static String? state;
static String? country;
static  double? lat;
static double? log;
static bool usePrevious = false;


  /*static  List<DocumentSnapshot> documents = <DocumentSnapshot> [];
  static  List<dynamic> bizName = <dynamic> [];*/

  static UploadTask? uploadTask;
  static String? fileName ;
  static String? selectedBank;

/*vendor offline online status*/



  ///Email decoration
  static final companyNameInput = InputDecoration(

      hintText: kCompanyName,
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );



  ///companyCaCInput decoration
  static final companyCaCInput = InputDecoration(

      hintText: kCompanyCAC,
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );



  ///Address decoration
  static final companyAddressInput = InputDecoration(

      hintText: kGasOS + " " + 'street',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );

///companyCity
  static final companyCityInput = InputDecoration(

      hintText: kOutletCity,
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );


  ///company state
  static final companySateInput = InputDecoration(

      hintText: kOutLetState,
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );



  ///who is this course for
  static final kCompanyEditDecoration = InputDecoration(

      hintText: 'Editing text',
      hintStyle: GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kLightBrown,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))
  );



  ///driver licence decoration
  static final companyIssuedLicence = InputDecoration(

      hintText: 'dd/mm/YYYY',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))







  );





  ///driver licence decoration
  static final driverLicence = InputDecoration(

      hintText: 'Licence number \n e.g AB73638',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(12, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );




  ///bank name decoration
  static final bankNameInput = InputDecoration(

      hintText: 'Enter your bank name',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))





  );

  ///bank account name decoration
  static final bankAccountNameInput = InputDecoration(

      hintText: 'Enter your bank account name',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))

  );


  ///bank account name decoration
  static final bankAccountNumberInput = InputDecoration(

      hintText: 'Enter your bank account number',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))

  );


  ///bank account BVN decoration
  static final bvnInput = InputDecoration(

      hintText: 'Bank Verification Number',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))

  );


  ///bank account BVN decoration
  static final codeInput = InputDecoration(

      hintText: 'Enter street name',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))

  );


  ///gas prize decoration
  static final gasPrizeInput = InputDecoration(

      hintText: 'Enter amount',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),
      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))

  );


  ///station report decoration
  static final stationReportInput = InputDecoration(

      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: kTextFieldBorderColor),
          borderRadius: BorderRadius.circular(kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))

  );

}