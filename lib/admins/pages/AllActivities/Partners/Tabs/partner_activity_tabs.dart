
import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_activity.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Analysis/partner_daily_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_admin_log.dart';

import 'package:easy_homes/admins/partners/partner_screen.dart';


import 'package:easy_homes/strings/strings.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

class PartnerActivityPage extends StatefulWidget {
  PartnerActivityPage({
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
  _PartnerActivityPageState createState() => _PartnerActivityPageState();
}

class _PartnerActivityPageState extends State<PartnerActivityPage> {
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
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PartnerScreen(),
                  ),
                      (route) => false,
                );
              },
              child: ActivityTabConstruct(title: 'A-Z',color1: widget.azColor,color2:  widget.azTextColor,)),


          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerDailyAnalysisPage()));


            },
            child:  ActivityTabConstruct(title: kActivity,color1: widget.activityColor,color2:  widget.activityTextColor,),

          ),


          GestureDetector(
            onTap: (){

              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerAdminLogs()));


            },
            child: ActivityTabConstruct(title: kLog,color1: widget.logColor,color2:  widget.logTextColor,),

          ),


        ],
      ),
    );
  }

}


