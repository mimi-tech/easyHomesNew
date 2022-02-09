import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/notificatin.dart';

import 'package:easy_homes/reg/screens/permission.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:google_map_location_picker/generated/i18n.dart'
//location_picker as location_picker;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load();
  runApp(MyApp());
  _setTargetPlatformForDesktop();



  notificationAppLaunchDetails =
  (await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails())!;

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id!, title: title!, body: body!, payload: payload!));
      });
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      });
}

void _setTargetPlatformForDesktop() {
  TargetPlatform? targetPlatform;
  if (Platform.isMacOS) {
    print('This is macos');
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    /* Sets the statusBar colour of the app */
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: kStatusColor,
      ),
    );

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => Platform.isIOS?CupertinoApp(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],

        supportedLocales: const <Locale>[
          Locale('en', 'US'),
          //Locale('ar', ''),
        ],

        title: 'easyhomes247',
        /* Removes the debug banner at the extreme right of the app */
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: CupertinoThemeData(
          primaryColor: primaryOrange,
          primaryContrastingColor: Colors.blue,
          scaffoldBackgroundColor: kWhiteColor,
            brightness: Brightness.light

        ),



        home: PermissionScreen(),
      ):MaterialApp(
        localizationsDelegates:  [
          //GlobalMaterialLocalizations.delegate,
         // GlobalWidgetsLocalizations.delegate,

          //location_picker.S.delegate,
         // GlobalMaterialLocalizations.delegate,
          //GlobalWidgetsLocalizations.delegate,
          //GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en', 'US'),
          //Locale('ar', ''),
        ],

        title: 'easyhomes247',
        /* Removes the debug banner at the extreme right of the app */
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData(
          //canvasColor: Colors.transparent,
          accentColor: primaryOrange,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,

          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            ),
          ),
        ),




        home: PermissionScreen(),
      ),
    );
  }
}


