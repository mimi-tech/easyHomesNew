import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';

class OrderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Center(
            child: TextWidget(name: 'DATE of sales'.toUpperCase(),
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,),
          ),

          Center(
            child: TextWidget(name: 'kG Quantity'.toUpperCase(),
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,),
          ),

          Center(
            child: MoneyFormatColors(
              color: kDoneColor,
              title: TextWidget(name: 'Amount'.toUpperCase(),
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.bold,),
            ),
          ),
         ]),
    );
  }
}
