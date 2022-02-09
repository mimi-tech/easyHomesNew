import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextConstruct extends StatelessWidget {
  TextConstruct({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return  AnimationSlide(title:Text(title,
      textAlign: TextAlign.center,
      style: GoogleFonts.oxanium(
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
        fontSize: ScreenUtil()
            .setSp(kFontSize14, ),
        color: kDoneColor,
      ),
    ));
  }
}


class TextConstructSecond extends StatelessWidget {
  TextConstructSecond({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return   Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child:TextWidgetAlign(
        name: title,
        textColor: kRadioColor,
        textSize: kFontSize14,
        textWeight: FontWeight.bold,
      ),
    );
  }
}
