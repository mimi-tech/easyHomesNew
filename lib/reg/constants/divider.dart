import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(

      color: kDividerColor,margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: kHorizontal),height:1.0,);

  }
}


class VerticalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   VerticalDivider(
      thickness: 1.0,

      color: kDividerColor,
    );
  }
}