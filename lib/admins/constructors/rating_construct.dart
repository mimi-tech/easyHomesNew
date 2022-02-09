import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RatingConstruct extends StatelessWidget {
  RatingConstruct({
    required this.image,
    required this.fn,
    required this.ln,
    required this.ph,

    required this.date,

  });
  final String image;
  final String fn;
  final String ln;
  final String ph;

  final String date;


  @override
  Widget build(BuildContext context) {
    return  Row(

      children: <Widget>[
        SizedBox(width:imageRightShift.w),
        VendorPix(pix:image ,pixColor: Colors.transparent,),

        SizedBox(width:imageRightShift.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              name: '$fn $ln' ,
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),

            TextWidget(
              name: date,
              textColor: kDarkRedColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),

            GestureDetector(
              onTap:() async {
                var url = "tel:$ph";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },

              child: TextWidget(
                name: ph,
                textColor: kDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),



      ],
    );
  }
}
