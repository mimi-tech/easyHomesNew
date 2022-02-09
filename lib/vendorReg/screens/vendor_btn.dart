import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class VendorBtn extends StatelessWidget {
  VendorBtn({required this.title, required this.color, required this.pressed});
  final String title;
  final Color color;
  final Function pressed;
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS?Container(
      width:MediaQuery.of(context).size.width * 0.7,
      height: 50.h,
      child: CupertinoButton(
        color: color,
        onPressed: pressed as void Function(),
        child: Text(title,
          style:GoogleFonts.oxanium(
            fontWeight:FontWeight.bold,
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
          ),
        ),
      ),
    ):Container(
      width:MediaQuery.of(context).size.width * 0.7,
      height: 50.h,
      child: RaisedButton(
        shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(6.0),),
        color: color,
        onPressed: pressed as void Function(),
        child: Text(title,
          style:GoogleFonts.oxanium(
            fontWeight:FontWeight.bold,
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }
}
