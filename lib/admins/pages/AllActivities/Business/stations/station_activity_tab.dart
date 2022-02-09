import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_admin_log.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_sec.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Analysis/biz_daily_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/stations/sales.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/stations/station_daily.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/stations/station_home.dart';


import 'package:easy_homes/admins/partners/business_screen.dart';

import 'package:easy_homes/strings/strings.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

class StationActivityTab extends StatefulWidget {
  StationActivityTab({
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
  _StationActivityTabState createState() => _StationActivityTabState();
}

class _StationActivityTabState extends State<StationActivityTab> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationHome()));

              },
              child: ActivityTabConstruct(title: 'A-Z',color1: widget.azColor,color2:  widget.azTextColor,)),

          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationDailyAnalysisPage()));


            },
            child:  ActivityTabConstruct(title: kActivity,color1: widget.activityColor,color2:  widget.activityTextColor,),

          ),


          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationSales()));


            },
            child: ActivityTabConstruct(title: kLog,color1: widget.logColor,color2:  widget.logTextColor,),

          ),


        ],
      ),
    );
  }

}


