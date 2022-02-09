import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/work/constructors/change_prize.dart';
import 'package:flutter/material.dart';

class ShowGasPrize extends StatelessWidget {
  ShowGasPrize({required this.title,required this.prize,});
  final String title;
  final dynamic prize;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration:BoxDecoration(
        shape: BoxShape.circle,
        color:kSeaGreen,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              name: title,
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),
            MoneyFormatColors(
              color: kWhiteColor,
              title: TextWidget(
                name:  prize.toString(),
                textColor: kWhiteColor,
                textSize: kFontSize14,
                textWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

    );
  }
}


class ShowPrizeTwo extends StatelessWidget {
  ShowPrizeTwo({required this.title,required this.prize,required this.click,});
  final String title;
  final dynamic prize;
  final Function click;
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kSeaGreen)

        ),

        onPressed:click as void Function(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                name: title,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.bold,
              ),
              MoneyFormatColors(
                color: kWhiteColor,
                title: TextWidget(
                  name:  prize.toString(),
                  textColor: kWhiteColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),);
  }
}

