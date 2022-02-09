import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FlutterwavePaymentOption extends StatelessWidget {
  final Function? handleClick;
  final String? buttonText;
  final Color? buttonColor;
  final String? buttonIcon;

  FlutterwavePaymentOption({this.handleClick, this.buttonText, this.buttonColor,this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: this.handleClick as void Function(),
        color: this.buttonColor,
        shape:  RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(6.0),
        ),
        child: Stack(
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(this.buttonIcon!)),

            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: "Fund with ",
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize, ),
                    color: kWhiteColor,
                  ),
                  children: [
                    TextSpan(
                      text: buttonText,
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil()
                            .setSp(kFontSize, ),
                        color: kWhiteColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
