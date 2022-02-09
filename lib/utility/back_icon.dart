import 'package:easy_homes/colors/colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      //alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
      width: 35.w,
      height: 35.h,
      decoration: BoxDecoration(

          color: kLightBrown,

          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              /*topLeft: Radius.circular(10),*/
             // bottomRight: Radius.circular(kContainerRadius)
          )),


      child: Center(
        child: SvgPicture.asset('assets/imagesFolder/go_back.svg',
          color: kBlackColor,
        ),
      ),
    );
  }
}
