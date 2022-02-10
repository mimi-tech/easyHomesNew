import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
class Variables{
 static String? mobile;
 static String? mobilePin;
 static String? email;
 static String? password;
 static String? referal;
 static String? fName;
 static String? lName;
 static String? verificationId;
 static File? image;
 static bool isChecked = true;
 static bool brandNew = false;
 static DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mma');

 static DateFormat dateFormat2 = DateFormat('EEEE, d MMM, yyyy');
 static DateFormat dateFormat3 = DateFormat('hh:mma');

 static List<dynamic> newItems = <dynamic>[];
static String? searchLocation;
 static List<int> amountNew = <int>[];
static dynamic timeTaken;
static dynamic timeTakenValues;
static bool dismiss = true;
static String? ctyCode;
static String block = 'blocked';
static int counter = 0;



/*list of the priceList*/
  static DocumentSnapshot? cloud;


//list of document for customer and vendor to see  transit collection
static DocumentSnapshot? transit;

//list of document for customer and vendor to see  transit collection
  static DocumentSnapshot? upcoming;

//txn pin

  static String? txn;

//list for getting the vendor details after rating

  static DocumentSnapshot? vendorRating;

//static String customerDocId;


static String vendorAccept = 'accept';
 //static String vendorNotAccept = 'Not accepted';
 static int missedCall = 0;
static late double customerLat;

static late LocationData vendorLocation;

 //documentId of the company selected by customer
 static late String selectedCompanyDocId;
 static int percent = 40;

 /*get the details of the vendor that is matched to the customer*/
 static String? vFName;
 static String? vLName;
 static String? vCompany;
 static int?    vRate;
 static String? vDocId;
 static String? vPImg;
 static double? vLat;
 static double? vLog;
  static int? radius;

 static List<DocumentSnapshot> customerDataAll = <DocumentSnapshot>[];
 static List<dynamic> customerData = <dynamic>[];

 //selected cylinder image
  static  List<Widget> selectedCylinder = <Widget>[];
  static  List<String> selectedCylinderUrl = <String>[];

  static  List<int> selectedKg = <int>[];
  static List<dynamic> matchedVendorDoc = <dynamic>[];

  static late DocumentSnapshot matchedBusiness;

 static String myKey  = "${dotenv.env["GOOGLE_MAP_API_KEY"]}";
 static List<int> amountEach = <int>[];
  static List<dynamic> gasKgs = <dynamic>[];
  static List<dynamic> cylinderImages = <dynamic>[];


 /*getting the actual location area of users*/

 static String? locality;
 static String? administrative;
 static String? country;


 /*getting the images of the cylinder*/
 static  List<String> usedHeadUrl = <String>[];
 static  List<String> newHeadUrl = <String>[];


 static List<int> addAllAmount = <int>[];
/*for selection count for used cylinders*/

  static  List<int> selectedHeadOne = <int> [];
  static  List<int> selectedHeadTwo = <int>[];
  static  List<int> selectedHeadThree = <int>[];


  /*selection for New cylinders*/
  static  List<int> newSelectedHeadOne = <int>[];
  static  List<int> newSelectedHeadTwo = <int>[];
  static  List<int> newSelectedHeadThree = <int>[];

/*getting the image of the cylinder selected used*/
  static  List<dynamic> cylinderImage = <dynamic>[];


  /*getting the image of the cylinder selected new*/
  static  List<Widget> newCylinderImage = <Widget>[];

  /*gas exchange booking details for used cylinder*/

 static  List<String> kGItems = <String>[];
 static  List<String> headQuantityText = <String>[];
  static final icons =[];

 static  List<String> head2Items = <String>[];
 static  List<String> head2QuantityText = <String>[];
  static final icons2 =[];


 static  List<String> head3Items = <String>[];
 static  List<String> head3QuantityText = <String>[];
  static final icons3 =[];


  /*gas exchange booking details for new cylinder*/

/*first cylinder*/
  static  List<String> newHead1Items = <String>[];
  static  List<String> newHeadQuantityText = <String>[];
  static final newIcons1 =[];


  /*second cylinder*/
  static  List<String> newHead2Items = <String>[];
  static  List<String> newHead2QuantityText = <String>[];
  static final newIcons2 =[];
  //static List<int> selectedAmount2 = <int>[];

/*Third cylinder*/
  static  List<String> newHead3Items = <String>[];
  static  List<String> newHead3QuantityText = <String>[];
  static final newIcons3 =[];
  //static List<int> selectedAmount3 = <int>[];

  static DateTime selectedDate = DateTime.now();

  static late DateTime bookingDate;

  static late Position myPosition;
  static Coordinates? latPosition;

  static String? address;
  static String? buyerAddress;
  static String? buyerMobileNumber;
  static String? companySelected;
  static String? transactionMood;
  static String? buyingGasType = kPickUp;
  static String? buyingGasTypeImage;


/*calculating the total amount for cylinder*/


  static int sumCylinder = selectedAmount.fold(0, (previous, current) => previous + current);

/*calculating the total amount of gas*/
  static  int sumGas = addAllAmount.fold(0, (previous, current) => previous + current);

  /*calculating the grand total*/
  static dynamic grandTotal;



/*Add all the used cylinder*/
  static  List<String> usedDetailsCylinder = <String>[];

  static  List<String> usedDetailsQuantity = <String>[];



/*add all for new cylinder*/
  static  List<String> newDetailsCylinder = <String>[];
  static  List<String> newDetailsQuantity = <String>[];
  static  List<Widget> detailCylinderType = <Widget>[];
  static  List<String> detailCylinderUrl = <String>[];


  static dynamic distance;

  static bool status = true;



  static List<dynamic> cancelOrder = <dynamic>[];





  /*details of the user that is logged in*/

 static String? userFN;
 static String? userLN;
 static String? userPix;
 static String? userEmail;
 static String? userPH;
 static String? userUid;
 static String? userPhn;
  static String? mop;
 static String? userTs;
 static String? userCat;

 static late bool vendor;
  static  List<dynamic> currentUser = <dynamic>[];
  static late bool confirmVendor;
  static String? customerBuyingGasType;
  static String? vendorUid;
  static String? vendorName;
  static String? vendorPix;




  static String? bookedDocId;

  static int limit = 7;
  static int yearLimit = 5;
  static int monthsLimit = 5;
  static int weeksLimit = 5;
  static int dailyLimit = 5;

  static  List<dynamic> itemsData = <dynamic>[];

  //for getting the map markers

  static  List<dynamic> markers = <dynamic>[];


  //used list

  static List<String> numItems = <String>[];
  static List<String> secondNumItems = <String>[];
  static dynamic totalGasKG;
  static late double tt;

  static dynamic gasEstimatePrice;
  static bool isCheckedFill = false;
  static bool checkRent = false;
  static bool buyCylinder = false;
  static List<int> selectedAmount = <int>[];
  static late int cP ;
  static int cylinderCount = 1;
  static int checkCount = 0;
  static late int checkCountShow;

  static double totalCylinder = 1.0;

  static int cylinderCountSecond = 1;
  static  List<String> secondKGItems = <String>[];

  static  List<dynamic> cytCounting = <dynamic>[];

  //static int gasEstimatePrice = totalGasKG * 8;





  ///Email decoration
 static final emailInput = InputDecoration(

     hintText: 'Email',
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




  ///Amount decoration
  static final amountInput = InputDecoration(

      hintText: 'Enter Amount',
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

  ///message decoration
  static final messageInput = InputDecoration(

      hintText: 'type message...',
      hintStyle:GoogleFonts.pacifico(
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


  ///heading decoration
  static final headingInput = InputDecoration(

      hintText: 'message heading...',
      hintStyle:GoogleFonts.pacifico(
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
  static final reportInput = InputDecoration(

      hintText: kWrong,
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



  /// search decoration

  static final searchInput = InputDecoration(
    prefixIcon: Icon(Icons.search,color: kDoneColor,),
    hintText: "Search...",
    hintStyle:GoogleFonts.oxanium(
      fontSize: ScreenUtil().setSp(kFontSize, ),
      color: kHintColor,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide:
      BorderSide(color: kBlackColor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: kBlackColor),


    ),
    border:
    OutlineInputBorder(borderSide: BorderSide(color: kBlackColor)),
  );

  ///Email decoration
  static final passwordInput = InputDecoration(

      hintText: 'Password',
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

  ///re Enter password decoration
  static final reEnterPasswordInput = InputDecoration(

      hintText: 'Re-enter password',
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


  ///Referial decoration
  static final RferialInput = InputDecoration(

      hintText: 'Referial Code',
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


  static final addressDecoration = InputDecoration(
suffixIcon:  GestureDetector(

    child: SvgPicture.asset('assets/imagesFolder/change.svg',)),
      errorStyle: GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kRedColor,
      ),
      hintText: kRecipientAdd,
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize, ),
        color: kHintColor,
      ),

      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kDividerColor,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: kDividerColor))
  );

 ///quantity decoration
 static final quantityInput = InputDecoration(

     hintText: kNoOfCylinders,
     hintStyle:GoogleFonts.oxanium(
       fontSize: ScreenUtil().setSp(kFontSize, ),
       color: kBlackColor,
     ),
     contentPadding: EdgeInsets.fromLTRB(
         10.0, 10.0, 10.0, 10.0),
     border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(
             kBorder)),
     focusedBorder: OutlineInputBorder(
         borderSide: BorderSide(
             color: kLightBrown))



 );


  //live input decoration
  static final verifyDecoration = InputDecoration(

      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kRadioColor,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))
  );



  ///First Name decoration
 static final fNameInput = InputDecoration(

     hintText: kFName,
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


  ///amount decoration
  static final amountInputs = InputDecoration(

      hintText: 'Not less than NGN 1000.00',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(14, ),
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




  ///card number
  static final cardInput = InputDecoration(

      labelText: 'Card number',
      labelStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
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


  ///card number
  static final cardNameInput = InputDecoration(

      labelText: 'Name',
      labelStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
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



  ///card number
  static final bankNameInput = InputDecoration(

      hintText: 'Bank name',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
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


  ///card number
  static final cardOTPInput = InputDecoration(

      labelText: 'OTP',
      labelStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
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



  ///bank payment phone number
  static final bankPhoneNumber = InputDecoration(

      /*labelText: 'Name',
      labelStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
      ),
*/

      contentPadding: EdgeInsets.fromLTRB(
          20.0, 18.0, 20.0, 18.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              kBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: kLightBrown))



  );


  ///bank payment phone number
  static final bankAccountNumber = InputDecoration(

      hintText: 'Your bank',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
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

  ///bank payment account number
  static final bankAccountNumber2 = InputDecoration(

      hintText: 'Account number',
      hintStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
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

  ///card number
  static final ExpInput = InputDecoration(

      labelText: 'Expiring date',
      labelStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
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


  ///card number
  static final cvvInput = InputDecoration(

      labelText: 'Cvv',
      labelStyle:GoogleFonts.oxanium(
        fontSize: ScreenUtil().setSp(kFontSize14, ),
        color: kTextColor,
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



  ///last Name decoration
 static final lNameInput = InputDecoration(

     hintText: kLName,
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


 static String validatePin(String value) {
   if(value.isEmpty) {
     return "Pin can't be empty";
   }
   if(value.length < 4) {
     return "Pin must be at least 4 numbers";
   }
   if(value.length > 6) {
     return "Pin must be less than 6 numbers";
   }
  return "";
 }


}


class CircleContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 20.0.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2.0,
          color: kStatusColor,
        ),

      ),
    );
  }
}


class IconCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.check_circle,color: kGreenColor,);
  }
}


/*for the used*/
class ContainerTap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: kTextFieldWidth2.w,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          width: 2.0,
          color: kStatusColor,
        ),
        borderRadius:
        BorderRadius.circular(kBorder),
      ),
      child: Center(
        child: TextWidget(name:kTap,
          textColor: kBlackColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w600,),
      ),
    );
  }
}


class ContainerTapNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 110.w,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          width: 2.0,
          color: kStatusColor,
        ),
        borderRadius:
        BorderRadius.circular(kKGBorder),
      ),
      child: Center(
        child: TextWidget(name:kTap,
          textColor: kBlackColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w600,),
      ),
    );
  }
}







class KGIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle, color: kLightBrown,);
  }
}
