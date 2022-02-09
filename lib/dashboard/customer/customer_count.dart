import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/customer_month.dart';
import 'package:easy_homes/dashboard/customer/customer_week.dart';
import 'package:easy_homes/dashboard/customer/customer_year.dart';

import 'package:easy_homes/dashboard/customer/customer_bookings.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
class CustomerCount extends StatefulWidget {
  CustomerCount({required this.period});
  final String period;
  @override
  _CustomerCountState createState() => _CustomerCountState();
}

class _CustomerCountState extends State<CustomerCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        Navigator.pop(context);
                        Navigator.push(context,
                            PageTransition(
                                type: PageTransitionType
                                    .scale,
                                alignment: Alignment
                                    .bottomCenter,
                                child: CustomerBookings()));

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
                        Navigator.pop(context);
                        Navigator.push(context,
                            PageTransition(
                                type: PageTransitionType
                                    .scale,
                                alignment: Alignment
                                    .bottomCenter,
                                child: CustomerWeeklyBooking()));

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
                        Navigator.pop(context);
                        Navigator.push(context,
                            PageTransition(
                                type: PageTransitionType
                                    .scale,
                                alignment: Alignment
                                    .bottomCenter,
                                child: CustomerMonth()));

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
                        Navigator.pop(context);
                        Navigator.push(context,
                            PageTransition(
                                type: PageTransitionType
                                    .scale,
                                alignment: Alignment
                                    .bottomCenter,
                                child: CustomerYear()));

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
    );
  }
}
