import 'dart:async';
import 'package:easy_homes/utils/internet_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
      InternetConnections().checkConnection(context);
    });

  }



  @override
  void dispose() {
    InternetConnections().dispose();
    super.dispose();

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



}

