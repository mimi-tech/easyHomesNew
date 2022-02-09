import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class YesNoBtn extends StatelessWidget {
  YesNoBtn({required this.no, required this.yes});
  final Function no;
  final Function yes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: no as void Function(),
          color: kRadioColor,
          child: TextWidget(
            name: kNo,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
        ),

        RaisedButton(
          onPressed: yes  as void Function(),
          color: kLightBrown,
          child: TextWidget(
            name: kYes,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
        )
      ],

    );
  }
}


class YesNoBtnDynamic extends StatelessWidget {
  YesNoBtnDynamic({required this.no, required this.yes, required this.yesText, required this.noText});
  final Function no;
  final Function yes;
  final String noText;
  final String yesText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: no as void Function(),
          color: kRadioColor,
          child: TextWidget(
            name: noText,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
        ),

        RaisedButton(
          onPressed: yes as void Function(),
          color: kLightBrown,
          child: TextWidget(
            name: yesText,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
        )
      ],

    );
  }
}
