import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
class BackLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: Alignment.center,
      children: <Widget>[

        Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child:PlatformIconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },),),

        LogoDesign(),
      ],
    );
  }
}
