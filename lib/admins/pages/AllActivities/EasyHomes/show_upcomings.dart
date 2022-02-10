import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/dashboard/customer/customer_upcoming.dart';
import 'package:easy_homes/extacted_classes/order_details.dart';
import 'package:easy_homes/extacted_classes/details_list.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:easy_homes/utils/newCylinderList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:easy_homes/colors/colors.dart';

import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
class ShowEasyBookingDetails extends StatefulWidget {
  ShowEasyBookingDetails({
      required this.doc,
  });


   final DocumentSnapshot doc;


  @override
  _ShowEasyBookingDetailsState createState() => _ShowEasyBookingDetailsState();
}

class _ShowEasyBookingDetailsState extends State<ShowEasyBookingDetails> {


  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.025);
  }
  bool _publishModal = false;
 var viewKg = <dynamic>[];
  var viewQuantity = <dynamic>[];
  var viewImage = <dynamic>[];

  var viewKgNew = <dynamic>[];
  var viewQuantityNew = <dynamic>[];
  var viewImageNew = <dynamic>[];


  var viewAmtNew = <dynamic>[];
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(
        appBar: PlatformAppBar(
          backgroundColor: kLightBrown,
          title:    Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //alignment: Alignment.center,
              children: <Widget>[

                TextWidgetAlign(
                  name: 'Scheduled Order'.toUpperCase(),
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,),

                ImageScreen(image: widget.doc['vpi']),
                SizedBox(width:imageRightShift.w),


              ],
            ),

          ),

        ),

        body: ProgressHUDFunction(
      inAsyncCall: _publishModal,
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //space(),



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
                          name: '${DateFormat('MMM' ).format(DateTime.parse(widget.doc['dd']))}'.toUpperCase(),
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
                          name: 'From',
                          textColor: kRadioColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w400,),

                        TextWidget(
                          name: '${widget.doc['biz']}',
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
                          name: 'Vendor Name',
                          textColor: kRadioColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w400,),

                        TextWidget(
                          name: '${widget.doc['vfn']} ${widget.doc['vln']}',
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
                margin: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.topRight,
                child: SvgPicture.asset('assets/imagesFolder/pick_up.svg'),
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

             /* Container(
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
              ),*/


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

             /* space(),

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
                          name: 'Cylinder Prize',
                          textColor: kRadioColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w400,),

                        TextWidget(
                          name: '#${widget.doc['acy']}',
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.w500,),


                      ],
                    ),

                  ],
                ),
              ),*/

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
                    height:kBookedDateHeight.h,
                    width: kBookedDateWidth.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextWidgetAlign(
                          name: '#${widget.doc['amt'].toString()}',
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.w500,),

                        TextWidgetAlign(
                          name: 'Estimate',
                          textColor: kRadioColor,
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
                          name: '${widget.doc['tm'].toString()}',
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
                ],
              ),
              SizedBox(height:20.h,),
            ],
          )
      ),
    )));
  }


  void getBookingDetails() {
      showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          context: context,
          builder: (context) => OrderVieDetails(docs:widget.doc)
      );
    }}

