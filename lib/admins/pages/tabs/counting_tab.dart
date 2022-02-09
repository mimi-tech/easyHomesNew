


import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountingTab extends StatefulWidget {
  @override
  _CountingTabState createState() => _CountingTabState();
}

class _CountingTabState extends State<CountingTab> {

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
String day = '';


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        space(),
        Container(
              child: Row(
                children: <Widget>[

                  Container(
                    height:kDateHeight.h,
                    width: kDateWidth.w,
                    decoration:BoxDecoration(
                      //color: kWhiteColor,
                      border: Border.all(color: kRadioColor)

                        ),

                    child: Center(
                      child: TextWidget(name: 'DATE',
                        textColor: kTextColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.bold,),
                    ),
                  ),

                  Container(
                    height:kDateHeight.h,
                    width: kDateWidth.w,
                    decoration:BoxDecoration(
                       // color: kWhiteColor,
                        border: Border.all(color: kRadioColor)

                    ),

                    child: Center(
                      child: TextWidget(name: 'ORDER',
                        textColor: kTextColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.bold,),
                    ),
                  ),

                  Container(
                    height:kDateHeight.h,
                    width: kDateWidth.w,
                    decoration:BoxDecoration(
                        //color: kWhiteColor,
                        border: Border.all(color: kRadioColor)

                    ),

                    child: Center(
                      child: TextWidget(name: 'AMOUNT',
                        textColor: kTextColor,
                        textSize: kFontSize14,
                        textWeight: FontWeight.bold,),
                    ),
                  )

      ],
    )
    )
    ]
    );
  }


}

