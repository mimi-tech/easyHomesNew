import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(
        backgroundColor: kWhiteColor,
        body: WillPopScope(
          onWillPop: () => Future.value(false),
          child: Column(
      children: <Widget>[
          Expanded(
            child: Image.asset(
              'assets/imagesFolder/loading2.gif',

            ),
          ),
      ],
    ),
        )));
  }
}
