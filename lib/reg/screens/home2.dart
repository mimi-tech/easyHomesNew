import 'dart:io';
import 'package:easy_homes/bookings/cached_bookings.dart';
import 'package:easy_homes/bookings/first_check/cylinder_qty.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/confirmation/rate_vendor.dart';
import 'package:easy_homes/dashboard/vendor/create_pin.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/Screens/logins.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/get_my_location.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/appbar.dart';
import 'package:easy_homes/utility/drawer.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utils/shimmer_bg.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

late NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
class HomeScreenSecond extends StatefulWidget {
  @override
  _HomeScreenSecondState createState() => _HomeScreenSecondState();
}

class _HomeScreenSecondState extends State<HomeScreenSecond> {
   var _documents = <DocumentSnapshot>[];

  /*catching the user that is been logged in*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
checkCurrentLocation();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  bool ongoingBooking = false;
  Widget space() {
    return SizedBox(height: 10.h);
  }




  final MethodChannel platform = MethodChannel('crossingthestreams.io/resourceResolver');


  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }

  Widget mainBody() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagesFolder/home_bg.png'),
            fit: BoxFit.cover,)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          Flexible(
              fit:FlexFit.loose,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[

                      Stack(
                        children: <Widget>[

                          OpenDrawer(),

                          GestureDetector(
                            onVerticalDragDown: (details) {
                              setState(() {
                                _documents.clear();
                                getCurrentUser();
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: kHorizontal),
                                alignment: Alignment.topCenter,
                                child: LogoDesign()),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      Text(kCookingGas.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w800,
                          fontSize: ScreenUtil().setSp(25, ),
                          color: kLightBrown,
                        ),
                      ),
                      SizedBox(height: 5.h),

                      Text(kHomeDelivery.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(
                              kFontSize, ),
                          color: kTextColor,
                        ),
                      ),
                    ],
                  ),

                  Center(child: SvgPicture.asset('assets/imagesFolder/cylinder.svg')),

                  Container(height: 20.h),

                  Container(

                    width: double.infinity,
                    height: 60.h,
                    color: kBottomColor,

                    child: Container(

                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                          text: TextSpan(
                              text: (kFast.toUpperCase()),
                              style: GoogleFonts.oxanium(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(
                                    kFontSize, ),
                                color: kLightBrown,
                              ),

                              children: <TextSpan>[
                                TextSpan(
                                  text: kDelivery.toUpperCase(),
                                  style: GoogleFonts.oxanium(
                                    fontSize: ScreenUtil().setSp(
                                        kFontSize, ),
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),


                              ]
                          )
                      ),


                    ),
                  ),

                ],
              )
          )

        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);

    return SafeArea(
        child:  Scaffold(


          drawer: DrawerBar(),

          floatingActionButton: Container(
            height: 70.h,
            width: 70.w,
            child: FloatingActionButton(onPressed: () {

              /*check if customer has an ongoing booking*/
              if(( ongoingBooking == true) || ( ongoingBooking == null)) {
                //check if this customer has a cached booking details
                if(Variables.currentUser[0]['cb'] == true){

                  Navigator.push(context, PageTransition(
                      type: PageTransitionType.scale,
                      alignment: Alignment.bottomCenter,
                      child: CachedBookings()));

                }else {
                  VariablesOne.checkOneTrue = true;
                 /* Navigator.push(context, PageTransition(
                      type: PageTransitionType.scale,
                      alignment: Alignment.bottomCenter,
                      child: GasOrderType()));*/
                  Platform.isIOS ?
                  /*show ios bottom modal sheet*/
                  showCupertinoModalPopup(

                      context: context, builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      message: CylinderQuantity(),
                      actions: <Widget>[

                        CupertinoActionSheetAction(
                          child: Text("Main Game"),
                          onPressed: () {
                            // TODO: do something in here
                          },
                        ),
                      ],
                    );
                  })

                      : showModalBottomSheet(
                      isDismissible: false,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => CylinderQuantity()
                  );
                }}else{
                YYAlertDialogWithDuration();

              }

            },
              backgroundColor:  kLightBrown,
              autofocus: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(kRegSuccessText2.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(
                      kFontSize14, ),
                  color: kWhiteColor,
                ),
              ),
            ),
          ),

          body: _documents.length == 0 ? ShimmerBg(title: 'Your gas is here') : mainBody(),

        )
    );
  }

  /*Future<void> getCurrentUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    Variables.userUid = currentUser.uid;
    Variables.userPH = currentUser.phoneNumber;
  }*/



  Future<void> _getData() async {
    setState(() {
      _documents.clear();

      getCurrentUser();
    });
  }


  Future<void> getCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    Variables.currentUser.clear();
    if(currentUser == null){

      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
            (route) => false,
      );
    }



    //get the price list and kg

    final QuerySnapshot list = await FirebaseFirestore.instance.collection
("priceList").get();

    final List <DocumentSnapshot> doc = list.docs;

    if (doc.length != 0) {
      for (DocumentSnapshot res in doc) {
      Map<String, dynamic> data = res.data() as Map<String, dynamic>;
        setState(() {
          Variables.amountEach = List.from(data['amt']);
          Variables.gasKgs = List.from(data['kGs']);
           Variables.cloud = res;
          Variables.amountNew = List.from(data['namt']);
          Variables.cylinderImage = List.from(data['im']);
          Variables.newItems = List.from(data['nkGs']);
          Variables.radius = data['rad'];
        });

    }}


    final QuerySnapshot results = await FirebaseFirestore.instance.collection("userReg")
        .where('ud', isEqualTo: currentUser!.uid).get();

    final List <DocumentSnapshot> documents = results.docs;

    if (documents.length == 0)  {
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
            (route) => false,
      );
      final _auth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      await _googleSignIn.signOut();
      await _auth.signOut();
      Fluttertoast.showToast(
          msg: 'Sorry account not found',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 10,
          textColor: kRedColor);
    } else {
      for (DocumentSnapshot result in documents) {
        Map<String, dynamic> data = result.data() as Map<String, dynamic>;

        if (data['bl'] == true) {
          Variables.currentUser.add(data);


    Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(
    builder: (BuildContext context) => SupportScreen(),
    ),
    (route) => false,
    );

    VariablesOne.notifyErrorBot(title: 'Sorry contact support your account have been blocked');

    }else{

        setState(() {
          _documents.add(result);
          Variables.currentUser.clear();
          Variables.currentUser.add(data);
          Variables.userFN = (data['fn']);
          Variables.userEmail = (data['email']);
          Variables.userLN = (data['ln']);
          Variables.userPix = (data['pix']);
          Variables.userPH = (data['ph']);
          Variables.userCat = (data['cat']);
          Variables.userUid = (data['ud']);


          Variables.vendor = (data['ven']);
          Variables.mop = (data['mp']);

          /*getting the unconfirmed vendor details*/

          Variables.confirmVendor = (data['uc']);
          Variables.vendorUid = (data['vid']);
          Variables.vendorName = (data['vfn']);
          Variables.customerBuyingGasType = (data['bgt']);
          Variables.vendorPix = (data['vp']);


          Variables.bookedDocId = (data['ubd']);


          if (Variables.confirmVendor == false) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: RateVendor()));
          }


        });

        /*check if account was unblocked*/
        if (data['blt'] == true) {


          Platform.isIOS ?
          /*show ios bottom modal sheet*/
          showCupertinoModalPopup(

              context: context, builder: (BuildContext context) {
            return CupertinoActionSheet(
              actions: <Widget>[
                CreateUnblockedPin()
              ],
            );
          })

              : showModalBottomSheet(
              isDismissible: false,
              isScrollControlled: true,
              context: context,
              builder: (context) => CreateUnblockedPin()
          );

          pushNotification();

        }

      }
    }}




    FirebaseFirestore.instance.collection
("userReg").doc(currentUser.uid)
        .snapshots()
        .listen((res) {
      ongoingBooking = res.data()!['del'];

    });
  }





  YYDialog YYAlertDialogWithDuration() {
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 4
      ..gravityAnimationEnable = true
      ..gravity = Gravity.right
      ..duration = Duration(milliseconds: 600)



      ..text(
        padding: EdgeInsets.all(18),
        text: 'Ongoing Booking',
        color: kLightBrown,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        alignment: Alignment.center,

      )
      ..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
        text: 'Hello ${Variables.userFN!} you have an ongoing booking, Kindly wait for your order to be completed',
        color: kTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        alignment: Alignment.center,
      )
      ..doubleButton(
        onTap1: (){},
        padding: EdgeInsets.only(right: 10.0),
        gravity: Gravity.right,
        text1: "OK, Got it",
        color1: kDoneColor,
        fontSize1: 18.0,
        fontWeight1: FontWeight.bold,

      )
      ..show();
  }

  Future<void> pushNotification() async {
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 10));
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your other channel id',
        'your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Account Unblocked',
        '${Variables.userFN!} your account has been unblocked successfully',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  void checkCurrentLocation() {
    if(Variables.myPosition == null){
      getMyLocation();
    }else{
      getCurrentUser();

    }
  }

  void getMyLocation() {
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(
        builder: (BuildContext context) => GetMyCurrentLocation(),
      ),
          (route) => false,
    );
  }

}