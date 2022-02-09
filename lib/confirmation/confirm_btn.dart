import 'dart:io';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ConfirmBtn extends StatelessWidget {
  ConfirmBtn({required this.nextFunction, required this.bgColor,required this.title});
  final Function nextFunction;
  final Color bgColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 60.h,
      child:Platform.isIOS?

      CupertinoButton(
        onPressed: nextFunction as void Function(),
        color:bgColor,
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        borderRadius:  BorderRadius.circular(6.0),)

          :RaisedButton(
        onPressed: nextFunction as void Function(),
        color:bgColor,
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        shape:  RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(6.0),),
      ),
    );
  }
}




class RateBtn extends StatelessWidget {
  RateBtn({required this.nextFunction, required this.bgColor,
    required this.bgColorBorder,
    required this.title,
    required this.textColor});
  final Function nextFunction;
  final Color bgColor;
  final String title;
  final Color bgColorBorder;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(

      child:Platform.isIOS?

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: bgColorBorder,
        ),

        child: CupertinoButton(
          onPressed: nextFunction as void Function(),
          color:bgColor,

          child: Text(title,

            style:GoogleFonts.oxanium(
              fontSize: ScreenUtil().setSp(kFontSize, ),
              color: textColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          borderRadius:  BorderRadius.circular(6.0),),
      )

          :Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: bgColorBorder,
        ),

            child: OutlineButton(
        onPressed: nextFunction as void Function(),
        color:bgColor,
       // borderSide: BorderSide(color: bgColorBorder, width: 2.0),
        child: Text(title,

            style:GoogleFonts.oxanium(
              fontSize: ScreenUtil().setSp(kFontSize, ),
              color: textColor,
              fontWeight: FontWeight.normal,
            ),
        ),
        shape:  RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(6.0),),
      ),
          ),
    );
  }
}
