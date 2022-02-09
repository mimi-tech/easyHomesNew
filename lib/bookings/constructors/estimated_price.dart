import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EstimatedPrice extends StatelessWidget {
  EstimatedPrice({required this.title , required this.price});
  final String title;
  final String price;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidgetAlign(
                name: price.toUpperCase(),
                textColor: kDoneColor,
                textSize: 15,
                textWeight: FontWeight.w400,
              ),

              SvgPicture.asset('assets/imagesFolder/sy.svg',height: 12, width: 12,),


              TextWidgetAlign(
                name: '${Variables.cloud!['gas'].toString()} PER 1KG )',
                textColor: kDoneColor,
                textSize: 15,
                textWeight: FontWeight.w400,
              ),



            ],
          ),
        ),
        Container(
          height: Platform.isIOS?35.sp:60.sp,
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: kRadioColor,width: 2.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/imagesFolder/sy.svg',height: 15, width: 15,),
              SizedBox(width: 2,),
              TextWidgetAlign(
                name: title,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),



            ],
          ),
        )

      ],
    );
  }
}
