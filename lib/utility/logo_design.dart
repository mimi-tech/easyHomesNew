import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset('assets/imagesFolder/logo.svg'),
SizedBox(width: 10,),
    TextWidget(
    name: kSosure.toString().toUpperCase(),
    textColor: kDoneColor,
    textSize: kFontSize,
    textWeight: FontWeight.bold,
    ),
       /* RichText( textAlign: TextAlign.center,
            text: TextSpan(
                text: 'SOSURE GAS'.toUpperCase(),

                style:GoogleFonts.playfairDisplay(
                  fontWeight:FontWeight.w400,
                  fontSize: ScreenUtil().setSp(kFontSize, ),
                  color: kLogoColor,
                ),

                children: <TextSpan>[
                  TextSpan(
                    text: '247',
                    style:GoogleFonts.playfairDisplay(
                      fontWeight:FontWeight.bold,
                      fontSize: ScreenUtil().setSp(kFontSize, ),
                      color: kLogoColor2,
                    ),
                  )
                ]
            )*/

      ],
    );
  }
}
