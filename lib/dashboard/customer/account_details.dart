import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/transactions/paymentList.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/biz/business/biz_earnings.dart';
import 'package:easy_homes/dashboard/biz/partner/partner_earnings.dart';
import 'package:easy_homes/dashboard/customer/customer_bookings.dart';
import 'package:easy_homes/dashboard/customer/transactionTabs.dart';
import 'package:easy_homes/dashboard/dashbarTab.dart';
import 'package:easy_homes/dashboard/promo.dart';
import 'package:easy_homes/dashboard/vendor/payment.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/dashboard/vendor/transactions.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:page_transition/page_transition.dart';
class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {


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
            borderRadius: BorderRadius.circular(kCardBorder ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: kCardVertical),
            child: Column(
              children: <Widget>[
                spacer(),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    name: kAccount.toUpperCase(),
                    textColor: kDoneColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.bold,
                  ),
                ),
                spacer(),

                Row(
                  children: <Widget>[
                    ProfilePicture(),
                    SizedBox(width:imageRightShift.w),

                    TextWidget(
                      name: '${Variables.userFN! } ${Variables.userLN }',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w400,
                    )
                  ],
                ),

                Divider(),
                spacer(),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PromoScreen()));


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
                      )


                    ],
                  ),
                ),

                Variables.userCat == AdminConstants.partner ||
                    Variables.userCat == AdminConstants.business ||
                    Variables.userCat == AdminConstants.owner?
                Column(
                  children: [
                    spacer(),
                    Divider(),
                    spacer(),
                    GestureDetector(
                      onTap: (){
                        if(Variables.userCat == AdminConstants.owner){
                          print('yyyyyyyy');
                          //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: OwnerEarnings()));
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: OwnerTxnTab()));

                        }else if(Variables.userCat == AdminConstants.partner) {
                          print('oooooooooo');
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PartnerTxnTab()));

                        }else if(Variables.userCat == AdminConstants.business){
                               print('kkkkkkk');
                          //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: BizEarnings()));
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DashboardTxnTab()));


                        }

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
                                          14, ),
                                      color: kSeaGreen,
                                    ),
                                  ),
                                ]
                            ),


                          ),
                          IconButton(icon: Icon(
                              Icons.arrow_forward_ios
                          ), onPressed: (){
                            if(Variables.userCat == AdminConstants.owner){
                              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: OwnerEarnings()));
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: OwnerTxnTab()));

                            }else if(Variables.userCat == AdminConstants.partner) {
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.fade,
                                  child: PartnerTxnTab()));

                            }else if(Variables.userCat == AdminConstants.business){
                              // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: BizEarnings()));
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DashboardTxnTab()));


                               }
                          }
                          ),

                        ],
                      ),
                    ),
                  ],
                ):Visibility(
                    visible: false,
                    child: Text('')),

                spacer(),
                Divider(),
                spacer(),

                GestureDetector(
                  onTap: (){
                    //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentTransaction()));
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DashBoardTab()));


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
                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DashBoardTab()));

                      })
                    ],
                  ),
                ),




                spacer(),
                Divider(),
                spacer(),


                Variables.userCat == AdminConstants.owner?Column(
                  children: [

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllPaymentTrans()));


                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('All payment'.toUpperCase(),
                            style: GoogleFonts.oxanium(
                              fontSize: ScreenUtil().setSp(
                                  kFontSize14, ),
                              color: kTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(icon: Icon(
                              Icons.arrow_forward_ios
                          ), onPressed: (){
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllPaymentTrans()));

                          })

                        ],
                      ),
                    ),
                    spacer(),
                    Divider(),
                    spacer(),

                  ],
                ):Text('')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
