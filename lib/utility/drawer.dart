import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/first_modal.dart';

import 'package:easy_homes/utils/blockUser.dart';
import 'package:easy_homes/vendorReg/screens/bank_details.dart';
import 'package:easy_homes/vendorReg/screens/drive.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;

import 'package:easy_homes/dashboard/customer/dashboard_page.dart';
import 'package:easy_homes/dashboard/vendor/today_earning.dart';
import 'package:easy_homes/messages/customer_mesg_screen.dart';
import 'package:easy_homes/messages/vendor_message_screen.dart';
import 'package:easy_homes/payment/methods.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/reg/screens/user_profile.dart';

import 'package:easy_homes/vendorReg/screens/show_vendor_address.dart';

import 'package:easy_homes/work/stations/station_office.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/logins.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';

import 'package:easy_homes/work/vendor_office.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';

class DrawerBar extends StatefulWidget {
  @override
  _DrawerBarState createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  bool progress = false;

  String get filePaths => 'cylinders/${DateTime.now()}';
bool prog = false;
 
  @override
  Widget build(BuildContext context) {

    return Drawer(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: UserProfile()));


                    },
                    leading:  ProfilePicture(),
                    title: RichText(
                      text: TextSpan(
                          text: (Variables.userFN! + '\n'),
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil()
                                .setSp(kFontSize2, ),
                            color: kListTileColor,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: kViewProfile,
                              style: GoogleFonts.oxanium(
                                fontWeight: FontWeight.w500,
                                fontSize: ScreenUtil()
                                    .setSp(kFontSize, ),
                                color: kProfile,
                              ),
                            )
                          ]),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                ListTile(
                  onTap: () {

                    if (Variables.currentUser[0]['ven'] == true) {
                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorTodayEarnings()));

                    }else if(Variables.userCat == AdminConstants.partner ||
                        Variables.userCat == AdminConstants.business ||
                        Variables.userCat == AdminConstants.owner) {

                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CustomerDashBoard()));


                    }else {
                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CustomerDashBoard()));

                    }
                  },
                  leading: SvgPicture.asset('assets/imagesFolder/dashBoard.svg'),
                  title: TextWidget(
                    name: kDashBoard,
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (Variables.currentUser[0]['ven'] == true ||
                    Variables.userCat == AdminConstants.admin ||
                    Variables.userCat == AdminConstants.partner ||
                    Variables.userCat == AdminConstants.business ||
                    Variables.userCat == AdminConstants.owner) {


                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: MessageVendorScreen()));

                    } else {
                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: MessageCustomerScreen()));


                    }
                  },
                  leading: Icon(Icons.markunread,color: kBlackColor,),
                  title: TextWidget(
                    name: kMessage,
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),

                Variables.currentUser[0]['ca'] == null?Visibility(visible: false, child: Text('')): ListTile(
                  onTap: (){

                        setState(() {
                          VariablesOne.gasOrderCount = 0;
                        });

                    Navigator.pop(context);
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationOffice()));


                  },
                  leading: Icon(Icons.markunread,color: kBlackColor,),
                  title: TextWidget(
                    name: 'Stations',
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),


                        Variables.userCat == AdminConstants.admin ||
                        Variables.userCat == AdminConstants.partner ||
                        Variables.userCat == AdminConstants.business ||
                        Variables.userCat == AdminConstants.owner
                    ? ListTile(
                        onTap: () {
                          _auth.signOut();

                          Platform.isIOS
                              ?  showCupertinoModalPopup(

                              context: context, builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              actions: <Widget>[
                                FirstModal()
                              ],
                            );
                          })

                              : showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => FirstModal());
                        },
                        leading: SvgPicture.asset('assets/imagesFolder/password.svg'),
                        title: TextWidget(
                          name: kAdmin,
                          textColor: kListTileColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.normal,
                        ),
                      )
                    : Visibility(visible: false, child: Text('')),

                    Variables.currentUser[0]['ven'] == true
                    ? prog?Center(child: PlatformCircularProgressIndicator()):ListTile(
                        onTap: () async {
                          VariablesOne.isUpcoming = false;
                          if(Variables.myPosition == null){
                            _getCurrentLocation();
                          }else {
                            Navigator.pop(context);
                            Navigator.push(
                                context, PageTransition(type: PageTransitionType
                                .rightToLeft, child: VendorOffice()));
                          }

                        },
                        leading:
                            SvgPicture.asset('assets/imagesFolder/vendor_icon.svg'),
                        title: TextWidget(
                          name: 'Go to work',
                          textColor: kListTileColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.normal,
                        ),
                      )
                    : ListTile(
                        onTap: () async {
                          if (Variables.userCat == AdminConstants.admin ||
                              Variables.userCat == AdminConstants.partner ||
                              Variables.userCat == AdminConstants.business ||
                              Variables.userCat == AdminConstants.owner) {
                            BotToast.showSimpleNotification(title: "Sorry you can't become a vendor with this account, because this account is tied with your business. Thanks.",
                                duration: Duration(seconds: 10),
                                titleStyle:TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil()
                                      .setSp(kFontSize, ),
                                  color: kDarkRedColor,
                                ));
                          } else {
                            //check if vendor has already applied
                            if(Variables.currentUser[0]['reg'] == true){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ShowVendorAddress()));

                            }else {
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: VendorDriving()));
                            }

                          }
                        },
                        leading:
                            SvgPicture.asset('assets/imagesFolder/vendor_icon.svg'),
                        title:  TextWidget(
                                name: kVendor2,
                                textColor: kListTileColor,
                                textSize: kFontSize,
                                textWeight: FontWeight.normal,
                              ),
                      ),

                ListTile(
                  onTap: () async {
                    //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PayWithBankAccountFlutterWave()));


                    String url = "https://api.ravepay.co/v2/banks/NG?public_key=${Variables.cloud!['fpk']}";

                    http.Response res = await http.get(Uri.parse(url),
                    headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fpk']}'});
                        print(res.body);
                    if (res.statusCode == 200) {


                      final Map<String, dynamic> jsonDecoded = json.decode(res.body);
                      var videos = jsonDecoded['data'];
                       for (var item in videos){
                         //iterate over the list
                    Map myMap = item;

                   print(myMap);
                    }

                    }



                    /*String img = 'assets/imagesFolder/type2.png';
                          String path = img
                              .substring(img.lastIndexOf("/"), img.lastIndexOf("."))
                              .replaceAll("/", "");

                            final byteData = await rootBundle.load('assets/imagesFolder/type2.png');

                            final file = File('${(await getTemporaryDirectory()).path}/$path');
                            await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

                          StorageReference ref = FirebaseStorage.instance.ref().child(filePaths);
                          VendorConstants.uploadTask = ref.putFile(file,
                            StorageMetadata(
                              contentType: 'images.jpg',
                            ),
                          );

                          final StorageTaskSnapshot downloadUrl = await VendorConstants.uploadTask.onComplete;
                          String url = await downloadUrl.ref.getDownloadURL();

                          print(url);*/
                  },
                  leading: SvgPicture.asset('assets/imagesFolder/logout.svg'),
                  title: TextWidget(
                    name: 'London',
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),



                ListTile(
                  onTap: () {

                    Navigator.pop(context);
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentMethods()));


                  },
                  leading: SvgPicture.asset('assets/imagesFolder/credit_card.svg'),
                  title: TextWidget(
                    name: kPaymentMethod,
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),

                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: SupportScreen()));

                  },
                  leading: SvgPicture.asset('assets/imagesFolder/speaker.svg'),
                  title: TextWidget(
                    name: kSupport,
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),

                ListTile(
                  onTap: () async {
                   //VariablesOne.YYDialog(text: 'ajbhgbajbda',context: context);
                    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: PaymentDetails()));

                  },
                  leading: SvgPicture.asset('assets/imagesFolder/speaker.svg'),
                  title: TextWidget(
                    name: 'Example',
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),


                ListTile(
                  onTap: () {
                    Platform.isIOS ?
                    /*show ios bottom modal sheet*/
                    showCupertinoModalPopup(

                        context: context, builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        actions: <Widget>[
                          BlockUser()
                        ],
                      );
                    })

                        : showModalBottomSheet(
                        isDismissible: false,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => BlockUser()
                    );
                  },
                  leading: SvgPicture.asset('assets/imagesFolder/block.svg',color: kBlackColor,),
                  title: TextWidget(
                    name: kBlockUser,
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),

                ListTile(
                  onTap: () async {
                    await _auth.signOut();
                    await _googleSignIn.signOut();
                    Navigator.pop(context);

                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                          (route) => false,
                    );

                  },
                  leading: SvgPicture.asset('assets/imagesFolder/logout.svg'),
                  title: TextWidget(
                    name: kLogOut,
                    textColor: kListTileColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> _getCurrentLocation() async {
    LocationData _locationData;
    Location location = new Location();

    setState(() {
      prog = true;
    });
try{
  _locationData = await location.getLocation();

  Variables.vendorLocation = _locationData;


    setState(() {
      prog = false;
    });
    Navigator.pop(context);
    Navigator.push(
        context, PageTransition(type: PageTransitionType
        .rightToLeft, child: VendorOffice()));

  }catch(e){
  setState(() {
    prog = false;
  });
  BotToast.showSimpleNotification(title: "Sorry please try again",
      duration: Duration(seconds: 5),
      titleStyle:TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: ScreenUtil()
            .setSp(kFontSize, ),
        color: kDarkRedColor,
      ));
  }


  }

    Future<Map<String, dynamic>> getBody() async {
      // todo - fix baseUrl
      var url = 'https://api.flutterwave.com/v3/charges?type=debit_ng_account';
    /*  var body = json.encode({

      });
*/

     // print('Body: $body');

      var response = await http.post(
        Uri.parse(url),

       /* headers: {
          //'accept': 'application/json',
          //'Content-Type': 'application/json',
          'bearer':'FLWSECK_TEST-07f2b0a3a6b46eeb39bfd389f08977eb-X',
          'Authorization':'FLWSECK_TEST-07f2b0a3a6b46eeb39bfd389f08977eb-X'

        },*/
        body:{
          "tx_ref":"MC-1585230ew9v5050e8",
          "amount":"100",
          "account_bank":"044",
          "account_number":"0690000032",
          "currency":"NGN",
          "email":"user@flw.com",
          "phone_number":"0902620185",
          "fullname":"Yemi Desola"
        },
      );

      // todo - handle non-200 status code, etc
//print(response.statusCode);
      //print(response.body);

      return json.decode(response.body);
    }
  }

/*uploading cylinders to fireBase storage*/
/*String img = 'assets/heads/head3.png';
                    String path = img
                        .substring(img.lastIndexOf("/"), img.lastIndexOf("."))
                        .replaceAll("/", "");

                      final byteData = await rootBundle.load('assets/heads/head3.png');

                      final file = File('${(await getTemporaryDirectory()).path}/$path');
                      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

                    StorageReference ref = FirebaseStorage.instance.ref().child(filePaths);
                    VendorConstants.uploadTask = ref.putFile(file,
                      StorageMetadata(
                        contentType: 'images.jpg',
                      ),
                    );

                    final StorageTaskSnapshot downloadUrl = await VendorConstants.uploadTask.onComplete;
                    String url = await downloadUrl.ref.getDownloadURL();
*/

/*DateTime todayDate = DateTime.parse('2020-07-19 15:59:50.023329');

                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final yesterday = DateTime(now.year, now.month, now.day - 2);
                    final tomorrow = DateTime(now.year, now.month, now.day + 1);

                    //final aDateTime = ...
                   // var dateToCheck;
                    final aDate = DateTime(todayDate.year, todayDate.month, todayDate.day);
                    if(aDate == today) {
                       print('today');
                    } else if(aDate == yesterday) {
                      print('yesterday');
                    } else if(aDate == tomorrow) {
                      print('tomorrow');
                    }*/
