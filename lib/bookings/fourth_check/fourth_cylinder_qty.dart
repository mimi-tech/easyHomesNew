import 'package:easy_homes/bookings/constructors/cylinder_count.dart';
import 'package:easy_homes/bookings/first_check/cylinder_size.dart';
import 'package:easy_homes/bookings/constructors/gas_type_title.dart';
import 'package:easy_homes/bookings/fourth_check/fourth_cylinder_size.dart';
import 'package:easy_homes/bookings/second_check/second_cylinder_size.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class FourthCylinderQuantity extends StatefulWidget {

  @override
  _FourthCylinderQuantityState createState() => _FourthCylinderQuantityState();
}

class _FourthCylinderQuantityState extends State<FourthCylinderQuantity> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.04);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
          child: Column(
              children:[
                GasTypeTitle(title: Variables.buyingGasType!),
                Divider(),
                spacer(),
                TextWidgetAlign(
                  name: kCylinderQty,
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),
                spacer(),
                CylinderCount(),
                spacer(),

                SizedBtn(nextFunction: (){_nextFunction();}, bgColor: kLightBrown, title: kNextBtn),
                spacer(),
              ]
          ),
        )
    );
  }

  void _nextFunction() {
    Navigator.pop(context);
    Navigator.push(context, PageTransition(
        type: PageTransitionType.scale,
        alignment: Alignment.bottomCenter,
        child: FourthCylinderSize()));  }
}

