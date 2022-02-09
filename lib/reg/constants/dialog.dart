import 'dart:io';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/reg/screens/referal.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class RegDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(child: SvgPicture.asset('assets/imagesFolder/ok_icon.svg')),
        SizedBox(height: 10.h,),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: kRegSuccessText,
              style: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kBlackColor,
                fontWeight: FontWeight.w500
              ),
              children: <TextSpan>[
                TextSpan(
                  text: kRegSuccessText2,
                  style: GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kLightBrown,
                      fontWeight: FontWeight.w500
                  ),
                ),

                TextSpan(
                  text: kRegSuccessText3,
                  style: GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kBlackColor,
                      fontWeight: FontWeight.w500
                  ),
                ),

              ]
          ),

        ),
SizedBox(height: 10.h,),
        Center(
           child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 60.h,
              child:Platform.isIOS?Text('')
                  :ElevatedButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreenSecond(),
                    ),
                        (route) => false,
                  );

                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kLightBrown)),
                child: Text('Ok',

                  style:GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(22, ),
                    color: kWhiteColor,
                  ),
                ),

              ),
            )
        )

      ],
    );
  }
}
