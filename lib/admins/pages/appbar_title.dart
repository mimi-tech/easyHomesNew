import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/admins/partners/partner_screen.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                builder: (BuildContext context) => OwnerScreen(),
              ),
                  (route) => false,
            );

      },
      child: RichText(
        text: TextSpan(
            text: ( AdminConstants.bizName!.toUpperCase()  +'\n'),
            style:GoogleFonts.oxanium(
              fontWeight:FontWeight.bold,
              fontSize: ScreenUtil().setSp(kFontSize, ),
              color: kLightBrown,
            ),

            children: <TextSpan>[
              TextSpan(
                text: PageConstants.companyName,
                style:GoogleFonts.oxanium(
                  fontWeight:FontWeight.normal,
                  fontSize: ScreenUtil().setSp(kFontSize, ),
                  color: kTextColor,
                ),
              )
            ]
        ),
      ),
    );
  }
}




class PartnerAppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            PageTransition(
                type: PageTransitionType
                    .scale,
                alignment: Alignment
                    .bottomCenter,
                child: PartnerScreen()));
      },
      child: RichText(
        text: TextSpan(
            text: ( AdminConstants.bizName!.toUpperCase()  +'\n'),
            style:GoogleFonts.oxanium(
              fontWeight:FontWeight.bold,
              fontSize: ScreenUtil().setSp(kFontSize, ),
              color: kLightBrown,
            ),

            children: <TextSpan>[
              TextSpan(
                text: PageConstants.companyName,
                style:GoogleFonts.oxanium(
                  fontWeight:FontWeight.normal,
                  fontSize: ScreenUtil().setSp(kFontSize, ),
                  color: kTextColor,
                ),
              )
            ]
        ),
      ),
    );
  }
}


