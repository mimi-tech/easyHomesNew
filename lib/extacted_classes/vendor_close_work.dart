import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorCloseWork extends StatefulWidget {
  @override
  _VendorCloseWorkState createState() => _VendorCloseWorkState();
}

class _VendorCloseWorkState extends State<VendorCloseWork> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextWidget(
          name:   kCloseWorkText,
          textColor: kTextColor,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              color: kRadioColor,
              onPressed: (){},
              child:TextWidget(
                name: 'No',
                textColor: kWhiteColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
            ),


            RaisedButton(
              color: kLightBrown,
              onPressed: (){},
              child:TextWidget(
                name: 'Yes',
                textColor: kWhiteColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
            )
          ],
        )

      ],
    );
  }
}
