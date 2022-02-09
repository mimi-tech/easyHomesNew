import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/biz/business/B_all.dart';
import 'package:easy_homes/dashboard/biz/business/B_month.dart';
import 'package:easy_homes/dashboard/biz/business/B_today.dart';
import 'package:easy_homes/dashboard/biz/business/B_week.dart';
import 'package:easy_homes/dashboard/biz/business/B_year.dart';

import 'package:easy_homes/dashboard/earnings_construct.dart';
import 'package:easy_homes/dashboard/vendor/monthly_analysis.dart';

import 'package:easy_homes/dashboard/vendor/transactions.dart';
import 'package:easy_homes/dashboard/vendor/weekly_analysis.dart';
import 'package:easy_homes/dashboard/vendor/yearly_analysis.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/work/constructors/verify_construct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';

class BizEarnings extends StatefulWidget {
  @override
  _BizEarningsState createState() => _BizEarningsState();
}

class _BizEarningsState extends State<BizEarnings> {


  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05);
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(
        backgroundColor: kLightBrown,
        body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[

                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: kLightBrown,),

                StreamBuilder <QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('businessCount')
                        .where('bp', isEqualTo: Variables.userUid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: PlatformCircularProgressIndicator(),
                        );

                      } else {
                        final  List<Map<String, dynamic>> workingDocuments = snapshot.data!.docs as List<Map<String, dynamic>>;

                        return workingDocuments.length == 0
                            ? SizedBox(
                            height: MediaQuery.of(context).size.height * kHeight14,
                            child: NoEarning(title: kNoEarns,color2: kDoneColor,color1: kWhiteColor,))
                            : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: workingDocuments.length,
                            itemBuilder: (context, int index) {
                              return

                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          kCardBorder),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(height: 20.h,),
                                        TextWidgetAlign(
                                          name: kMyEarnings,
                                          textColor: kLightBrown,
                                          textSize: kFontSize,
                                          textWeight: FontWeight.bold,
                                        ),
                                        spacer(),
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: 30),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Card(
                                            elevation: 10,
                                            child: Column(
                                              children: <Widget>[
                                                spacer(),
                                                TextWidgetAlign(
                                                  name: kMyEarningsTotal.toUpperCase(),
                                                  textColor: kRadioColor,
                                                  textSize: kFontSize14,
                                                  textWeight: FontWeight.w500,
                                                ),
                                                MoneyFormatColors(
                                                  color: kTextColor,
                                                  title: TextWidgetAlign(
                                                    name: '${VariablesOne.numberFormat.format(workingDocuments[index]['p1y']).toString()}',
                                                    textColor: kTextColor,
                                                    textSize: kFontSize,
                                                    textWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        spacer(),
                                        EarningsPeriod(),
                                        spacer(),
                                        Divider(thickness: 2.0,),

                                        EarningsConstruct(period: 'All',
                                          number: workingDocuments[index]['ab'].toString(),
                                          title: '${VariablesOne.numberFormat.format(workingDocuments[index]['all']).toString()}',
                                          open: (){
                                            Navigator.push(context, PageTransition(
                                                type: PageTransitionType.rightToLeft,
                                                child: BAll()));
                                          },
                                        ),

                                        EarningsConstruct(period: kToday,
                                          number: DateTime.now().day == workingDocuments[index]['day']?workingDocuments[index]['dai'].toString():'0',
                                          title: DateTime.now().day == workingDocuments[index]['day']?'${VariablesOne.numberFormat.format(workingDocuments[index]['p1d']).toString()}':'0.00',
                                          open: (){
                                            Navigator.push(context, PageTransition(
                                                type: PageTransitionType.rightToLeft,
                                                child: BToday()));
                                          },
                                        ),


                                        EarningsConstruct(period: kWeekly,
                                          number: Jiffy().week == workingDocuments[index]['wky']?workingDocuments[index]['wkb'].toString():'0',
                                          title: Jiffy().week == workingDocuments[index]['wky']?'${VariablesOne.numberFormat.format(workingDocuments[index]['p1w']).toString()}':'0.00',
                                          open: (){
                                            Navigator.push(context, PageTransition(
                                                type: PageTransitionType.rightToLeft,
                                                child: BWeek()));
                                          },
                                        ),


                                        EarningsConstruct(period: kMonthly,
                                          number: DateTime.now().month == workingDocuments[index]['mth']?workingDocuments[index]['mtb'].toString():'0',
                                          title: DateTime.now().month == workingDocuments[index]['mth']?'${VariablesOne.numberFormat.format(workingDocuments[index]['p1m']).toString()}':'0.00',
                                          open: (){
                                            Navigator.push(context, PageTransition(
                                                type: PageTransitionType.rightToLeft,
                                                child: BMonth()));
                                          },
                                        ),

                                        EarningsConstruct(period: kYearly,
                                          number: DateTime.now().year == workingDocuments[index]['yr']?workingDocuments[index]['yb'].toString():'0',
                                          title: DateTime.now().year == workingDocuments[index]['yr']?'${VariablesOne.numberFormat.format(workingDocuments[index]['p1y']).toString()}':'0.00',

                                          open: (){
                                            Navigator.push(context, PageTransition(
                                                type: PageTransitionType.rightToLeft,
                                                child: BYear()));
                                          },
                                        ),




                                      ],
                                    ),
                                  ),
                                );
                            }
                        );
                      }
                    }
                )
              ],
            )


        )
    )
    );
  }



}

