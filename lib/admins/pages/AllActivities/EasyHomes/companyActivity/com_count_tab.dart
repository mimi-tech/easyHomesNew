import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_month.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_upcomings.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_week.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_year.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyAnalysis/com_Daily_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/upcomings.dart';

import 'package:page_transition/page_transition.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyCountTab extends StatelessWidget {
  CompanyCountTab({required this.counting,

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
                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyDailyAnalysisPage()));

                    },
                    child: TextWidget(name: 'All-Analysis',
                      textColor: analysisColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyActivitiesPage()));

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
                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyActivitiesPage()));

                            },

                            child: ActivityCard(title:'day',titleColor: cardColorToday,)),

                        GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyActivitiesPageWeekly()));

                            },
                            child: ActivityCard(title:'Week',titleColor: cardColorWeek,)),

                        GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyActivitiesPageMonthly()));

                            },
                            child: ActivityCard(title:'Month',titleColor: cardColorMonth,)),

                        GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyActivitiesPageYear()));

                            },
                            child: ActivityCard(title:'Year', titleColor: cardColorYear,))

                      ],
                    ),



                    Divider()

                  ],
                ),
              ),


            ]
        )
    );
  }
}



/*

Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(name: '${kVendor.toUpperCase()}- $counting',
            textColor: kDoneColor,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,),

          GestureDetector(
            onTap: (){

              Navigator.push(context,
                  PageTransition(
                      type: PageTransitionType
                          .scale,
                      alignment: Alignment
                          .bottomCenter,
                      child: CompanyUpcoming()));
            },
            child: TextWidget(name: kUpComing2,
              textColor: kDoneColor,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,),
          ),

          exam,

          PopupMenuButton(
              child: Container(
                decoration: BoxDecoration(
                    color: kDoneColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4)
                ),


                child:  Row(
                  children: <Widget>[
                    TextWidget(name: todayText,
                      textColor: kDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.bold,),

                    Icon(Icons.arrow_drop_down,color: kDoneColor,)
                  ],
                ),
              ),


              itemBuilder: (
                  context) => [
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: (){

                      Navigator.pop(context);

                      Navigator.push(context,
                          PageTransition(
                              type: PageTransitionType
                                  .scale,
                              alignment: Alignment
                                  .bottomCenter,
                              child: CompanyActivitiesPage()));
                    },
                    child:  TextWidget(
                      name:kToday,
                      textColor: kDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.normal,
                    ),

                  ),
                ),


                PopupMenuItem(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);

                      Navigator.push(context,
                          PageTransition(
                              type: PageTransitionType
                                  .scale,
                              alignment: Alignment
                                  .bottomCenter,
                              child: CompanyActivitiesPageWeekly()));
                    },

                    child:  TextWidget(
                      name:kWeekly,
                      textColor: kDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.normal,
                    ),

                  ),
                ),

                PopupMenuItem(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);

                      Navigator.push(context,
                          PageTransition(
                              type: PageTransitionType
                                  .scale,
                              alignment: Alignment
                                  .bottomCenter,
                              child: CompanyActivitiesPageMonthly()));
                    },
                    child:  TextWidget(
                      name:kMonthly,
                      textColor: kDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.normal,
                    ),

                  ),
                ),
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);

                      Navigator.push(context,
                          PageTransition(
                              type: PageTransitionType
                                  .scale,
                              alignment: Alignment
                                  .bottomCenter,
                              child: CompanyActivitiesPageYear()));
                    },

                    child:  TextWidget(
                      name:kYearly,
                      textColor: kDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.normal,
                    ),

                  ),
                ),
              ]
          ),

        ],
      ),
    );
*/