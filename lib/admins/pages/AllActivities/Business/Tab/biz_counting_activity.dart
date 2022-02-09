import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_monthly.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_upcoming.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_weekly.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_yearly.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Analysis/biz_daily_analysis.dart';

import 'package:page_transition/page_transition.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BizCountingActivity extends StatelessWidget {
  BizCountingActivity({required this.counting,

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
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * kDoubleSpace,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextWidget(name: '${kVendor.toUpperCase()}- $counting',
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),


              GestureDetector(
                onTap: (){

                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BizDailyAnalysisPage()));

                },
                child: TextWidget(name: 'All-Analysis',
                  textColor: analysisColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,),
              ),

             /* GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BizActivitiesPage()));

                },
                child: TextWidget(name: 'C / Analysis',
                  textColor: currentColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,),
              ),
*/

            ],
          ),

          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[
                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BizActivitiesPage()));

                      },

                      child: ActivityCard(title:'day',titleColor: cardColorToday,)),


                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BizActivitiesPageWeekly()));

                      },
                      child: ActivityCard(title:'Week',titleColor: cardColorWeek,)),

                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BizActivitiesPageMonthly()));

                      },
                      child: ActivityCard(title:'Month',titleColor: cardColorMonth,)),

                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BizActivitiesPageYearly()));

                      },
                      child: ActivityCard(title:'Year', titleColor: cardColorYear,))


                ],
              ),

              Divider(),
            ],
          )
        ],
      ),
    );
  }
}


