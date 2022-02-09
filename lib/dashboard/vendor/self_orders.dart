import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/customer_upcoming.dart';
import 'package:easy_homes/dashboard/customer/ongoing_order.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class VendorSelfOrders extends StatefulWidget {
  VendorSelfOrders({required this.ongoing});
  final dynamic ongoing;
  @override
  _VendorSelfOrdersState createState() => _VendorSelfOrdersState();
}

class _VendorSelfOrdersState extends State<VendorSelfOrders> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.01);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),

      child: Card(
        elevation: kCardElevation2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardBorder ),),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: kCardVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              spacer(),
              TextWidget(
                name: 'My ORDERS'.toUpperCase(),
                textColor: kDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.bold,
              ),
              spacer(),
              Row(
                children: <Widget>[
                  ProfilePicture(),
                  SizedBox(width:imageRightShift.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
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


                    Navigator.push(context, PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: CustomerUpcomingBookings()));



                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(

                      text: TextSpan(text:'my Upcoming orders'.toUpperCase(),
                          style: GoogleFonts.oxanium(
                            fontSize: ScreenUtil().setSp(
                                kFontSize14, ),
                            color: kTextColor,
                            fontWeight: FontWeight.bold,
                          ),


                      ),


                    ),

                    IconButton(icon: Icon(
                        Icons.arrow_forward_ios
                    ), onPressed: (){
                      Navigator.push(context, PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: CustomerUpcomingBookings()));


                    })                  ],
                ),
              ),

              spacer(),
              Divider(),
              spacer(),


              GestureDetector(

                onTap: (){
                  if(DashboardConstants.ongoingOrders.length == 0){
                    YYAlertDialogWithDuration();
                  }else{
                    Navigator.push(context, PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: OngoingOrder()));
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextWidget(
                      name: '${kOngoingOrder.toUpperCase()} ( ${widget.ongoing} )' ,
                      textColor: kTextColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.bold,
                    ),
                    IconButton(icon: Icon(
                        Icons.arrow_forward_ios
                    ), onPressed: (){

                      if(DashboardConstants.ongoingOrders.length == 0){
                        YYAlertDialogWithDuration();
                      }else{
                        Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: OngoingOrder()));
                      }

                    })
                  ],
                ),
              ),


              /*spacer(),
              Divider(),
              spacer(),


              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OrdersHistory()));

                  },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextWidget(
                      name: '${kOrderHistory.toUpperCase()} ( ${widget.orderHistory} )' ,
                      textColor: kTextColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.bold,
                    ),
                    IconButton(icon: Icon(
                        Icons.arrow_forward_ios
                    ), onPressed: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OrdersHistory()));

                    })
                  ],
                ),
              ),*/
              spacer(),
              Divider(),
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
      ..gravity = Gravity.leftBottom
      ..duration = Duration(milliseconds: 400)



      ..text(
        padding: EdgeInsets.all(18),
        text: 'Ongoing Order',
        color: kLightBrown,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        alignment: Alignment.center,

      )
      ..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18),
        text: 'Sorry ${Variables.userFN!} you have no ongoing booking,',
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
