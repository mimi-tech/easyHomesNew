import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  TextWidget({required this.name,required this.textColor,required this.textSize,required this.textWeight});
  final String name;
  final Color textColor;
  final int textSize;
  final FontWeight textWeight;
  @override
  Widget build(BuildContext context) {
    return Text(name,
      style:GoogleFonts.oxanium(
        fontWeight:textWeight,
        fontSize: textSize.sp,
        color: textColor,
      ),
    );
  }
}


class TextWidgetAlign extends StatelessWidget {
  TextWidgetAlign({required this.name,required this.textColor,required this.textSize,required this.textWeight});
  final String name;
  final Color textColor;
  final int textSize;
  final FontWeight textWeight;
  @override
  Widget build(BuildContext context) {
    return Text(name,

      textAlign: TextAlign.center,
      style:GoogleFonts.oxanium(
        fontWeight:textWeight,
        fontSize: ScreenUtil().setSp(textSize, ),
        color: textColor,
      ),
    );
  }
}
