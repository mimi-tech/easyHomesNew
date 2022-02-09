import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ActivityTabConstruct extends StatelessWidget {
  ActivityTabConstruct({
    required this.title,
    required this.color1,
    required this.color2,
});
  final String title;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:color1,
          border: Border.all(color: kRadioColor,width: 1.0)
      ),


      width:MediaQuery.of(context).size.width * 0.32,
      height: kAZHeight.h,

      child: Center(
        child: TextWidget(name: title.toUpperCase(),
          textColor: color2,
          textSize: kFontSize,
          textWeight: FontWeight.normal,),
      ),

    );
  }
}


class BizConstruct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TextWidget(
          name: kBuz,
          textColor: kDoneColor,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),
        Icon(Icons.arrow_drop_down,color: kDoneColor,),
        TextWidget(
          name: VariablesOne.stationCount.toString(),
          textColor: kLightBrown,
          textSize: kFontSize14,
          textWeight: FontWeight.normal,
        ),

      ],
    );
  }
}


class VendorIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SvgPicture.asset('assets/imagesFolder/sy.svg',),
        SizedBox(width: 40.w,),
        SvgPicture.asset('assets/imagesFolder/clock.svg',color: kDoneColor,)
      ],
    );
  }
}
