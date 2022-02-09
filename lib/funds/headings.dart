import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormHeading extends StatelessWidget {

  FormHeading({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return  TextWidgetAlign(
      name: title,
      textColor: kDoneColor,
      textSize: kFontSize,
      textWeight: FontWeight.w400,
    );
  }
}


class WalletHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/imagesFolder/wallet3.svg',
          color: kBlackColor,
        ),
        SizedBox(
          width: 20,
        ),
        TextWidgetAlign(
          name: 'Fund wallet'.toUpperCase(),
          textColor: kTextColor,
          textSize: 20,
          textWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
