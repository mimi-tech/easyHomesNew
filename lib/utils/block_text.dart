import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class BlockText extends StatefulWidget {
  @override
  _BlockTextState createState() => _BlockTextState();
}

class _BlockTextState extends State<BlockText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: TextWidget(name:kBlock,
        textColor: kDarkRedColor,
        textSize: kFontSize,
        textWeight: FontWeight.w500,),
    );
  }
}


class WarningText extends StatefulWidget {
  @override
  _WarningTextState createState() => _WarningTextState();
}

class _WarningTextState extends State<WarningText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      child: TextWidget(name:kRecoverPhone,
        textColor: kRedColor,
        textSize: kFontSize,
        textWeight: FontWeight.w500,),
    );
  }
}
