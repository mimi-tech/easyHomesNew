import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class UpcomingConstruct extends StatelessWidget {

  UpcomingConstruct({

    required this.date,
    required this.biz,
    required this.address,
});

  final String date;
  final String biz;
  final String address;

  Widget space() {
    return SizedBox(height: 10.h);
  }
  @override
  Widget build(BuildContext context) {
    return Row(

        children: <Widget>[
          SvgPicture.asset('assets/imagesFolder/calendar.svg',),

          space(),
          SizedBox(width:10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextWidget(
                    name:'${DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(date))}' ,
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,),



                ],
              ),

              TextWidget(
                name:'From: $biz' ,
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
                    'To: $address' ,
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
              space(),
            ],
          ),
          Spacer(),
          SvgPicture.asset('assets/imagesFolder/back_right.svg'),


        ]
    );
  }
}
