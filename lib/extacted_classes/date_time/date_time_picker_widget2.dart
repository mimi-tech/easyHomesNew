import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'notifiaction_dialog.dart';

class DateTimePickerWidget2 extends StatefulWidget {
  DateTimePickerWidget2({this.title,required this.textColor, required this.dateCallback});
  final String? title;
  final Color textColor;
  final Function dateCallback;
  @override
  _DateTimePickerWidget2State createState() => _DateTimePickerWidget2State();
}

class _DateTimePickerWidget2State extends State<DateTimePickerWidget2> {

  @override
  Widget build(BuildContext context) {

    return  Container(
       // margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 3.0,),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
             /* shape:  RoundedRectangleBorder(
                  borderRadius:  BorderRadius.circular(3.0),
                  side: BorderSide(color: kLightBrown)
              ),*/
              color: Colors.transparent,
              child: RichText(
                text: TextSpan(
                  text: widget.title,
                    style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                          color: widget.textColor,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          fontWeight: FontWeight.w600,
                        )
                    ),
                  children: <TextSpan>[
                   /* TextSpan(text:" "+ kPickDate, style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                        )
                    )

                    ),*/

                  ],
                ),
              ),


              onPressed:widget.dateCallback as void Function()
            ),



          ],
        ),
      );




  }
}
