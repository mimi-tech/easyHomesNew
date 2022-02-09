import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ImageList{
  static final icons = [ Container(
    child: Image(
      image: AssetImage('assets/imagesFolder/type1.png'),
     // height: kCylinderSize.h,
      //width: kCylinderSize.w,
    ),
  ),

    Container(
      child: Image(
        image: AssetImage('assets/imagesFolder/type2.png'),
        //height: kCylinderSize.h,
        //width: kCylinderSize.w,
      ),
    ),

    Container(
      child: Image(
        image: AssetImage('assets/imagesFolder/type3.png'),
        //height: kCylinderSize.h,
        //width: kCylinderSize.w,
      ),
    ),
  ];
}


class ImageListUrl{
  static final url = ['assets/imagesFolder/type1.png','assets/imagesFolder/type2.png','assets/imagesFolder/type3.png'];
}
