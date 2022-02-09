import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/vendor/monthly_analysis.dart';
import 'package:easy_homes/dashboard/vendor/transactions.dart';

import 'package:easy_homes/dashboard/vendor/weekly_analysis.dart';
import 'package:easy_homes/dashboard/vendor/yearly_analysis.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
class DailyRow extends StatefulWidget {
  DailyRow({required this.period});
  final String period;
  @override
  _DailyRowState createState() => _DailyRowState();
}

class _DailyRowState extends State<DailyRow> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PopupMenuButton(
                child: Container(
                  color: kLightBrown.withOpacity(0.2),

                  child: Row(
                    children: <Widget>[
                      TextWidget(
                        name:widget.period,
                        textColor: kLightBrown,
                        textSize: kFontSize14,
                        textWeight: FontWeight.bold,
                      ),

                      Icon(Icons.arrow_drop_down,color: kLightBrown,)
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
                                  child: BookingTransaction()));

                        },
                        child:  TextWidget(
                          name:kToday,
                          textColor: kTextColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.bold,
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
                                  child: WeeklyBookingTransaction()));

      },
                        child:  TextWidget(
                          name:kWeekly,
                          textColor: kTextColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.bold,
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
                                  child: MonthlyBookingTransaction()));

                        },

                        child:  TextWidget(
                          name:kMonthly,
                          textColor: kTextColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.bold,
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
                                  child: YearlyBookingTransaction()));

                        },

                        child:  TextWidget(
                          name:kYearly,
                          textColor: kTextColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.bold,
                        ),

                      ),
                    ),
                    ]
              ),
VerticalLine(),
              Row(
                children: <Widget>[
              SvgPicture.asset('assets/imagesFolder/small_cy.svg',),

                  TextWidget(
                    name:'Orders',
                    textColor: kTextColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.bold,
                  ),


                ],
              ),
              VerticalLine(),
              TextWidget(
                name:'AMOUNT'.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}









class DailyRowSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextWidget(
              name:'Date',
              textColor: kLightBrown,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),
            SizedBox(width: 20,),
            VerticalLine(),

            TextWidget(
              name:'Details',
              textColor: kLightBrown,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),
            VerticalLine(),
            TextWidget(
              name:'Amount',
              textColor: kLightBrown,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
