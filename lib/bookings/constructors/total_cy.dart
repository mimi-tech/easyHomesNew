import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalCylinderConstruct extends StatelessWidget {
  TotalCylinderConstruct({required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Total cylinder size you have entered is ',
            style: GoogleFonts.oxanium(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil()
                  .setSp(kFontSize, ),
              color: kTextColor,
            ),
            children: <TextSpan>[
              TextSpan(
                text: title,
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize, ),
                  color: kDarkRedColor,
                ),
              ),

              TextSpan(
                text: 'Kg',
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize, ),
                  color: kTextColor,
                ),
              )
            ]),
      )
    );
  }
}
