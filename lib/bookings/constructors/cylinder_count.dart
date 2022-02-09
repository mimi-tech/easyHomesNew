import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CylinderCount extends StatefulWidget {
  @override
  _CylinderCountState createState() => _CylinderCountState();
}

class _CylinderCountState extends State<CylinderCount> {
  //int _count = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: kLightBrown)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PlatformIconButton(
            materialIcon: Icon(Icons.remove),
            cupertinoIcon: Icon(CupertinoIcons.minus),

            onPressed: () {
              setState(() {
                if( Variables.cylinderCount > 1){
                  Variables.cylinderCount--;
                }

              });
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kRadioColor),
              color: kLightBrown
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: Text(
                  '${Variables.cylinderCount}',
                  key: ValueKey<int>(Variables.cylinderCount),
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize14, ),
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
          ),
          PlatformIconButton(
            materialIcon: Icon(Icons.add),
            cupertinoIcon: Icon(CupertinoIcons.add),
            onPressed: () {
              setState(() {
                Variables.cylinderCount += 1;
              });
            },
          ),



        ],
      ),
    );
  }
}
