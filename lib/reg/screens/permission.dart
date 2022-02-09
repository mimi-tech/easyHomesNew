
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/splash.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/reg/screens/logins.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:geocoding/geocoding.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {

  late StreamSubscription<DataConnectionStatus> listener;

  var internetStatus = "Unknown";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Future.delayed(const Duration(seconds: 4), ()
    {
      checkData();
    });

  }
  final Geolocator _geolocator = Geolocator();
  int count = 1;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listener.cancel();
  }
bool progress = false;
  checkLocation() async {
    //Position position = await Geolocator().getLastKnownPosition();

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) {
        print('this user service true is $_serviceEnabled' );
        /*if(currentUser == null){
          Navigator.of(context).pushReplacement
            (MaterialPageRoute(builder: (context) => LoginScreen()));
        }else{
          Navigator.of(context).pushReplacement
            (MaterialPageRoute(builder: (context) => HomeScreenSecond()));
        }*/

      }else{
        print('this user service  is $_serviceEnabled' );
      }
    }


    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

    }
      if (_permissionGranted == PermissionStatus.granted) {
        VariablesOne.getLocation(context: context);
       // getLocation();
        /*if(currentUser == null){
          Navigator.of(context).pushReplacement
            (MaterialPageRoute(builder: (context) => LoginScreen()));
        }else{


          Navigator.of(context).pushReplacement
            (MaterialPageRoute(builder: (context) => HomeScreenSecond()));
        }*/

      }


    _locationData = await location.getLocation();

    Variables.vendorLocation = _locationData;

   /* if(currentUser == null){
      Navigator.of(context).pushReplacement
        (MaterialPageRoute(builder: (context) => LoginScreen()));
    }else{

      Navigator.of(context).pushReplacement
        (MaterialPageRoute(builder: (context) => HomeScreenSecond()));
    }*/


  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(

        child: Platform.isIOS?CupertinoPageScaffold(
          backgroundColor: kbgColor,
          child: Container( child: Splash(),),

          ):Scaffold(
            backgroundColor: kbgColor,
            body: Container(
                child: Splash(),
            ))
    );
  }


  Future<void> checkData() async {

    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          internetStatus = "Connectd TO THe Internet";
           if(VariablesOne.firstEntering){
            Navigator.pop(context);

           }else{
             checkLocation();

           }

          break;
        case DataConnectionStatus.disconnected:
          internetStatus = "No Data Connection";
          setState(() {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder:(context) => Platform.isIOS ?
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

                   Image.asset('assets/imagesFolder/no-wifi.jpg',height: 100,width: 100,),
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
   // return  await DataConnectionChecker().connectionStatus;
  }

  Future<void> _checkInternet() async {
    bool checkCon = await DataConnectionChecker().hasConnection;
    if(checkCon == true){

      checkLocation();

    }

  }


}
