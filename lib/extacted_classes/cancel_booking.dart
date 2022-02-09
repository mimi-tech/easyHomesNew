import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:flutter/material.dart';

class CancellingBooking extends StatefulWidget {
  CancellingBooking({required this.yes, required this.no});
  final Function yes;
  final Function no;
  @override
  _CancellingBookingState createState() => _CancellingBookingState();
}

class _CancellingBookingState extends State<CancellingBooking> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

        child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Container(
    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
    child: Column(
    children: <Widget>[
      SizedBox(height: 20,),

      TextWidgetAlign(
        name: 'Cancelled Order'.toUpperCase(),
        textColor: kLightBrown,
        textSize: 20,
        textWeight: FontWeight.w500,
      ),
      SizedBox(height: 20,),

      TextWidgetAlign(
        name: 'Do you wish to be matched with another vendor?',
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w500,
      ),

      SizedBox(height: 20,),

      YesNoBtn(no: widget.no, yes: widget.yes),

      SizedBox(height: 20,),

    ])
    )
    ));
  }
}
