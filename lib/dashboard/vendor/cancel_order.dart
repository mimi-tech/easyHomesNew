import 'package:badges/badges.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:readmore/readmore.dart';
class CancelledUpcomingBookings extends StatefulWidget {
  @override
  _CancelledUpcomingBookingsState createState() => _CancelledUpcomingBookingsState();
}

class _CancelledUpcomingBookingsState extends State<CancelledUpcomingBookings> {

  bool _publishModal = false;
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05);
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
        appBar:AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: IconThemeData(color: kBlackColor, size: 20.0),
          title: TextWidgetAlign(
            name: kCancelOrder.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),
        ),

        body: ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
              child: Column(
                  children: <Widget>[


                    space(),
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: Variables.cancelOrder.length,
                        itemBuilder: (context, int index) {
                          return Container(
                              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                              child: Row(

                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        SvgPicture.asset('assets/imagesFolder/calendar.svg',),
                                      ],
                                    ),
                                    space(),
                                    SizedBox(width:10.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            TextWidget(
                                              name:Variables.cancelOrder[index]['tm'] ,
                                              textColor: kTextColor,
                                              textSize: kFontSize,
                                              textWeight: FontWeight.w500,),


                                          ],
                                        ),

                                        TextWidget(
                                          name:'From: ${Variables.cancelOrder[index]['biz']}' ,
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
                                              'To: ${Variables.cancelOrder[index]['ad']}' ,
                                              //doc.data['desc'],
                                              trimLines: 1,
                                              colorClickableText: kLightBrown,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: ' ...',
                                              trimExpandedText: '  less',
                                              style: GoogleFonts.oxanium(
                                                fontSize: ScreenUtil().setSp(kFontSize14, ),
                                                color: kRadioColor,

                                              ),
                                            ),
                                          ),
                                        ),
                                        //space(),

                                        Container(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: ScreenUtil()
                                                  .setWidth(250),
                                              minHeight: ScreenUtil()
                                                  .setHeight(20),
                                            ),
                                            child: ReadMoreText(
                                              'Name: ${Variables.cancelOrder[index]['fn']} ${Variables.cancelOrder[index]['ln']}' ,
                                              //doc.data['desc'],
                                              trimLines: 1,
                                              colorClickableText: kLightBrown,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: ' ...',
                                              trimExpandedText: '  less',
                                              style: GoogleFonts.oxanium(
                                                fontSize: ScreenUtil().setSp(kFontSize, ),
                                                color: kTextColor,

                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),


                                  ]
                              )
                          );
                        }
                    )
                  ]
              )
          ),
        )
    )
    );
  }





}
