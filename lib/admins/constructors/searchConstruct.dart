import 'package:easy_homes/admins/pages/search_station.dart';
import 'package:easy_homes/admins/pages/search_users.dart';
import 'package:easy_homes/admins/pages/search_vendor.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
class SearchConstruct extends StatelessWidget {
  const SearchConstruct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: UsersSearchStream()));

              },
              child: TextWidgetAlign(
                name: "User",
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),
          ),

          PopupMenuItem(
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: VendorSearchStream()));

              },
              child: TextWidgetAlign(
                name: "Vendor",
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),
          ),

          PopupMenuItem(
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: StationSearchStream()));

              },
              child: TextWidgetAlign(
                name: "Station",
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        child: Icon(Icons.search, size: 30, color: kBlackColor,));
  }
}
