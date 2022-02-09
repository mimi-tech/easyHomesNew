import 'dart:async';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/screens/permission.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Future.delayed(const Duration(seconds: 10), ()
    {
      checkData();
    });

  }

  late StreamSubscription<DataConnectionStatus> listener;

  var internetStatus = "Unknown";

  Future<void> checkData() async {

      listener = DataConnectionChecker().onStatusChange.listen((status) {
        switch (status) {
          case DataConnectionStatus.connected:
            internetStatus = "Connectd TO THe Internet";
            print('Data connection is available.');
            Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rotate,
                duration: Duration(seconds: kTransitionSecs),
                child: PermissionScreen()));
            break;
          case DataConnectionStatus.disconnected:
            internetStatus = "No Data Connection";
            print('You are disconnected from the internet.');
           setState(() {
             showDialog(
               barrierDismissible: false,
                 context: context,
                 builder: (context) => Platform.isIOS?
                 CupertinoAlertDialog(
                   content:  Container(
                     margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                     child: TextWidgetAlign(name: kNoInternet,
                       textColor: kTextColor,
                       textSize: kFontSize,
                       textWeight: FontWeight.w500,),

                   ),

                   actions: <Widget>[
                     CupertinoButton(
                       onPressed: (){},
                       color: kLightBrown,
                       child:  TextWidget(name: 'Try',
                         textColor: kWhiteColor,
                         textSize: kFontSize,
                         textWeight: FontWeight.bold,),
                     )
                   ],
                 )
                     : SimpleDialog(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(8),
                   ),
                   elevation: 4,

                   children: <Widget>[

                     Icon(Icons.cloud,size: 100,color: kRadioColor,),
                     SizedBox(height: 20.h,),
                     Container(
                       margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                       child: TextWidgetAlign(name: kNoInternet,
                         textColor: kTextColor,
                         textSize: kFontSize,
                         textWeight: FontWeight.w500,),



                     ),

                  SizedBox(height: 20.h,),
                     Container(
                       alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: (){_checkInternet();},
                        color: kLightBrown,
                        child:  TextWidget(name: 'Try',
                          textColor: kWhiteColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,),
                      )
                     )
                   ],
                 )

             );
           });
            break;
        }
      });

    // close listener after 30 seconds, so the program doesn't run forever
//    await Future.delayed(Duration(seconds: 30));
//    await listener.cancel();
      await DataConnectionChecker().connectionStatus;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listener.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: PlatformScaffold(body: Container(

height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(

          image: DecorationImage(
              image: AssetImage('assets/heads/landing_bg.png'), fit: BoxFit.cover)),

    )));
  }

  Future<void> _checkInternet() async {
   bool checkCon = await DataConnectionChecker().hasConnection;
if(checkCon == true){
  Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rotate,
      duration: Duration(seconds: kTransitionSecs),
      child: PermissionScreen()));
}

  }
}
