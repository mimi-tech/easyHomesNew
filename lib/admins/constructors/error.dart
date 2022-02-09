import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';

class ErrorTitle extends StatelessWidget {
  ErrorTitle({required this.errorTitle});
  final String errorTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(
        name: errorTitle,
        textColor: kTextColor,
        textSize: kFontSize,
        textWeight: FontWeight.w500,
      ),
    );
  }
}
