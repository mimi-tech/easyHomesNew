import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dashboard/vendor/orders.dart';
import 'package:easy_homes/dashboard/vendor/upcoming_bookings.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class ViewOrders extends StatefulWidget {
  ViewOrders({required this.orderCount,required this.orderHistory,required this.totalOrder});
  final int orderCount;
  final String orderHistory;
  final dynamic totalOrder;
  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.0);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),

      child: Card(
        elevation: kCardElevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              kCardBorder ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: kCardVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              spacer(),
              TextWidget(
                name: 'VENDOR ORDERS'.toUpperCase(),
                textColor: kDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.bold,
              ),
              spacer(),
              Row(
                children: <Widget>[
                  ProfilePicture(),
                  SizedBox(width: 4,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextWidget(
                        name: '${Variables.userFN! } ${Variables.userLN }',
                        textColor: kTextColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w400,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star,color: kLightBrown,size: kStarSize,),
                          Padding(
                            padding: const EdgeInsets.only(top:kStarTop,left: kStarLeft),
                            child: TextWidget(
                              name: Variables.currentUser[0]['rate'] == null?'1.0':'${Variables.currentUser[0]['rate'] }',
                              textColor: kTextColor,
                              textSize: kFontSize12,
                              textWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                    ],
                  )
                ],
              ),


              spacer(),
              Divider(),
              spacer(),

              GestureDetector(
onTap: (){
  VariablesOne.isUpcoming = true;
  if(DashboardConstants.upcomingOrders.length == 0) {
    YYAlertDialogWithDuration();
  }else{
    Navigator.push(context, PageTransition(
        type: PageTransitionType.rightToLeft,
        child: UpcomingBookings()));


  }
},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(

                      text: TextSpan(text:kUpcoming,
                          style: GoogleFonts.oxanium(
                            fontSize: ScreenUtil().setSp(
                                kFontSize14, ),
                            color: kTextColor,
                            fontWeight: FontWeight.bold,
                          ),

                          children: <TextSpan>[
                            TextSpan(
                              text: ' (',
                              style: GoogleFonts.oxanium(
                                fontSize: ScreenUtil().setSp(
                                    kFontSize, ),
                                color: kTextColor,
                              ),
                            ),

                            TextSpan(
                              text: widget.orderCount.toString(),
                              style: GoogleFonts.oxanium(
                                fontSize: ScreenUtil().setSp(
                                    kFontSize, ),
                                color: kLightBrown,
                              ),
                            ),

                            TextSpan(
                              text: ')',
                              style: GoogleFonts.oxanium(
                                fontSize: ScreenUtil().setSp(
                                    kFontSize, ),
                                color: kTextColor,
                              ),
                            ),
                          ]
                      ),


                    ),

                    IconButton(icon: Icon(
                        Icons.arrow_forward_ios
                    ), onPressed: (){
                      VariablesOne.isUpcoming = true;
                      if(DashboardConstants.upcomingOrders.length == 0) {
                        YYAlertDialogWithDuration();
                            }else{
                        Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: UpcomingBookings()));


                      }
                    })
                  ],
                ),
              ),
              spacer(),
              Divider(),
              spacer(),


              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: MyOrders()));

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextWidget(
                      name: '${kOrderHistory.toUpperCase()}${widget.orderHistory}' ,
                      textColor: kTextColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.bold,
                    ),
                    IconButton(icon: Icon(
                        Icons.arrow_forward_ios
                    ), onPressed: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: MyOrders()));

                    })
                  ],
                ),
              ),
              spacer(),
              Divider(),
              spacer(),


              Padding(
                padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                child: RichText(

                  text: TextSpan(text:'Total Order count: '.toUpperCase(),
                      style: GoogleFonts.oxanium(
                        fontSize: ScreenUtil().setSp(
                            kFontSize14, ),
                        color: kTextColor,
                        fontWeight: FontWeight.bold,
                      ),

                      children: <TextSpan>[
                        TextSpan(
                          text: widget.totalOrder,
                          style: GoogleFonts.oxanium(
                            fontSize: ScreenUtil().setSp(
                                kFontSize, ),
                            color: kYellow,

                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ]
                  ),


                ),
              ),
              spacer(),
              spacer(),

            ],
          ),
        ),
      ),
    );
  }

  YYDialog YYAlertDialogWithDuration() {
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 4
      ..gravityAnimationEnable = true
      ..gravity = Gravity.right
      ..duration = Duration(milliseconds: 400)


      ..text(
        padding: EdgeInsets.all(18),
        text: 'Upcoming Order(s)',
        color: kLightBrown,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        alignment: Alignment.center,

      )..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
        text: 'Hello ${Variables.userFN!} you have no  upcoming order',
        color: kTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        alignment: Alignment.center,
      )
      ..doubleButton(
        padding: EdgeInsets.only(right: 10.0),
        gravity: Gravity.right,
        text1: "OK, Got it",
        color1: kDoneColor,
        fontSize1: 18.0,
        fontWeight1: FontWeight.bold,

      )
      ..show();
  }
}
