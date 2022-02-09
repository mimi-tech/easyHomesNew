import 'package:flutter/material.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class AmountOrderStations extends StatelessWidget {
  AmountOrderStations({ required this.mop,  required this.gas});
  final dynamic mop;
  final dynamic gas;
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextWidget(
              name: 'PM: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),
            TextWidget(
              name: '${mop.toString()}',
              textColor: kLightBlue,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),
          ],
        ),

        Row(
          children: [
            TextWidget(
              name: 'Gas: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),

            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(gas).toString()}',
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),



      ],
    );
  }
}



class AmountOrderNewStation extends StatelessWidget {
  AmountOrderNewStation({
    required this.mop,
    required this.gas,
    required this.cylinder,
    required this.total,
   });

  final dynamic mop;
  final dynamic gas;
  final dynamic cylinder;

  final dynamic total;
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              name: 'PM: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),

            TextWidget(
              name: '${mop.toString()}',
              textColor: kLightBlue,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            TextWidget(
              name: 'Gas: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(gas).toString()}',
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          children: [

            TextWidget(
              name: 'Cy: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(cylinder).toString()}',
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),



        Row(
          children: [

            TextWidget(
              name: 'Total: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kSeaGreen,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(total).toString()}',
                textColor: kSeaGreen,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),




      ],
    );
  }
}