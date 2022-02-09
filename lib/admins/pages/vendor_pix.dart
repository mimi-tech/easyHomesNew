import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
class VendorPix extends StatelessWidget {
  VendorPix({required this.pix,required this.pixColor});
  final Color pixColor;
  final String pix;
  @override
  Widget build(BuildContext context) {
    return
      CachedNetworkImage(
        imageUrl: pix,
        imageBuilder: (context, imageProvider) => Container(
          width: kImageWidth.w,
          height: kImageHeight.h,
          decoration: BoxDecoration(
            border: Border.all(width: 5.0, color: pixColor,),
            shape: BoxShape.circle,
            image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) =>  SvgPicture.asset('assets/imagesFolder/user.svg'),
      );


     /* CircleAvatar(
      backgroundColor: pixColor,
      radius: 32,
      child: ClipOval(

        child: CachedNetworkImage(

          imageUrl: pix,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
          fit: BoxFit.cover,
          width: 55.w,
          height: 60.h,

        ),
      ),
    );*/
  }
}


class OpeningDrawer extends StatelessWidget {
  OpeningDrawer({required this.pix,required this.pixColor});
  final Color pixColor;
  final String pix;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Scaffold.of(context).openDrawer();
      },
      child: CachedNetworkImage(
        imageUrl: pix,
        imageBuilder: (context, imageProvider) => Container(
          width: kImageWidth.w,
          height: kImageHeight.h,
          decoration: BoxDecoration(
            border: Border.all(color: pixColor,width: 5.0),
            shape: BoxShape.circle,
            image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) =>  SvgPicture.asset('assets/imagesFolder/user.svg'),
      ),
    );;
  }
}
