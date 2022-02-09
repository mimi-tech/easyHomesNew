import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BizVerifyConstruct extends StatelessWidget {
  BizVerifyConstruct({required this.text1,required this.text2, required this.text3,});

  final String text1;
  final String text2;
  final String text3;


  @override
  Widget build(BuildContext context) {
    return            Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: (text1),
            style: GoogleFonts.oxanium(
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil()
                  .setSp(kFontSize, ),
              color: kTextColor,
            ),
            children: <TextSpan>[
              TextSpan(
                text: text2,
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize, ),
                  color: kDoneColor,
                ),
              ),


              TextSpan(
                text: (text3),
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize, ),
                  color: kTextColor,
                ),
              ),



            ]),
      ),
    );

  }
}
