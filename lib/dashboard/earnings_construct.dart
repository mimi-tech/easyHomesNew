import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EarningsConstruct extends StatefulWidget {
  EarningsConstruct({required this.period, required this.title,required this.number,required this.open });

  final String period;
  final String title;
  final String number;
  final Function open;

  @override
  _EarningsConstructState createState() => _EarningsConstructState();
}

class _EarningsConstructState extends State<EarningsConstruct> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.04);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                name:widget.period,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),
              SizedBox(width: 20,),
              TextWidget(
                name:widget.number,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),
              SizedBox(width: 15,),
              MoneyFormatColors(
                color: kSeaGreen,
                title: TextWidgetAlign(
                  name:widget.title,
                  textColor: kSeaGreen,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w600,
                ),
              ),

              IconButton(icon:Icon(Icons.open_in_full , color: kDoneColor,), onPressed: widget.open as void Function())
            ],
          ),
        ),


        spacer(),
        Divider(thickness: 2.0,),
      ],
    );
  }
}


class EarningsPeriod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          TextWidget(
            name:'Periods',
            textColor: kTextColor,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),
          TextWidget(
            name:'Orders',
            textColor: kTextColor,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),

          TextWidget(
            name:'Amount',
            textColor: kTextColor,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),

          TextWidget(
            name:'Details',
            textColor: kTextColor,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}



class OrdersPeriod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          TextWidget(
            name:'Date',
            textColor: kLightBrown,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),
          TextWidget(
            name:'Orders',
            textColor: kTextColor,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),

          TextWidget(
            name:'Amount',
            textColor: kLightBrown,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),


        ],
      ),
    );
  }
}



class BizPeriod extends StatelessWidget {
  BizPeriod({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            TextWidget(
              name:title,
              textColor: kLightBrown,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),
            TextWidget(
              name:'Orders',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),

            TextWidget(
              name:'Amount',
              textColor: kLightBrown,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),


          ],
        ),
      ),
    );
  }
}
