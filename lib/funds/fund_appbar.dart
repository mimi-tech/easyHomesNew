import 'dart:io';

import 'package:easy_homes/admins/constructors/search.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CardAppBar extends StatefulWidget implements PreferredSizeWidget{


  @override
  _CardAppBarState createState() => _CardAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _CardAppBarState extends State<CardAppBar> {
  bool checkSearch = true;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: kBlackColor, size: 20.0),
      leading: IconButton(icon:Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
      backgroundColor: kWhiteColor,
    title:  LogoDesign(),

    );
  }
}
