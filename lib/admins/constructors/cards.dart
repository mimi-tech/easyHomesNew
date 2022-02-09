import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class OnlineCards extends StatelessWidget {
  OnlineCards({
    required this.count,
    required this.image,
    required this.title,
});

  final String count;
  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhiteColor,
      elevation: kOnlineElevation,
      child:  Padding(
        padding: const EdgeInsets.all(kOnlinePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextWidget(
              name: count.toString(),
              textColor: kDoneColor,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(image),
                SizedBox(width: kOnlineSpacing.w),

                TextWidget(
                  name: title,
                  textColor: kLighterBlue,
                  textSize: kFontSize14,
                  textWeight: FontWeight.normal,
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}


class AnalysisCard extends StatelessWidget {
  AnalysisCard({
    required this.titleColor,
    required this.title,

  });


  final String title;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 80.w,
      child: Card(
        color: kWhiteColor,
        elevation: kOnlineElevation,
        child:  Padding(
          padding: const EdgeInsets.all(12),
          child: TextWidget(
            name: title.toUpperCase(),
            textColor: titleColor,
            textSize: kFontSize14,
            textWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}


class ActivityCard extends StatelessWidget {
  ActivityCard({
    required this.titleColor,
    required this.title,

  });


  final String title;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      child: Card(
        color: kWhiteColor,
        elevation: kOnlineElevation,
        child:  Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextWidget(
                name: 'This'.toUpperCase(),
                textColor: titleColor,
                textSize: kFontSize14,
                textWeight: FontWeight.normal,
              ),

              TextWidget(
                name: title.toUpperCase(),
                textColor: titleColor,
                textSize: kFontSize14,
                textWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}