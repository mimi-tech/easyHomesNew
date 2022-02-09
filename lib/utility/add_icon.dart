import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
class AddIcon extends StatelessWidget {
  AddIcon({required this.iconFunction});
  final Function iconFunction;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:iconFunction as void Function(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset('assets/imagesFolder/edit_adds.svg'),
            SizedBox( width: ScreenUtil().setWidth(10),),
            Text(kSAdd,
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: kBlackColor,
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),

                  )
              ),
            ),
          ],


        ),
      ),
    );
  }
}