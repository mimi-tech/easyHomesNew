import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class MapInfoWindow extends StatelessWidget {
  MapInfoWindow({required this.time, required this.address});

  final String time;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Card(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
//mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
            height: 35,
                  color:kLightBrown,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidgetAlign(
                        name: "time",
                        textColor: kWhiteColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
               SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    //minWidth: MediaQuery.of(context).size.width,
                    //maxWidth: MediaQuery.of(context).size.width,
                    minHeight: 35.0,
                    maxHeight: 35.0,
                  ),

                  child: Center(
                    child: AutoSizeText(
                      address,
                      minFontSize: 4,
                      //stepGranularity: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                     // overflowReplacement: Text('...'),

                      style: GoogleFonts.oxanium(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(kFontSize14, ),
                          color: kBlackColor,
                        )
                      ),

                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
