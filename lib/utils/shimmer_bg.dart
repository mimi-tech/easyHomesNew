import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBg extends StatelessWidget {
  ShimmerBg({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Shimmer.fromColors(
        baseColor: kDoneColor,
        highlightColor: kLightBrown,
        child: Center(
          child: Text(title.toUpperCase(),
            textAlign: TextAlign.center,
    style: GoogleFonts.oxanium(
    fontWeight: FontWeight.bold,
    fontSize: ScreenUtil()
        .setSp(35, ),
          ),
        ),
      ),
      )
    );

  }
}


class ShimmerBgSecond extends StatelessWidget {
  ShimmerBgSecond({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kDoneColor,
      highlightColor: kLightBrown,
      child: Center(
        child: Text(title.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.oxanium(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil()
                .setSp(20, ),
          ),
        ),
      ),
    );

  }
}


class ShimmerThird extends StatelessWidget {
  ShimmerThird({required this.title, required this.color1,required this.color2,});
  final String title;
  final Color color1;
  final Color color2;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color1,
      highlightColor: color2,
      child: Center(
        child: Text(title.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.oxanium(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil()
                .setSp(20, ),
          ),
        ),
      ),
    );

  }
}
