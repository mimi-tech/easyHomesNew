import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/block_biz.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/business_cancel.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/business_comments.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/cancel_order.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/comment.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_cancelOrder.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_comments.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/applied_vendors.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/verify_vendor.dart';
import 'package:easy_homes/admins/partners/business_screen.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/admins/partners/partner_screen.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/vendorReg/screens/home.dart';
import 'package:easy_homes/work/constructors/change_prize.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class BizBottomBar extends StatefulWidget {
  BizBottomBar({
    required this.rating,
    required this.cancel,
    required this.addVendor,
    required this.block,
  });

  final Color rating;
  final Color cancel;
  final Color addVendor;
  final Color block;

  @override
  _BizBottomBarState createState() => _BizBottomBarState();
}

class _BizBottomBarState extends State<BizBottomBar> {
  var currentDate = DateTime.now();
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color: kDarkBlue,
          height: 56.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.bottomCenter,
                            child: BusinessScreen()));
                  },
                  child: SvgPicture.asset(
                    'assets/imagesFolder/home.svg',
                    color: widget.block,
                  )),

              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.bottomCenter,
                            child: BizBlockedBusiness()));
                  },
                  child: SvgPicture.asset(
                    'assets/imagesFolder/block.svg',
                    color: widget.rating,
                  )),

              IconButton(icon:SvgPicture.asset('assets/imagesFolder/small_cy.svg',), onPressed: (){
                if(AdminConstants.category != AdminConstants.admin.toLowerCase()){
                Constant1.changeGasPrize = true;
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => ChangeGasPrice()
                );
              }})


            ],
          ),
        ));
  }
}
