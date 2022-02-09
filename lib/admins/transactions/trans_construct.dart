import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/utils/read_more.dart';
import 'package:url_launcher/url_launcher.dart';
class TransConstruction extends StatelessWidget {
  TransConstruction({

    required this.email,
    required this.channel,
    required this.status,
    required this.gateWay,
    required this.amount,
    required this.date,
    required this.name,
    required this.mobile,

  });

  final dynamic email;
  final dynamic channel;
  final dynamic status;
  final dynamic gateWay;
  final dynamic amount;
  final dynamic date;
  final dynamic name;
  final dynamic mobile;




  @override
  Widget build(BuildContext context) {
    return       Card(
      elevation:5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ReadMoreTextConstructSecond(title: email, colorText: kRadioColor,textWidth: 150,),
                    TextWidget(
                      name: channel,
                      textColor: kLightBrown,
                      textSize: kFontSize14,
                      textWeight: FontWeight.bold,
                    ),
                  ],
                ),

                Column(
                  children: [
                    ReadMoreTextConstructSecond(title: status, colorText: kDoneColor,textWidth: 80,),


                    ReadMoreTextConstructSecond(title: gateWay, colorText: kYellow,textWidth: 80,),


                  ],
                ),
                TextWidget(
                  name: amount == null?'Null':VariablesOne.numberFormat.format(amount).toString(),
                  textColor: kSeaGreen,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,
                ),
              ],
            ),

            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  TextWidget(
                    name: date.toString(),
                    textColor: kDarkRedColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.bold,
                  ),

                  TextWidget(
                    name: name.toString(),
                    textColor: kTextColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),

                  GestureDetector(
                    onTap: () async {
                      var url = "tel:$mobile";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';


                      }
                    },
                    child: TextWidget(
                      name: mobile.toString(),
                      textColor: kDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
}
