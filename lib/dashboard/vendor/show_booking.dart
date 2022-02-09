import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/extacted_classes/order_details.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/extacted_classes/details_list.dart';
import 'package:easy_homes/utils/newCylinderList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/vendor/show_booking.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
class ShowBookingDetails extends StatefulWidget {
  ShowBookingDetails({
    required this.doc,

  });


  final DocumentSnapshot doc;


  @override
  _ShowBookingDetailsState createState() => _ShowBookingDetailsState();
}

class _ShowBookingDetailsState extends State<ShowBookingDetails> {


  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.025);
  }





  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          space(),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                TextWidgetAlign(
                  name: 'Booked'.toUpperCase(),
                  textColor: kLightBrown,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,),


                Align(
                  alignment: Alignment.topRight,
                  child: VendorPix(pix: widget.doc['vpi'],pixColor: Colors.transparent,)
                )
              ],
            ),

          ),
          space(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: kLightBrown.withOpacity(0.1),
                height:kBookedDateHeight.h,
                width: kBookedDateWidth.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextWidgetAlign(
                      name: '${ DateFormat('d' ).format(DateTime.parse(widget.doc['dd']))}',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,),

                    TextWidgetAlign(
                      name: '${ DateFormat('MMM' ).format(DateTime.parse(widget.doc['dd']))}'.toUpperCase(),
                      textColor: kTextColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,),
                  ],
                ),

              ),

             SizedBox(width: 10.w,),
              Container(
                color: kLightBrown.withOpacity(0.1),
                height:kBookedDateHeight.h,
                width: kBookedDateWidth.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextWidgetAlign(
                      name: '${ DateFormat('h:mm a').format(DateTime.parse(widget.doc['dd']))}',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,),

                    TextWidgetAlign(
                      name: 'TIME'.toString().toUpperCase(),
                      textColor: kTextColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,),
                  ],
                ),

              )
            ],
          ),



space(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.topRight,
            child: SvgPicture.asset(widget.doc['bg']),
          ),




          Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Row(
             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset('assets/imagesFolder/dot.svg',),
                SizedBox(width: kHorizontal,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      name: 'To',
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,),

                    Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil()
                              .setWidth(250),
                          minHeight: ScreenUtil()
                              .setHeight(20),
                        ),
                        child: ReadMoreText(
                          widget.doc['ad'],
                          //doc.data['desc'],
                          trimLines: 1,
                          colorClickableText: kLightBrown,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' ...',
                          trimExpandedText: '  less',
                          style: GoogleFonts.oxanium(
                              fontSize: ScreenUtil().setSp(kFontSize, ),
                              color: kTextColor,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),

          space(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset('assets/imagesFolder/dot.svg',),
                SizedBox(width: kHorizontal,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    TextWidget(
                      name: 'Customer Name',
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,),

                    TextWidget(
                      name: '${widget.doc['fn']} ${widget.doc['ln']}',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,),


                  ],
                ),

              ],
            ),
          ),
          space(),

          Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset('assets/imagesFolder/dot.svg',),
                SizedBox(width: kHorizontal,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    TextWidget(
                      name: 'Customer Phone Number',
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,),

                    TextWidget(
                      name: '${widget.doc['ph']}',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,),



                  ],
                ),
                Spacer(),
                GestureDetector(
                    onTap: () async {
                      var url = "tel:${widget.doc['ph'].trim()}";
                      if (await canLaunch(url)) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';

                      
                      }
                    },
                    child: Icon(Icons.call,color: kDoneColor,))

              ],
            ),
          ),
          space(),

          Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset('assets/imagesFolder/dot.svg',),
                SizedBox(width: kHorizontal,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    TextWidget(
                      name: 'Pay type',
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,),

                    TextWidget(
                      name: widget.doc['mp'],
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,),


                  ],
                ),

              ],
            ),
          ),




          space(),

          Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset('assets/imagesFolder/dot.svg',),
                SizedBox(width: kHorizontal,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    TextWidget(
                      name: 'Type',
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,),

                    Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtil()
                              .setWidth(250),
                          minHeight: ScreenUtil()
                              .setHeight(20),
                        ),
                        child: ReadMoreText(
                          widget.doc['bgt'],
                          //doc.data['desc'],
                          trimLines: 1,
                          colorClickableText: kLightBrown,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' ...',
                          trimExpandedText: '  less',
                          style: GoogleFonts.oxanium(
                              fontSize: ScreenUtil().setSp(kFontSize, ),
                              color: kTextColor,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
          space(),








          Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset('assets/imagesFolder/dot.svg',),
                SizedBox(width: kHorizontal,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    TextWidget(
                      name: kDetails2,
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w400,),

                    GestureDetector(
                      onTap:(){

                        getBookingDetails();
                      },
                      child: TextWidget(
                        name: kDetails,
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,),
                    ),


                  ],
                ),

              ],
            ),
          ),
          space(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: kLightBrown.withOpacity(0.1),

                child:Container(
                  color: kLightBrown.withOpacity(0.1),
                  height:kBookedDateHeight.h,
                  width: kBookedDateWidth.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MoneyFormatColors(
                        color:kTextColor,
                        title:   TextWidgetAlign(
                          name: '${VariablesOne.numberFormat.format(widget.doc['amt']).toString()}',
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.w500,),

                      ),


                      TextWidgetAlign(
                        name: 'Estimate',
                        textColor: kRadioColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w400,),
                    ],
                  ),

                ),
              ),

              SizedBox(width: 10.w,),
              Container(
                color: kLightBrown.withOpacity(0.1),

                child: Container(
                  color: kLightBrown.withOpacity(0.1),
                  height:kBookedDateHeight.h,
                  width: kBookedDateWidth.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextWidgetAlign(
                        name: '${widget.doc['tt'].toString()}',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,),


                      TextWidgetAlign(
                        name: 'Duration',
                        textColor: kRadioColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.w400,),
                    ],
                  ),

                )
              )
            ],
          ),
          SizedBox(width: 20.h,),
        ],
      )
    )));
  }





  void getBookingDetails() {
    /*showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => OrderVieDetails(docs:widget.doc)
    );*/
  }

}
