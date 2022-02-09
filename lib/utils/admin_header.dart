import 'package:badges/badges.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHeader extends StatelessWidget {
  AdminHeader({required this.title});

  final String title;

  Widget space() {
    return SizedBox(height: 10.h);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      height: 65.h,

      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          space(),
          space(),
          Center(


              child: Text(title.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.oxanium(
                    textStyle: TextStyle(

                      color: kLightBrown,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      fontWeight: FontWeight.bold,

                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          color: kBlackColor,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    )
                ),
              )

          ),
          //space(),
          Divider(thickness: 3.0,color: kDoneColor,),

        ],
      ),
    );
  }
}


class NoWorkError extends StatelessWidget {
  NoWorkError({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidgetAlign(
        name: title,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w500,
      ),
    );
  }
}


class CommentHeader extends StatelessWidget {
  CommentHeader({required this.title,required this.length});

  final String title;
  final int length;

  Widget space() {
    return SizedBox(height: 10.h);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      height: 70.h,

      child: Column(
        children: <Widget>[
          space(),
          space(),
          Center(


              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(title.toUpperCase(),
                    style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                          color: kLightBrown,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          fontWeight: FontWeight.bold,

                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: kBlackColor,
                              offset: Offset(0.5, 0.5),
                            ),
                          ],
                        )
                    ),
                  ),
                  Badge(
                    badgeContent: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextWidgetAlign(
                        name: length.toString(),
                        textColor: kWhiteColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ),

                    child: Icon(Icons.comment,color: kWhiteColor,),
                    toAnimate: true,
                    badgeColor: kLightBlue,
                    shape: BadgeShape.circle,
                    animationDuration: Duration(milliseconds: 300),
                    animationType: BadgeAnimationType.slide,

                  ),



                ],
              )

          ),
          //space(),
          Divider(thickness: 3.0,color: kDoneColor,),

        ],
      ),
    );
  }
}