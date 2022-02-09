import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/Analysis/daily_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/admin_logs.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/colors/colors.dart';

import 'package:easy_homes/strings/strings.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

class ActivityPage extends StatefulWidget {
  ActivityPage({
    required this.azColor,
    required this.activityColor,
    required this.logColor,

    required this.azTextColor,
    required this.activityTextColor,
    required this.logTextColor
  });

  final Color azColor;
  final Color activityColor;
  final Color logColor;
  final Color azTextColor;
  final Color activityTextColor;
  final Color logTextColor;
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          color: kWhiteColor,
      child: Column(
        children: <Widget>[
         // space(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){


                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => OwnerScreen(),
                    ),
                        (route) => false,
                  );
                },
                child: ActivityTabConstruct(title: 'A-Z',color1: widget.azColor,color2:  widget.azTextColor,),

              ),


              //SvgPicture.asset('assets/imagesFolder/A-Z.svg',),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: DailyAnalysisPage()));


                },
                child:  ActivityTabConstruct(title: kActivity,color1: widget.activityColor,color2:  widget.activityTextColor,),

              ),

              GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EasyAdminLogs()));


            },
            child: ActivityTabConstruct(title: kLog,color1: widget.logColor,color2:  widget.logTextColor,),

              ),


          ],
          ),
        ],
      ),
    );
  }

}


