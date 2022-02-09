import 'package:easy_homes/admins/constructors/search.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBar extends StatefulWidget {
  SearchBar({required this.title});
  final String title;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool checkSearch = true;

  @override
  Widget build(BuildContext context) {
    return checkSearch ? Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PlatformIconButton(
            icon: SvgPicture.asset('assets/imagesFolder/go_back.svg',color: kDoneColor,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Center(
            child: TextWidgetAlign(
              name: widget.title.toUpperCase(),

              textColor: kLightBrown,
              textSize: 20,
              textWeight: FontWeight.bold,
            ),
          ),



          GestureDetector(
              onTap: (){
                setState(() {
                  checkSearch = false;
                  VariablesOne.searchHeight = true;
                });
              },
              child: SearchIcon())


        ],
      ),
    ):Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
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
                  VariablesOne.searchHeight = false;

                });
              },
              child: CancelIcon())
        ],
      ),
    );
  }
}
