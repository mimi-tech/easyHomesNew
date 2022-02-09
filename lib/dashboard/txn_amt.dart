import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';

class TxnAmount extends StatelessWidget {
  TxnAmount({required this.title,required this.amount,required this.orderCount,});
  final String title;
  final dynamic amount;
  final dynamic orderCount;
  @override
  Widget build(BuildContext context) {
    return Container(

        margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
        child: ListView(
          children: [
            Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      kCardBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                      children: <Widget>[

                        TextWidget(
                          name: title.toUpperCase(),
                          textColor: kRadioColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.w500,
                        ),


                        MoneyFormatSecond(
                          color: kBlackColor,
                          title: TextWidgetAlign(
                            name: amount,
                            textColor: kBlackColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextWidget(
                          name: '${orderCount.toUpperCase()} Order(s)',
                          textColor: kLightBlue,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w500,
                        ),

                      ]),
                )),
          ],
        )
    );
  }
}
