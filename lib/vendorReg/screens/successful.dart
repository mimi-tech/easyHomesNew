import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/services.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
//import 'package:telephony/telephony.dart';
class SuccessFulScreen extends StatefulWidget {
  @override
  _SuccessFulScreenState createState() => _SuccessFulScreenState();
}

class _SuccessFulScreenState extends State<SuccessFulScreen> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }
  static var now = new DateTime.now();
  var date =  DateFormat("yyyy-MM-dd hh:mm:a").format(now);
  static Geoflutterfire geo = Geoflutterfire();

  static String username = Variables.cloud!['em'];
  static String password = Variables.cloud!['ps'];
  final smtpServer = gmail(username, password);

  //final Telephony telephony = Telephony.instance;
  String? msg;
  String? msgHtml;
  String? emailRev;

  String? phoneNo;
  bool _publishModal = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: ProgressHUDFunction(
      inAsyncCall: _publishModal,
      child: SingleChildScrollView(
        child: Container(

child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        spacer(),
            LogoDesign(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
Center(
  child: TextWidget(
        name:
        Variables.userCat == AdminConstants.admin ||
            Variables.userCat == AdminConstants.partner ||
            Variables.userCat == AdminConstants.business
            || Variables.userCat == AdminConstants.owner?
            '$kThanks ${AdminConstants.vendorCollection[0]['fn']}'
            :

        kThanks + " "+ Variables.userFN!,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w600,
  ),
),

            spacer(),

 Card(
  elevation: 20,
  child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),

        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child:  RichText(
            textAlign: TextAlign.justify,

            text: TextSpan(
              text: kThanks2,
              style:GoogleFonts.oxanium(
                fontWeight:FontWeight.w400,
                color:kTextColor,
                fontSize: ScreenUtil()
                    .setSp(kFontSize,
                ),

              ),
              children: <TextSpan>[


                TextSpan(text:
                Variables.userCat == AdminConstants.admin ||
                    Variables.userCat == AdminConstants.partner ||
                    Variables.userCat == AdminConstants.business
                    || Variables.userCat == AdminConstants.owner?
                AdminConstants.companyCollection[0]['biz']
                :VendorConstants.address,
                  style:GoogleFonts.oxanium(
                    fontWeight:FontWeight.w400,
                    color: kDoneColor,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize,
                    ),
                  ),
                ),

                TextSpan(text: '. Tel ',
                  style:GoogleFonts.oxanium(
                    fontWeight:FontWeight.w400,
                    color: kTextColor,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize,
                    ),
                  ),
                ),
                TextSpan(text:
                Variables.userCat == AdminConstants.admin ||
                    Variables.userCat == AdminConstants.partner ||
                    Variables.userCat == AdminConstants.business
                    || Variables.userCat == AdminConstants.owner?

                AdminConstants.vendorCollection[0]['ph'].toString():VendorConstants.ph.toString(),
                  style:GoogleFonts.oxanium(
                    fontWeight:FontWeight.w400,
                    color: kDoneColor,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize,
                    ),
                  ),
                ),

                TextSpan(text: '. $kThanks3' ,
                  style:GoogleFonts.oxanium(
                    fontWeight:FontWeight.w400,
                    color: kTextColor,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
  ),
),





            spacer(),
            BtnSecond(title:'Ok',nextFunction: () {
              moveToNext();
            }, bgColor: kLightBrown,),

          ],
        ),

        ),
      ),
    )));
  }

  Future<void> moveToNext() async {
    GeoFirePoint point = geo.point(
        latitude: Variables.myPosition.latitude, longitude: Variables.myPosition.longitude);

setState(() {
  _publishModal = true;
});

/*check if it is a company registering the vendor*/


if (
Variables.userCat == AdminConstants.admin ||
Variables.userCat == AdminConstants.partner ||
Variables.userCat == AdminConstants.business
|| Variables.userCat == AdminConstants.owner){


  try {

    var capitalizedValue = AdminConstants.vendorCollection[0].substring(0, 1).toUpperCase();



    DocumentReference documentReference = FirebaseFirestore.instance.collection('vendor')
        .doc(AdminConstants.companyCollection[0]['ud']).collection('companyVendors').doc(
      AdminConstants.vendorCollection[0]['ud']);
    documentReference.set({
      'fn': AdminConstants.vendorCollection[0]['fn'],
      'ln': AdminConstants.vendorCollection[0]['ln'],
      'email': AdminConstants.vendorCollection[0]['email'],
      'ph': AdminConstants.vendorCollection[0]['ph'],
      'pix': AdminConstants.vendorCollection[0]['pix'],
      'date': date,
      'ts':now,
      'st': VendorConstants.outLetStore,
      'cn': VendorConstants.companyName,
      //'cac': VendorConstants.companyCAC,
      'str':  Variables.buyerAddress,
      'state': Variables.administrative,
      'city': Variables.locality,
      'cty': Variables.country,
      'vPos': point.data,
      'scity': AdminConstants.businessSubLocation,
      'lat': Variables.latPosition!.latitude,
      'log': Variables.latPosition!.longitude,
      'drv': VendorConstants.vendorDriving,
      'exp': VendorConstants.ExpiredLicenceDate,
      'iss': VendorConstants.issuedLicence,
      'lnum': VendorConstants.licenceNumber,
      'limg': VendorConstants.licenceUrl,
      'bn': VendorConstants.bankName,
      'actN': VendorConstants.bankAccountName,
      'actNum': VendorConstants.bankAccountNumber,
      'bkc':  VendorConstants.bankNameCode,
      'cbi': AdminConstants.companyCollection[0]['ud'],
      'id': AdminConstants.companyCollection[0]['id'],
        'ue':false,
      'biz': AdminConstants.companyCollection[0]['biz'],
       're':false,
      'su':false,
      'vId': documentReference.id,
      // 'id':FieldValue.arrayUnion([documentReference.documentID]),
      'mt': VendorConstants.moodOfDelivery == 'both'?kModeTrans5:VendorConstants.moodOfDelivery,
      'appr': false,
      'rate': 1.0,
      'wal': AdminConstants.vendorCollection[0]['wal'],
      'con': false,
      /*online*/ 'ol': false,
      /*transite*/'tr': false,
      /*accept*/ 'ac': "",
      'sk':capitalizedValue

    });

//updating vendors count
    FirebaseFirestore.instance
        .collection('sessionActivity')
        .doc()
        .get().then((resultData) {
      resultData.reference.set({
        'vec': resultData.data()!['vec'] + 1,
      }, SetOptions(merge: true));
    });
    FirebaseFirestore.instance
        .collection('userReg')
        .doc(AdminConstants.vendorCollection[0]['ud'])
        .set({
      'ven': true,
      'rate': 1.0,
      'cud': VendorConstants.bizId,
      'er':0,
      'bN': VendorConstants.bankName!.trim(),
      'bAct': VendorConstants.bankAccountName!.trim(),
      'bAN': VendorConstants.bankAccountNumber,
      'bkc':  VendorConstants.bankNameCode,
      //'bis': VendorConstants.bizName,
    },SetOptions(merge:true));
    sendEmailToVendor();

  } catch (e) {

    setState(() {
      _publishModal = false;
    });
  VariablesOne.notifyFlutterToastError(title: kError);
    print(e.toString());
  }

}else {
  try {
    var capitalizedValue = Variables.userFN!.substring(0, 1).toUpperCase();

    DocumentReference documentReference = FirebaseFirestore.instance.collection
(
        'vendor')
        .doc(VendorConstants.bizId).collection('companyVendors').doc(
        Variables.userUid);
    documentReference.set({
      'fn': Variables.userFN!,
      'ln': Variables.userLN,
      'email': Variables.userEmail,
      'ph': Variables.userPH,
      'pix': Variables.userPix,
      'date': date,
      'st': VendorConstants.outLetStore,
      'cn': VendorConstants.bizName,
      //'cac': VendorConstants.companyCAC,
      'str': Variables.buyerAddress,
      'state': Variables.administrative,
      'city': Variables.locality,
      'cty': Variables.country,
      'vPos': point.data,
      'ts':now,
      'id':VendorConstants.city,

      're':false,
      'su':false,
      'scity': AdminConstants.businessSubLocation,
      'lat': Variables.latPosition!.latitude,
      'log': Variables.latPosition!.longitude,
      'drv': VendorConstants.vendorDriving,
      'exp': VendorConstants.ExpiredLicenceDate,
      'iss': VendorConstants.issuedLicence,
      'lnum': VendorConstants.licenceNumber,
      'limg': VendorConstants.licenceUrl,
     /* 'bn': VendorConstants.bankName,
      'actN': VendorConstants.bankAccountName.trim(),
      'actNum': VendorConstants.bankAccountNumber,
      'bkc':  VendorConstants.bankNameCode,*/
      'cbi': VendorConstants.bizId,
      'biz': VendorConstants.bizName,
        'cad':VendorConstants.address,
      'cph':VendorConstants.ph,
//        'cCity':VendorConstants.city,
//        'cSt':VendorConstants.state,
//        'cCty':VendorConstants.country,
//        'cLat': VendorConstants.lat,
//        'cLog':VendorConstants.log,
//        'cPos':companyPoint.data,
      'vId': documentReference.id,
      // 'id':FieldValue.arrayUnion([documentReference.documentID]),
      'mt': VendorConstants.moodOfDelivery == 'both'?kModeTrans5:VendorConstants.moodOfDelivery,
      'appr': false,
      'rate': 1.0,
      'wal': Variables.currentUser[0]['wal'],
      'con': false,
      'ue':false,
      /*online*/ 'ol': false,
      /*transite*/'tr': false,
      /*accept*/ 'ac': "",
      'sk':capitalizedValue

    });
//updating vendors count
    FirebaseFirestore.instance
        .collection('sessionActivity')
        .doc()
        .get().then((resultData) {
      resultData.reference.set({
        'vec': resultData.data()!['vec'] + 1,
      }, SetOptions(merge: true));
    });
//setting the vendor bank account in userReg
    FirebaseFirestore.instance
        .collection('userReg')
        .doc(Variables.userUid)
        .set({
      'reg': true,
      'bN': VendorConstants.bankName!.trim(),
      'bAct': VendorConstants.bankAccountName!.trim(),
      'bAN': VendorConstants.bankAccountNumber,
      'bkc':  VendorConstants.bankNameCode,


     /* 'rate': 1.0,
      'cud': VendorConstants.bizId,
      'biz': VendorConstants.bizName,
      'er':0*/
    },SetOptions(merge:true));
    sendEmailToVendor();
    sendSmsToVendor();


  } catch (e) {

    setState(() {
      _publishModal = false;
    });
  VariablesOne.notifyFlutterToastError(title: kError);
    print(e.toString());
  }
}

  }

  Future<void> sendEmailToVendor() async {
    var date =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var newDate =  DateTime(date.year, date.month, date.day + 14);

    var r = DateFormat('EEEE d MMM, yyyy').format(newDate);

    if(Variables.userCat == AdminConstants.admin || Variables.userCat == AdminConstants.partner ||
        Variables.userCat == AdminConstants.business || Variables.userCat == AdminConstants.owner){
      //the vendor came to the office

      msgHtml = "<h3 style='color:orange;'>$kCompanyNames</h3>\n<p style='colors:LightGray;font-size:14px;'>Dear <strong style='color:darkBlue;'>${AdminConstants.vendorCollection[0]['fn']} ${AdminConstants.vendorCollection[0]['ln']}.</strong> Congratulations! You are now a vendor with <h3 style='color:orange;'>SOSURE GAS</h3> </p>";
      emailRev = AdminConstants.vendorCollection[0]['email'];
    }else{
     //check if the vendor has no vehicle
      if(VendorConstants.moodOfDelivery == 'both'){
        msgHtml = "<h3 style='color:orange;'>$kCompanyNames</h3>\n<p style='colors:LightGray;font-size:14px;'>Dear <strong style='color:darkBlue;'>${Variables.userFN!} ${Variables.userLN}.</strong> $kThanks4 <span style='color:darkBlue;'>${VendorConstants.address}</span></p><p style='colors:LightGray;font-size:14px;'> $kThanks5 <li style='colors:LightGray;font-size:14px;'>Your mode of transportation</li> <li style='colors:LightGray;font-size:14px;'>your driver's licence.</li><span style='color:green;'>Note:</span> Application expires on $r. Thanks</p>";
        emailRev = Variables.currentUser[0]['email'];
      }else{


      msgHtml = "<h3 style='color:orange;'>$kCompanyNames</h3>\n<p style='colors:LightGray;font-size:14px;'>Dear <strong style='color:darkBlue;'>${Variables.userFN!} ${Variables.userLN}.</strong> $kThanks4 <span style='color:darkBlue;'>${VendorConstants.address}</span></p><p style='colors:LightGray;font-size:14px;'> $kThanks5 <li style='colors:LightGray;font-size:14px;'>Your mode of transportation</li> <li style='colors:LightGray;font-size:14px;'>All your vehicle licence.</li><span style='color:green;'>Note:</span> Application expires on $r. Thanks</p>";
      emailRev = Variables.currentUser[0]['email'];
    }}


    // Create our message.

    Services.sendMail(
        email: Variables.email!.trim(),
        message: msgHtml,
        subject: "Request to become a vendor 😀"
    );

  }

  Future<void> sendSmsToVendor() async {
    var date =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var newDate =  DateTime(date.year, date.month, date.day + 14);

    var r = DateFormat('EEEE d MMM, yyyy').format(newDate);

    if(
        Variables.userCat == AdminConstants.admin || Variables.userCat == AdminConstants.partner ||
        Variables.userCat == AdminConstants.business || Variables.userCat == AdminConstants.owner
    ){
     msg = "Dear ${AdminConstants.vendorCollection[0]['fn']}, your application to become $kCompanyNames vendor have been approved successfully. Thanks.";
     phoneNo = AdminConstants.vendorCollection[0]['ph'];
    }else{
      if(VendorConstants.moodOfDelivery == 'both') {
        msg = "Dear ${Variables.userFN!}, your request to become $kCompanyNames vendor have been received.Please visit our office @ ${VendorConstants.address} or tel ${VendorConstants.ph.toString()} Please come with the following \n (1)Your ${VendorConstants.moodOfDelivery}.\n (2) Your driver's licence \n  Note:Application expires on $r Thanks.";
        phoneNo =  Variables.currentUser[0]['ph'];
      }else{
        msg = "Dear ${Variables.userFN!}, your request to become $kCompanyNames vendor have been received.Please visit our office @ ${VendorConstants.address} or tel ${VendorConstants.ph.toString()} Please come with the following \n (1)Your ${VendorConstants.moodOfDelivery}.\n (2) Your driver's licence  & All your vehicle registration licence \n Note:Application expires on $r Thanks.";
     phoneNo =  Variables.currentUser[0]['ph'];
    }}
    Services.sendSms(
        phoneNumber: phoneNo,
        message: msg,
    );

    }
}
