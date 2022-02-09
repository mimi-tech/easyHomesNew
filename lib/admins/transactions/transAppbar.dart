import 'dart:io';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/search.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/all_business.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/all_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/all_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/removed_vendor.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/rent.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/suspended_vendor.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/verify_biz_owner.dart';
import 'package:easy_homes/admins/pages/appbar_title.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class TransAppBar extends StatefulWidget implements PreferredSizeWidget{
  TransAppBar({required this.title});
  final String title;
  @override
  _TransAppBarState createState() => _TransAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _TransAppBarState extends State<TransAppBar> {

  Icon actionIcon =  Icon(Icons.search,color: kRadioColor,size: 25,);
  bool checkSearch = true;

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
      title:checkSearch ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          TextWidget(
            name: widget.title.toUpperCase(),
            textColor: kLightBrown,
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
      ):Container(

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