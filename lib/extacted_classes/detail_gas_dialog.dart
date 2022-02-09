import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DetailGasDialog extends StatefulWidget {
  @override
  _DetailGasDialogState createState() => _DetailGasDialogState();
}

class _DetailGasDialogState extends State<DetailGasDialog> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: ListView.builder(
          shrinkWrap: true,
      itemCount:  Variables.usedDetailsCylinder.length,
      physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          Column(
            children: <Widget>[
              TextWidget(
                name: 'Head',
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
              spacer(),
              Container(
                // height: pickedCylinderHeight.h,
                width: MediaQuery.of(context).size.width *0.05,
                child: Variables.detailCylinderType[index],),


            ],
          ),



          spacer(),

          Column(
            children: <Widget>[
              TextWidget(
                name: 'Kg',
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
              spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextWidget(name: Variables.usedDetailsCylinder[index].toString(),
                    textColor: kProfile,
                    textSize: kFontSize,
                    textWeight: FontWeight.w600,),

                  Icon(Icons.clear,),


                ],
              ),
            ],
          ),

          spacer(),
          Column(
            children: <Widget>[
              TextWidget(
                name: 'Quantity',
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
              spacer(),
              TextWidget(name: Variables.usedDetailsQuantity[index].toString(),
                textColor: kProfile,
                textSize: kFontSize,
                textWeight: FontWeight.w600,),

            ],
          ),




      ]
      );
    }
      )
    );
  }
}
