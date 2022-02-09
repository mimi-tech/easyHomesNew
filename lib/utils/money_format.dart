import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoneyFormat extends StatelessWidget {
  MoneyFormat({required this.title});
  final Widget title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SvgPicture.asset('assets/imagesFolder/sy.svg',height: 12, width: 12,),
        title



      ],
    );
  }
}

class MoneyFormatColors extends StatelessWidget {
  MoneyFormatColors({required this.title,required this.color});
  final Widget title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SvgPicture.asset('assets/imagesFolder/sy.svg',height: 12, width: 12,color: color,),
        title



      ],
    );
  }
}

class MoneyFormatSecond extends StatelessWidget {
  MoneyFormatSecond({required this.title,required this.color});
  final Widget title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SvgPicture.asset('assets/imagesFolder/sy.svg',height: 12, width: 12,color: color,),
        title



      ],
    );
  }
}

class MoneyFormatThird extends StatelessWidget {
  MoneyFormatThird({required this.title,required this.color});
  final Widget title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        SvgPicture.asset('assets/imagesFolder/sy.svg',height: 12, width: 12,color: color,),
        title



      ],
    );
  }
}