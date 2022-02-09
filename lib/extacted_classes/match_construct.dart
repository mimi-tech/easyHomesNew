import 'dart:async';

import 'package:easy_homes/bookings/cached_bookings.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/details_order.dart';
import 'package:easy_homes/payment/methods.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';

class MatchConstruct extends StatefulWidget {
  @override
  _MatchConstructState createState() => _MatchConstructState();
}

class _MatchConstructState extends State<MatchConstruct> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  Widget spacerWidth() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.02);
  }
  final numberFormat = new NumberFormat("#,##0", "en_US");
  dynamic total = 0;
late  Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   //_timer =  Timer.periodic(Duration(milliseconds: 500), (Timer t) => setState((){}));

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(

              borderRadius: BorderRadius.only(
                topRight: Radius.circular(kmodalborderRadius),
                topLeft: Radius.circular(kmodalborderRadius),
              )),
          child: Column(
            children: <Widget>[

              spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SvgPicture.asset('assets/imagesFolder/pick_up.svg',),

                  Container(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil()
                            .setWidth(200),
                        minHeight: ScreenUtil()
                            .setHeight(20),
                      ),
                      child: ReadMoreText(Variables.buyingGasType!.toUpperCase(),
                        trimLines: 1,
                        colorClickableText: kLightBrown,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' ...',
                        trimExpandedText: '  less',
                        style: GoogleFonts.oxanium(
                            fontSize: ScreenUtil().setSp(kFontSize, ),
                            color: kLightBrown,
                            fontWeight: FontWeight.w500

                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),

        // spacer(),

        DividerLine(),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: PaymentMethods()));
                      },
                      child: Row(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                text: 'Pay type: ',
                                style: GoogleFonts.oxanium(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil()
                                      .setSp(
                                      kFontSize16, ),
                                  color: kTextColor,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: Variables.currentUser[0]['mp'],
                                    style: GoogleFonts.oxanium(
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil()
                                          .setSp(
                                          kFontSize16, ),
                                      color: kProfile,
                                    ),
                                  )
                                ]),

                          ),


                          Icon(Icons.edit, size: 18,),
                        ],
                      ),
                    ),
                    SizedBox(height: 25,),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if(VariablesOne.checkOneTrue2 == true){
                           /* Navigator.push(context, PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: CachedBookings()));*/
                          }else {
                            Navigator.push(context, PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: DetailsOrder()));
                          }
                        },
                        child: TextWidget(
                          name: kViewOrder,
                          textColor: kLightDoneColor,
                          textSize: kFontSize16,
                          textWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                VerticalLine(),

                Variables.sumCylinder == null
                    ? Column(
                      children: [
                        Row(
                          children: <Widget>[
                            TextWidget(
                              name: 'Delivery fee',
                              textColor: kTextColor,
                              textSize: kFontSize16,
                              textWeight: FontWeight.w600,
                            ),
                            spacerWidth(),
                            MoneyFormatColors(
                              color: kLightBrown,
                              title: TextWidget(
                                name: '${numberFormat.format(VariablesOne.deliveryFee).toString()}',
                                textColor: kLightBrown,
                                textSize: kFontSize16,
                                textWeight: FontWeight.w600,
                              ),
                            )

                          ],
                        ),
                        //SizedBox(height: kMatchSpace,),
                        SizedBox(height: 25,),
                        Row(
                          children: [
                            TextWidget(
                              name: 'Est. Total',
                              textColor: kTextColor,
                              textSize: kFontSize16,
                              textWeight: FontWeight.w600,
                            ),
                            spacerWidth(),
                            MoneyFormatColors(
                                color: kSeaGreen,
                                title:  TextWidget(
                                  name: Variables.buyCylinder?' \n${numberFormat.format(total)}':
                                 // '${numberFormat.format(Variables.gasEstimatePrice + VariablesOne.deliveryFee).toString()}',
                                  '${numberFormat.format(Variables.grandTotal + VariablesOne.deliveryFee).toString()}',
                                  textColor: kSeaGreen,
                                  textSize: kFontSize16,
                                  textWeight: FontWeight.w600,
                                )),
                          ],
                        ),


                      ],
                    )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        TextWidget(
                          name: '$kGP',
                          textColor: kTextColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w600,
                        ),
                        spacerWidth(),
                        MoneyFormatColors(
                          color: kLightBrown,
                        title:TextWidget(
                          name: '${numberFormat.format(Variables.gasEstimatePrice).toString()}',
                          textColor: kLightBrown,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w600,
                        ),

                        )

                      ],
                    ),
                    SizedBox(height: kMatchSpace,),
                    Row(
                      children: <Widget>[
                        TextWidget(
                          name: kNC,
                          textColor: kTextColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w600,
                        ),

                        spacerWidth(),
                        MoneyFormatColors(
                          color: kLightBrown,
                          title: TextWidget(
                            name: '${numberFormat.format(Variables.sumCylinder).toString()}',
                            textColor: kLightBrown,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w600,
                          ),
                        )

                      ],
                    ),
                    SizedBox(height: kMatchSpace,),
                    Row(
                      children: <Widget>[
                        TextWidget(
                          name: 'Delivery fee',
                          textColor: kTextColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w600,
                        ),
                        spacerWidth(),
                        MoneyFormatColors(
                          color: kLightBrown,
                          title:  TextWidget(
                          name: '${numberFormat.format(VariablesOne.deliveryFee).toString()}',
                          textColor: kLightBrown,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w600,
                        ),)

                      ],
                    ),
                    SizedBox(height: kMatchSpace,),
                    Row(
                      children: [
                        TextWidget(
                          name: 'Total',
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.w600,
                        ),
                        spacerWidth(),
                        MoneyFormatColors(
                            color: kSeaGreen,
                            title:  TextWidget(
                          name: '${numberFormat.format(Variables.grandTotal + VariablesOne.deliveryFee).toString()}',
                          textColor: kSeaGreen,
                          textSize: kFontSize,
                          textWeight: FontWeight.w600,
                        )),
                      ],
                    )

                  ],
                ),
              ],
            ),
          ),
        ),


        DividerLine(),
      ],
    );
  }


}
