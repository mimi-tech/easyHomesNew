import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CancelConstruct extends StatelessWidget {
  CancelConstruct({
    required this.image,
    required this.fn,
    required this.ln,
    required this.ph,
    required this.time,
    required this.date,

  });
  final String image;
  final String fn;
  final String ln;
  final String ph;
  final String time;
  final String date;

  @override
  Widget build(BuildContext context) {
    return   Row(

      children: <Widget>[
        VendorPix(pix:image ,pixColor: Colors.transparent,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              name: '$fn $ln',
              textColor: kTextColor,
              textSize: kFontSize,
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
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),

            TextWidget(
              name: date,
              textColor: kDarkRedColor,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),
          ],
        ),


        Spacer(),

        RaisedButton(
          onPressed: (){

            // getVendorDetails(index);
          },
          color: kLightBrown,
          child: TextWidget(
            name: time,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}


class RemoveVendorConstruct extends StatelessWidget {
  RemoveVendorConstruct({
    required this.image,
    required this.fn,
    required this.ln,
    required this.date,
    required this.ph,
    required this.verify,

    required this.delete,


  });
  final String image;
  final String fn;
  final String ln;
  final String ph;
  final Function verify;
  final String date;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(

          children: <Widget>[
            SizedBox(width:imageRightShift.w),
          VendorPix(pix:image ,pixColor: Colors.transparent,),
            SizedBox(width:imageRightShift.w),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        TextWidget(
        name: '$fn $ln',
        textColor: kTextColor,
        textSize: kFontSize,
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
        textSize: kFontSize,
        textWeight: FontWeight.w500,
        ),
        ),


        ],
        ),
            Spacer(),

            AdminConstants.category == AdminConstants.owner!.toLowerCase() ||
                AdminConstants.category == AdminConstants.partner!.toLowerCase()?
            Column(
              children: [
                RaisedButton(
                  onPressed:verify as void Function(),
                  color: kLightBrown,
                  child: TextWidget(
                    name: 'Re-add',
                    textColor: kWhiteColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),

               IconButton(icon:
                   Icon(Icons.delete,color: kRedColor,), onPressed: delete as void Function())
              ],
            ):Text('')
          ],
),

        Divider(),
        RichText(
          text: TextSpan(
              text: ('Removed: '),
              style: GoogleFonts.oxanium(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil()
                    .setSp(kFontSize, ),
                color: kDarkRedColor,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:  date,
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize, ),
                    color: kProfile,
                  ),
                )
              ]),
        ),

      ],
    );


  }
}


class PromoConstruct extends StatelessWidget {
  PromoConstruct({
    required this.image,
    required this.fn,
    required this.ln,
    required this.date,

    required this.verify,



  });
  final String image;
  final String fn;
  final String ln;

  final String verify;
  final String date;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(

          children: <Widget>[
            SizedBox(width:imageRightShift.w),
            VendorPix(pix:image ,pixColor: Colors.transparent,),
            SizedBox(width:imageRightShift.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextWidget(
                  name: '$fn',
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),


                TextWidget(
                  name: '$ln',
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),


              ],
            ),
            Spacer(),

            RaisedButton(
              onPressed:(){},
              color: kLightBrown,
              child: TextWidget(
                name: verify,
                textColor: kWhiteColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            )
          ],
        ),

        Divider(),
        RichText(
          text: TextSpan(
              text: ('Received: '),
              style: GoogleFonts.oxanium(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil()
                    .setSp(kFontSize, ),
                color: kDarkRedColor,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:  date,
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize, ),
                    color: kProfile,
                  ),
                )
              ]),
        ),

      ],
    );


  }
}


