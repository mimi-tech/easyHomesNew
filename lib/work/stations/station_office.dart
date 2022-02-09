
import 'dart:io';
import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/extacted_classes/vendor_bappbar.dart';
import 'package:easy_homes/extacted_classes/vendor_close_work.dart';
import 'package:easy_homes/extacted_classes/vendor_map.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/back_icon.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/utils/money_format.dart';

import 'package:easy_homes/work/show_customer.dart';
import 'package:easy_homes/work/stations/recieved_order.dart';
import 'package:easy_homes/work/stations/station_map.dart';
import 'package:easy_homes/work/stations/stations_bottombar.dart';
import 'package:easy_homes/work/stations/view_bookings.dart';
import 'package:easy_homes/work/upcoming_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wakelock/wakelock.dart';

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

class StationOffice extends StatefulWidget {
  @override
  _StationOfficeState createState() => _StationOfficeState();
}

class _StationOfficeState extends State<StationOffice> with WidgetsBindingObserver{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeToTrue();

    WidgetsBinding.instance!.addObserver(this);

    Wakelock.enable();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }
  late List<DocumentSnapshot> workingDocuments;
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  final MethodChannel platform =
  MethodChannel('crossingthestreams.io/resourceResolver');

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
    WidgetsBinding.instance!.removeObserver(this);

    //changeToFalse();
    Wakelock.disable();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    switch (state) {

      case AppLifecycleState.paused:
        {
           print('paused');
          //changeToFalse();
        }
        break;
      case AppLifecycleState.inactive:
        {
          //changeToFalse();
          print('inactive');
        }
        break;

      case AppLifecycleState.detached:
        {
          //changeToFalse();

          print('detached');
        }
        break;

      case AppLifecycleState.resumed:
        {
          print('resummed');
          changeToTrue();
        }
        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        bottomNavigationBar:StationsBottomNavBar(),
        body: WillPopScope(
          onWillPop: () => Future.value(false),
          child: SingleChildScrollView(

              child: Column(

                  children: <Widget>[

                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('AllBusiness')
                            .where('id',isEqualTo:  Variables.currentUser[0]['ca'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: PlatformCircularProgressIndicator());
                          } else if(!snapshot.hasData){
                            return  SupportVendor();

                          }else{
                           //final  List<Map<String, dynamic>> workingDocuments = snapshot.data!.docs as List<Map<String, dynamic>>;
                            workingDocuments = snapshot.data!.docs;
                            Constant1.stationDocuments = snapshot.data!.docs;
                            Constant1.venLat = workingDocuments[0]['lat'];
                            Constant1.venLog = workingDocuments[0]['log'];
                            if(workingDocuments.length != 0){
                              if(snapshot.data!.docs[0]['con'] == true){
                                 Future.delayed(Duration.zero, () {
                                   notifyMe(snapshot);
                                 });
                              }



                           }



                            return workingDocuments.length == 0?

                            SupportVendor()
                                :SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    //height: MediaQuery.of(context).size.height *0.4,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(

                                            bottomLeft: Radius.circular(kContainerRadius),
                                            /*topLeft: Radius.circular(10),*/
                                            bottomRight: Radius.circular(kContainerRadius)
                                        ),

                                        image: DecorationImage(
                                            image: AssetImage('assets/imagesFolder/vendor_bg.png'), fit: BoxFit.cover)),

                                    child: Column(

                                      children: <Widget>[

                                        Container(

                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              spacer(),
                                              Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  GestureDetector(
                                                      onTap:(){
                                                        Navigator.pushAndRemoveUntil(context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext context) => HomeScreenSecond(),
                                                          ),
                                                              (route) => false,
                                                        );
                                                        changeToFalse();

                                                        Wakelock.disable();
                                                      },
                                                      child: BackIcon()),
                                                  SizedBox(width: 20,),
                                                  CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    //radius: 32,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      child: CachedNetworkImage(

                                                        imageUrl:  Variables.currentUser[0]['pix'],
                                                        placeholder: (context, url) => PlatformCircularProgressIndicator(),
                                                        errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
                                                        fit: BoxFit.cover,
                                                        width: 55.w,
                                                        height: 60.h,

                                                      ),
                                                    ),
                                                  ),




                                                ],
                                              ),
                                              spacer(),
                                              TextWidget(
                                                name:  Variables.currentUser[0]['fn'],
                                                textColor: kLightDoneColor,
                                                textSize: kFontSize,
                                                textWeight: FontWeight.bold,
                                              ),

                                              TextWidget(
                                                name: Variables.currentUser[0]['ln'],
                                                textColor: kLightDoneColor,
                                                textSize: kFontSize,
                                                textWeight: FontWeight.bold,
                                              ),
                                              spacer(),
                                              TextWidget(
                                                name: snapshot.data!.docs[0]['biz'],
                                                textColor: kLightBrown,
                                                textSize: kFontSize14,
                                                textWeight: FontWeight.bold,
                                              ),


                                              TextWidget(
                                                name: snapshot.data!.docs[0]['add'],
                                                textColor: kLightBrown,
                                                textSize: kFontSize14,
                                                textWeight: FontWeight.bold,
                                              ),
                                              spacer(),


                                              spacer(),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),



                                  StationMap(),


                                ],
                              ),
                            );





                          }
                        }




                    )
                  ]
              )),
        )
    )
    );
  }

  Future<void> notifyMe(AsyncSnapshot snapshot) async {

    try{
      /*update vendor connection false*/

      FirebaseFirestore.instance
          .collection('AllBusiness').doc(Variables.currentUser[0]['ca']).update({
        'con': false,
        'tr':true,
      });

    }catch (e){
      print(e);
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
    /*notify the gas station that order has been ordered by a customer*/
   try{
     var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 2));
     var vibrationPattern = Int64List(4);
     vibrationPattern[0] = 0;
     vibrationPattern[1] = 1000;
     vibrationPattern[2] = 5000;
     vibrationPattern[3] = 2000;

     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
         'your other channel id',
         'your other channel name',
         'your other channel description',
         icon: 'secondary_icon',
         sound: RawResourceAndroidNotificationSound('slow_spring_board'),
         largeIcon: DrawableResourceAndroidBitmap('sample_large_icon'),
         vibrationPattern: vibrationPattern,
         enableLights: true,
         color: const Color.fromARGB(255, 255, 0, 0),
         ledColor: const Color.fromARGB(255, 255, 0, 0),
         ledOnMs: 1000,
         ledOffMs: 500);
     var iOSPlatformChannelSpecifics =
     IOSNotificationDetails(sound: 'slow_spring_board.aiff');
     var platformChannelSpecifics = NotificationDetails(
         android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
     await flutterLocalNotificationsPlugin.schedule(
         0,
         'gas order'.toUpperCase(),
         'There is a gas order for ${snapshot.data.documents[0]['biz']}',
         scheduledNotificationDateTime,
         platformChannelSpecifics);

   }catch(e){
     print(e);
   }
    setState(() {
      VariablesOne.gasOrderCount++;
    });

  }

  void changeToFalse() {
    try{
    FirebaseFirestore.instance.collection('AllBusiness').doc(Variables.currentUser[0]['ca']).update({
      'ol':false,

    });


    //updating vendors count
    FirebaseFirestore.instance
        .collection('sessionActivity')
        .doc()
        .get().then((resultData) {
      resultData.reference.set({
        'olst': resultData.data()!['olst'] - 1,
      }, SetOptions(merge: true));
    });
  }catch(e){
    }
  }

  void changeToTrue() {
    try{
    FirebaseFirestore.instance.collection('AllBusiness').doc(Variables.currentUser[0]['ca']).update({
      'ol':true,

    });

    //updating vendors count
    FirebaseFirestore.instance
        .collection('sessionActivity')
        .doc()
        .get().then((resultData) {
      resultData.reference.set({
        'olst': resultData.data()!['olst'] + 1,
      }, SetOptions(merge: true));
    });
    }catch(e){
    }
  }










}
class SupportVendor extends StatefulWidget {


  @override
  _SupportVendorState createState() => _SupportVendorState();
}

class _SupportVendorState extends State<SupportVendor> with SingleTickerProviderStateMixin {

  var _visible = true;

  late AnimationController animationController;
 late  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    setTrue();
  }
  @override
  void dispose() {
    //animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30,),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[

            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child:IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    VariablesOne.offline = false;
                  });
                  Navigator.pop(context);
                },),),

            LogoDesign(),
          ],
        ),
        SizedBox(height: 30,),

        Image.asset(
          "assets/imagesFolder/stop.gif",
          height: 125.0,
          width: 125.0,
        ),


        SizedBox(height: 30,),


        GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: SupportScreen()));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: RichText(

              textAlign: TextAlign.center,
              text: TextSpan(
                  text:'Sorry ${Variables.userFN!} ${Variables.userLN} , your gas station  has been suspended from receiving bookings  until further notice. Please ',
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize, ),
                    color: kListTileColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'contact support',
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil()
                            .setSp(kFontSize, ),
                        color: kDoneColor,
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  void setTrue() {
    setState(() {
      VariablesOne.offline = true;
    });
    print(VariablesOne.offline );
  }
}
