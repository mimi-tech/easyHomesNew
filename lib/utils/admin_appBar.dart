import 'dart:io';

import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class AdminAppBar extends StatefulWidget implements PreferredSizeWidget{
  AdminAppBar({required this. title});
  final String title;

  @override
  _AdminAppBarState createState() => _AdminAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _AdminAppBarState extends State<AdminAppBar> {
  @override
  Widget build(BuildContext context) {

    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: kWhiteColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            name: widget.title,
            // AdminConstants.bizName!.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          GestureDetector(
              onTap: () {
                Platform.isIOS
                    ? CupertinoActionSheet(
                  actions: <Widget>[SelectType()],
                )
                    : showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => SelectType());
              },
              child: SvgPicture.asset(
                'assets/imagesFolder/add_circle.svg',
              )),
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: UnBlockUsers()));
            },
            child: SvgPicture.asset(
              'assets/imagesFolder/block.svg',
              color: kRedColor,
            ),
          )

        ],
      ),
    );
  }
}
