import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
class HomeBottomAppBar extends StatefulWidget {

  HomeBottomAppBar({required this.refill});
  final Function refill;
  @override
  _HomeBottomAppBarState createState() => _HomeBottomAppBarState();
}

class _HomeBottomAppBarState extends State<HomeBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        color: kBottomColor,
        shape: CircularNotchedRectangle(),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
             height: 60.h,
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            alignment: Alignment.centerLeft,
            child: RichText(
                text: TextSpan(
                    text: (kFast.toUpperCase()),
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),
                      color: kLightBrown,
                    ),

                    children: <TextSpan>[
                      TextSpan(
                        text: kDelivery.toUpperCase(),
                        style: GoogleFonts.oxanium(
                          fontSize: ScreenUtil().setSp(
                              kFontSize, ),
                          color: kWhiteColor,
                          fontWeight: FontWeight.w200,
                        ),
                      ),


                    ]
                )
            ),
          ),

          GestureDetector(
            onTap: widget.refill as void Function(),
            child: Container(

              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: SvgPicture.asset('assets/imagesFolder/refil.svg')),
          ),

        ],
      )
    );
  }
}
