import 'dart:io';

import 'package:easy_homes/admins/constructors/search.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashAppBar extends StatefulWidget implements PreferredSizeWidget{
  DashAppBar({required this. title});
  final String title;

  @override
  _DashAppBarState createState() => _DashAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _DashAppBarState extends State<DashAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: kBlackColor, size: 20.0),
      backgroundColor: kLightBrown,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            name: widget.title,
            // AdminConstants.bizName!.toUpperCase(),
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),


        ],
      ),
    );
  }
}


class PromoAppBar extends StatefulWidget implements PreferredSizeWidget{
  PromoAppBar({required this. title});
  final String title;

  @override
  _PromoAppBarState createState() => _PromoAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _PromoAppBarState extends State<PromoAppBar> {
  bool checkSearch = true;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: kBlackColor, size: 20.0),
      backgroundColor: kLightBrown,
      title: checkSearch? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            name: widget.title,
            // AdminConstants.bizName!.toUpperCase(),
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          GestureDetector(
              onTap: (){
                setState(() {
                  checkSearch = false;
                });
              },
              child: SearchIcon())



        ],
      ):    Container(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: TextFormField(
                  controller: PageConstants.searchController,
                  style: Fonts.textSize,
                  autocorrect: true,
                  autofocus: true,
                  cursorColor: kBlackColor,
                  keyboardType: TextInputType.text,
                  decoration: Variables.searchInput),
            ),

            GestureDetector(
                onTap: (){
                  setState(() {
                    checkSearch = true;
                  });
                },
                child: CancelIcon())
          ],
        ),
      ),
    );
  }
}
