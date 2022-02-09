import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class ReadMoreTextConstruct extends StatelessWidget {
  ReadMoreTextConstruct({required this.title, required this.colorText});
  final String title;
  final Color colorText;
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ScreenUtil()
              .setWidth(200),
          minHeight: ScreenUtil()
              .setHeight(20),
        ),
        child: ReadMoreText(title.toUpperCase(),
          trimLines: 1,
          colorClickableText: kLightBrown,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' ...',
          trimExpandedText: '  less',
          style: GoogleFonts.oxanium(
              fontSize: ScreenUtil().setSp(kFontSize, ),
              color: colorText,
              fontWeight: FontWeight.w500

          ),
        ),
      ),
    );
  }
}


class ReadMoreTextConstructSecond extends StatelessWidget {
  ReadMoreTextConstructSecond({required this.title, required this.colorText,required this.textWidth});
  final String title;
  final Color colorText;
  final dynamic textWidth;
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ScreenUtil()
              .setWidth(textWidth),
          minHeight: ScreenUtil()
              .setHeight(20),
        ),
        child: ReadMoreText(title.toUpperCase(),
          trimLines: 1,
          colorClickableText: kLightBrown,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' ...',
          trimExpandedText: '  less',
          style: GoogleFonts.oxanium(
              fontSize: ScreenUtil().setSp(kFontSize14, ),
              color: colorText,
              fontWeight: FontWeight.w500

          ),
        ),
      ),
    );
  }
}
