import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:  Variables.userPix!,
      imageBuilder: (context, imageProvider) => Container(
        width: kImageWidth.w,
        height: kImageHeight.h,
        decoration: BoxDecoration(

          shape: BoxShape.circle,
          image: DecorationImage(
              image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg',),
    );


  }
}
