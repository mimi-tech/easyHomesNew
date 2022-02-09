
import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class OpenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: kHorizontal,
            vertical: 30),
        alignment: Alignment.topLeft,
        child: Platform.isAndroid?IconButton(
          icon: Icon(Icons.dehaze,size: 30,color: kBlackColor,), onPressed: () {Scaffold.of(context).openDrawer();  },
        )
    :CupertinoButton(
        child: Icon(Icons.dehaze,size: 30,color: kBlackColor,),
        onPressed: () => Scaffold.of(context).openDrawer()
    )
    );
  }
}


class OpenCompanyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

        child: GestureDetector(
            onTap: () { Scaffold.of(context).openDrawer();},
            child: SvgPicture.asset('assets/imagesFolder/drawer.svg',
            color: kBlackColor,
            )));
  }
}
