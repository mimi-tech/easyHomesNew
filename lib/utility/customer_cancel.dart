import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerCancel extends StatelessWidget {
  CustomerCancel({
    required this.cancel1,
    required this.cancel2,
    required this.cancel3,
    required this.cancel4,});

  final String cancel1;
  final String cancel2;
  final String cancel3;
  final String cancel4;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: cancel1,
          style:GoogleFonts.oxanium(
            fontWeight:FontWeight.normal,
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kTextColor,
          ),

          children: <TextSpan>[
            TextSpan(
              text: cancel2,
              style:GoogleFonts.oxanium(
                fontWeight:FontWeight.bold,
                fontSize: ScreenUtil().setSp(kFontSize, ),
                color: kTextColor,
              ),
            ),

            TextSpan(
              text: cancel3,
              style:GoogleFonts.oxanium(
                fontWeight:FontWeight.normal,
                fontSize: ScreenUtil().setSp(kFontSize, ),
                color: kTextColor,
              ),
            ),

            TextSpan(
              text: cancel4,
              style:GoogleFonts.oxanium(
                fontWeight:FontWeight.bold,
                fontSize: ScreenUtil().setSp(kFontSize, ),
                color: kDoneColor,
              ),
            )
          ]
      ),
    );

  }
}
