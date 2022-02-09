import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/utils/shimmer_bg.dart';
import 'package:easy_homes/work/vendor_office.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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

class UpcomingScreen extends StatefulWidget {
  UpcomingScreen({required this.dv});
  final String dv;
  @override
  _UpcomingScreenState createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }
bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUe();
getMusic();

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
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
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    audioPlayer.dispose();
  }

  AudioPlayer audioPlayer = AudioPlayer();


  void getMusic() async {

    audioPlayer = await AudioCache().play("r1.mp3");




    Future.delayed(const Duration(seconds: kCallDuration), () async {

      if(VariablesOne.playState == false){
        audioPlayer.stop();
        try {
          FirebaseFirestore.instance
              .collectionGroup('companyVendors')
              .where('vId', isEqualTo: Variables.userUid)
              .get().then((value) {
            value.docs.forEach((result) {
              result.reference.update({
                'ue': false,
                'acu': false
              });


              setState(() {
                Variables.missedCall++;
              });
              Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VendorOffice(),
                ),
                    (route) => false,
              );






            });
          });


        } catch (e) {
          setState(() {
            Variables.missedCall++;
          });
          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => VendorOffice(),
            ),
                (route) => false,
          );

        }
      }


    });

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: ModalProgressHUD(
      inAsyncCall: progress,
      child: WillPopScope(
        onWillPop: () => Future.value(false),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                spacer(),

                LogoDesign(),

                spacer(),

                ShimmerBgSecond(title: 'Upcoming order'.toUpperCase(),),

              ],
            ),


            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: RichText(
                textAlign: TextAlign.center,

                text: TextSpan(
                    text: 'Dear ${Variables.currentUser[0]['fn']} you have an upcoming order scheduled on ',
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kTextColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(widget.dv))}',

                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kLightBrown,
                        ),
                      ),
                      TextSpan(
                        text: ' by ',

                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kTextColor,
                        ),
                      ),
                      TextSpan(
                        text: '${DateFormat('h:mm:a').format(DateTime.parse(widget.dv))}',

                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kLightBrown,
                        ),
                      )
                    ]),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: TextWidgetAlign(
                name: 'To see your upcoming orders, go to your dashboard -> upcoming orders.',
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
            ),


   progress?PlatformCircularProgressIndicator():    Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,

           children: [
             GestureDetector(
                 onTap:()  {
                   audioPlayer.stop();
                   setState(() {
                     VariablesOne.playState = true;
                     //VariablesOne.decline = false;
                   });

                   notifyCustomer();


                 },
                 child: SvgPicture.asset('assets/imagesFolder/decline.svg',)),
             GestureDetector(
                 onTap:()  {

                   audioPlayer.stop();
                   setState(() {
                     VariablesOne.playState = true;
                   });
                   savedToNotification();
                 },

                 child: SvgPicture.asset('assets/imagesFolder/accept.svg',)),

           ],
         ),
            spacer(),

          ],
        ),
      ),
    )

    ));
  }

  Future<void> savedToNotification() async {
DateTime p = DateTime.parse(widget.dv);
setState(() {
  progress = true;
});
try {
  FirebaseFirestore.instance
      .collectionGroup('companyVendors')
      .where('vId', isEqualTo: Variables.userUid)
      .get().then((value) {
    value.docs.forEach((result) {
      result.reference.update({
        'ue': false,
        'acu': true,
      });



    });
  });

  //update acu back to false
  FirebaseFirestore.instance
      .collectionGroup('companyVendors')
      .where('vId', isEqualTo: Variables.userUid)
      .get().then((value) {
    value.docs.forEach((result) {
      result.reference.set({
        'acu': false,
      },SetOptions(merge: true));
    });
  });

    var scheduledNotificationDateTime = p;
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
        'Upcoming order',
        'Hi ${Variables.userFN!},you have a gas order to deliver now',
        scheduledNotificationDateTime,
        platformChannelSpecifics);





  Future.delayed(const Duration(seconds: 4), () async {
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(
        builder: (BuildContext context) => VendorOffice(),
      ),
          (route) => false,
    );
  });
  setState(() {
    progress = false;
  });
} catch (e) {


}}
//when a vendor declines the order
  void notifyCustomer() {
setState(() {
  progress  = true;
});
    try {
      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.userUid)
          .get().then((value) {
        value.docs.forEach((result) {
          result.reference.update({
            'ue': false,
            'acu': false,

          });

          //update the upcoming that vf = true
          FirebaseFirestore.instance.collection('Upcoming').doc(Variables.currentUser[0]['ud']).set({
            'vf':true,
          },SetOptions(merge: true));



        });
      });
      Future.delayed(const Duration(seconds: 4), () async {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => VendorOffice(),
          ),
              (route) => false,
        );
      });
      setState(() {
        progress  = false;
      });

    } catch (e) {
      Future.delayed(const Duration(seconds: 4), () async {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => VendorOffice(),
          ),
              (route) => false,
        );
      });

      setState(() {
        progress  = false;
      });
    }
}

  void updateUe() {

    try {
      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId', isEqualTo: Variables.userUid)
          .get().then((value) {
        value.docs.forEach((result) {
          result.reference.update({
            'ue': false,
          });
        });
      });
    }catch(e){

    }
  }



  }


