import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/Analysis/daily_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/Analysis/monthly_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/Analysis/weekly_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/Analysis/yearly_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_activity.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Analysis/partner_daily_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Analysis/partner_monthly_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Analysis/partner_weekly_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Analysis/partner_yearly_analysis.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PartnerAnalysisTab extends StatelessWidget {
  PartnerAnalysisTab({required this.counting,
    required this.todayText,
    required this.analysisText,
    required this.analysisColor,
    required this.currentColor,
    required this.cardColorToday,
    required this.cardColorWeek,
    required this.cardColorMonth,
    required this.cardColorYear,

  });
  final String counting;
  final String todayText;
  final String analysisText;
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
            // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(name: '${kVendor.toUpperCase()}- $counting',
                  textColor: kDoneColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,),


                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerDailyAnalysisPage()));

                  },
                  child: TextWidget(name: 'All-Analysis',
                    textColor: analysisColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerVendorActivitiesPage()));

                  },
                  child: TextWidget(name: 'C / Analysis',
                    textColor: currentColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,),
                ),




              ],
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
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerDailyAnalysisPage()));

                          },

                          child: AnalysisCard(title:kToday,titleColor: cardColorToday,)),

                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerWeeklyAnalysisPage()));

                          },
                          child: AnalysisCard(title:kWeekly,titleColor: cardColorWeek,)),

                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerMonthlyAnalysisPage()));

                          },
                          child: AnalysisCard(title: kMonthly,titleColor: cardColorMonth,)),

                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerYearlyAnalysisPage()));

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

