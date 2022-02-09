import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewEstimatedPrice extends StatelessWidget {
  NewEstimatedPrice({required this.title,required this.gas});
  final String title;
  final String gas;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  TextWidgetAlign(
                    name: 'Cylinder Price:',
                    textColor: kLightBrown,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/imagesFolder/sy.svg',height: 15, width: 15,),
                      SizedBox(width: 2,),
                      TextWidgetAlign(
                        name: title,
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.normal,
                      ),



                    ],
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidgetAlign(
                    name: 'Gas Price:',
                    textColor: kLightBrown,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/imagesFolder/sy.svg',height: 15, width: 15,),
                      SizedBox(width: 2,),
                      TextWidgetAlign(
                        name: gas,
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.normal,
                      ),



                    ],
                  ),
                ],
              ),


            ],
          ),
        )

      ],
    );
  }
}
