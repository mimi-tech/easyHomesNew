import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';

class AllCompanyTabs extends StatelessWidget {
  AllCompanyTabs({required this.pressFunction});
  final Function pressFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0, ),
        child: Container(
          width: bizWidth,
          height:bizHeight,
          child: FlatButton(
            color: VariablesOne.allColor == true?kDoneColor:Colors.transparent,

            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(kBizCir),
              side: BorderSide(
                  color: kRadioColor,style: BorderStyle.solid,width: kBizSolid
              )
            ),
            onPressed: pressFunction as void Function(),
            child:  TextWidget(name: 'All'.toUpperCase(),
              textColor: VariablesOne.allColor == true?kWhiteColor:kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.bold,),
          ),
        )


    );
  }
}
