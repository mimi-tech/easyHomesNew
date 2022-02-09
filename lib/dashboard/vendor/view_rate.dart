import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/transactionTabs.dart';
import 'package:easy_homes/dashboard/dashbarTab.dart';
import 'package:easy_homes/dashboard/promo.dart';
import 'package:easy_homes/dashboard/vendor/daily_analysis.dart';
import 'package:easy_homes/dashboard/vendor/payment.dart';
import 'package:easy_homes/dashboard/vendor/transactions.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class ViewRatings extends StatefulWidget {

  @override
  _ViewRatingsState createState() => _ViewRatingsState();
}

class _ViewRatingsState extends State<ViewRatings> {


  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.01);
  }
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Card(
          elevation: kCardElevation2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                kCardBorder ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
            spacer(),
Row(
  children: <Widget>[
        ProfilePicture(),
       SizedBox(width:imageRightShift.w),
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

                Divider(),
          spacer(),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PromoScreen()));
                    },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kReferialEarnings.toUpperCase(),
                        textColor: kTextColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.bold,
                      ),
                      MoneyFormatColors(
                        color: kLightBrown,
                        title: TextWidget(
                          name: '${VariablesOne.numberFormat.format(Variables.currentUser[0]['refact']).toString()}',
                          textColor: kLightBrown,
                          textSize: kFontSize14,
                          textWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
                spacer(),
                Divider(),
                spacer(),

                GestureDetector(
                  onTap: (){
                    //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: DailyAnalysis()));
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorTxnTab()));


                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(

                        text: TextSpan(text:kMyEarnings,
                            style: GoogleFonts.oxanium(
                              fontSize: ScreenUtil().setSp(
                                  kFontSize14, ),
                              color: kTextColor,
                              fontWeight: FontWeight.bold,
                            ),

                            children: <TextSpan>[
                              TextSpan(
                                text: Variables.currentUser[0]['er'] == null?'( 0.00 )':'( #${VariablesOne.numberFormat.format(Variables.currentUser[0]['er']).toString()} )',
                                style: GoogleFonts.oxanium(
                                  fontSize: ScreenUtil().setSp(
                                      kFontSize12, ),
                                  color: kSeaGreen,
                                ),
                              ),
                            ]
                        ),


                      ),
                        IconButton(icon: Icon(
                          Icons.arrow_forward_ios
                        ), onPressed: (){
                          //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: DailyAnalysis()));
                          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorTxnTab()));

                        })

                    ],
                  ),
                ),



                spacer(),
                Divider(),
                spacer(),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(

                      text: TextSpan(text:kWithdrawa,
                          style: GoogleFonts.oxanium(
                            fontSize: ScreenUtil().setSp(
                                kFontSize14, ),
                            color: kTextColor,
                            fontWeight: FontWeight.bold,
                          ),

                          children: <TextSpan>[
                            TextSpan(
                              text: '( #${ '98978'} )',
                              style: GoogleFonts.oxanium(
                                fontSize: ScreenUtil().setSp(
                                    kFontSize12, ),
                                color: kLogoColor2,
                              ),
                            ),
                          ]
                      ),


                    ),

                    IconButton(icon: Icon(
                        Icons.arrow_forward_ios
                    ), onPressed: (){

                    })
                  ],
                ),
                spacer(),
                Divider(),
                spacer(),

                GestureDetector(
                  onTap: (){
                   // Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentTransaction()));
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: DashBoardTab()));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        name: kAllTrans.toUpperCase(),
                        textColor: kTextColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.bold,
                      ),

                      IconButton(icon: Icon(
                          Icons.arrow_forward_ios
                      ), onPressed: (){
                       // Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentTransaction()));
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: DashBoardTab()));

                      })
                    ],
                  ),
                ),
            spacer(),
        Divider(),
        spacer(),




              ],
            ),
          ),
        ),
      ),
    );
  }
}
