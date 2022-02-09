import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ReAdmitVendor extends StatefulWidget {
  ReAdmitVendor({required this.date,required this.title});
  final String date;
  final String title;
  @override
  _ReAdmitVendorState createState() => _ReAdmitVendorState();
}

class _ReAdmitVendorState extends State<ReAdmitVendor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
                text: ('This vendor was removed on '),
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.normal,
                  fontSize: ScreenUtil().setSp(kFontSize),
                  color: kTextColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.date,
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.normal,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize),
                      color: kProfile,
                    ),
                  )
                ]),
          ),
          SizedBox(height: 20,),
          TextWidgetAlign(
            name: widget.title,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
