import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Fonts{


  static final textSize = TextStyle(
    fontSize: ScreenUtil().setSp(kFontSize, ),
    color: kTextColor,
  );

  static final countSize = TextStyle(
    fontSize: ScreenUtil().setSp(kFontSize, ),
    color: kWhiteColor,
  );

  static final driverLicence = TextStyle(
    fontSize: ScreenUtil().setSp(12, ),
    color: kTextColor,
  );
}