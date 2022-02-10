import 'dart:async';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnections{
  StreamSubscription? _connectionChangeStream;
  bool isOffline = false;
  bool firstEntering = false;

  void checkConnection(BuildContext context){

    _connectionChangeStream = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(result != ConnectivityResult.none){
        isOffline = await InternetConnectionChecker().hasConnection;
        if(firstEntering == true) {
          Navigator.pop(context);
        }
      }else{
        //there is no internet show dialog to the user
        firstEntering = true;

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
                      onPressed: (){},
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
      }
    });
  }

  void dispose() {
    if(_connectionChangeStream != null){
      _connectionChangeStream!.cancel();
    }
  }
}

