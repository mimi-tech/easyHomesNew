import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';
class AnalysisConstruct extends StatelessWidget {

  AnalysisConstruct({
    required this.day,
    required this.mth,
    required this.year,
    required this.daily,
    required this.amount,
  });

  final dynamic  day;
  final dynamic  mth;
  final dynamic  year;
  final dynamic  daily;
  final dynamic  amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextWidget(
          name: day,
          textColor: kRadioColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),

        TextWidget(
          name: daily.toString(),
          textColor: kDoneColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),

        TextWidget(
          name: '#${amount.toString()}',
          textColor: kSeaGreen,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),


      ],
    );
  }
}


class AdminAmount extends StatelessWidget {
  AdminAmount({required this.oAmount,
    required this.pAmount,
    required this.bAmount,
    required this.vAmount,
    required this.total,
   });
  final dynamic oAmount;
  final dynamic pAmount;
  final dynamic vAmount;
  final dynamic total;
  final dynamic bAmount;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        Row(
          children: [

            TextWidget(
              name: 'Total: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kDarkRedColor,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(total).toString()}',
                textColor: kDarkRedColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              name: 'Ve: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),

            MoneyFormatColors(
              color: kDoneColor,
              title: TextWidget(
                name: ' -${VariablesOne.numberFormat.format(vAmount).toString()}',
                textColor: kDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            TextWidget(
              name: 'Bz: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' -${VariablesOne.numberFormat.format(bAmount).toString()}',
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
              name: 'pa: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kYellow,
              title: TextWidget(
                name: '- ${VariablesOne.numberFormat.format(pAmount).toString()}',
                textColor: kYellow,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          children: [

            TextWidget(
              name: 'oA: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kSeaGreen,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(oAmount).toString()}',
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

class BusinessAdminAmount extends StatelessWidget {
  BusinessAdminAmount({required this.bAmount,

    required this.total,
  });
  final dynamic bAmount;

  final dynamic total;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        Row(
          children: [

            TextWidget(
              name: 'Total: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kDarkRedColor,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(total).toString()}',
                textColor: kDarkRedColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            TextWidget(
              name: 'Er: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kSeaGreen,
              title: TextWidget(
                name: ' -${VariablesOne.numberFormat.format(bAmount).toString()}',
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



class PartnerAdminAmount extends StatelessWidget {
  PartnerAdminAmount({required this.oAmount,
    required this.pAmount,
    required this.bAmount,
    required this.vAmount,
    required this.total,
  });
  final dynamic oAmount;
  final dynamic pAmount;
  final dynamic vAmount;
  final dynamic total;
  final dynamic bAmount;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        Row(
          children: [

            TextWidget(
              name: 'Total: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kDarkRedColor,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(total).toString()}',
                textColor: kDarkRedColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              name: 'Ve: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),

            MoneyFormatColors(
              color: kDoneColor,
              title: TextWidget(
                name: ' -${VariablesOne.numberFormat.format(vAmount).toString()}',
                textColor: kDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            TextWidget(
              name: 'Bz: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' -${VariablesOne.numberFormat.format(bAmount).toString()}',
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
              name: 'oA: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kYellow,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(oAmount).toString()}',
                textColor: kYellow,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),


          ],
        ),

        Row(
          children: [

            TextWidget(
              name: 'pa: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kSeaGreen,
              title: TextWidget(
                name: '- ${VariablesOne.numberFormat.format(pAmount).toString()}',
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


class AdminDateBookings extends StatelessWidget {
  AdminDateBookings({required this.date});
  final dynamic date;
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        TextWidget(
          name: date,
          textColor: kRadioColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),
        /*TextWidget(
          name: time,
          textColor: kLightBlue,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),
*/

      ],
    );
  }
}


class AdminDateSecond extends StatelessWidget {
  AdminDateSecond({required this.date, required this.time});
  final dynamic date;
  final dynamic time;
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        TextWidget(
          name: date,
          textColor: kRadioColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),
        TextWidget(
          name: time,
          textColor: kLightBlue,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),

      ],
    );
  }
}


class OrderCount extends StatelessWidget {
  OrderCount({required this.count});
  final dynamic count;
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        TextWidget(
          name: count.toString(),
          textColor: kRadioColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),
        /*TextWidget(
          name: time,
          textColor: kLightBlue,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),
*/

      ],
    );
  }
}
