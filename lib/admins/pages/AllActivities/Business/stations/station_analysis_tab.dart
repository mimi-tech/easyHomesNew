import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Analysis/biz_daily_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Analysis/biz_monthly_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Analysis/biz_weekly_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Analysis/biz_yearly_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/stations/station_yearly.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/stations/station_daily.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/stations/station_month.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/stations/station_weekly.dart';

import 'package:page_transition/page_transition.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StationAnalysisTab extends StatelessWidget {

  StationAnalysisTab({required this.counting,
    required this.analysisColor,
    required this.currentColor,
    required this.cardColorToday,
    required this.cardColorWeek,
    required this.cardColorMonth,
    required this.cardColorYear,

  });
  final String counting;
  final Color analysisColor;
  final Color currentColor;
  final Color cardColorToday;
  final Color cardColorWeek;
  final Color cardColorMonth;
  final Color cardColorYear;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * kDoubleSpace,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationDailyAnalysisPage()));

              },
              child: TextWidget(name: 'All-Analysis',
                textColor: analysisColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),
            ),
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationDailyAnalysisPage()));

                          },

                          child: AnalysisCard(title:kToday,titleColor: cardColorToday,)),

                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationWeeklyAnalysisPage()));

                          },
                          child: AnalysisCard(title:kWeekly,titleColor: cardColorWeek,)),

                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationMonthlyAnalysisPage()));

                          },
                          child: AnalysisCard(title: kMonthly,titleColor: cardColorMonth,)),

                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationYearlyAnalysisPage()));

                          },
                          child: AnalysisCard(title: kYearly, titleColor: cardColorYear,))

                    ],
                  ),



                  Divider()

                ],
              ),
            ),


          ]
      ),
    );
  }
}
