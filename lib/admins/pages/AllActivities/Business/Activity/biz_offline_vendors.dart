

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_map.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_counting_activity.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_counting_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_vendors_tabs.dart';


import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/admins/pages/vendor_location.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';


import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:easy_homes/work/constructors/verify_construct.dart';



import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';

class BizOffLineVendors extends StatefulWidget {
  @override
  _BizOffLineVendorsState createState() => _BizOffLineVendorsState();
}

class _BizOffLineVendorsState extends State<BizOffLineVendors> {
  Widget space() {
    return SizedBox(height: 10.h);
  }
  static  List<dynamic> onlineVendors = <dynamic> [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnline();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * kModalHeight,

                child: onlineVendors.length == 0?
                NoOnGoing(title: '$kOffError2 for ${AdminConstants.bizName}',)
                    : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                  StickyHeader(
                  header:  AdminHeader(title: '$kOff3 for ${AdminConstants.bizName}',),


                  content: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: onlineVendors.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                            onTap: (){
                              getDetails(index);
                            },
                            child: Card(
                            shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(kCardRadius),
                        topRight: Radius.circular(kCardRadius),
                        ),),
                        color: kWhiteColor,
                        elevation: kCardElevation,
                        child: Column(
                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                        SizedBox(width:imageRightShift.w),
                        ImageScreen(image: onlineVendors[index]['pix'],),
                        SizedBox(width:imageRightShift.w),


                        Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  TextWidget(
                                                    name: '${onlineVendors[index]['fn']} ${onlineVendors[index]['ln']}',
                                                    textColor: kTextColor,
                                                    textSize: kFontSize,
                                                    textWeight: FontWeight.w500,
                                                  ),

                                                  TextWidget(
                                                    name: onlineVendors[index]['cc'].toString().toUpperCase(),
                                                    textColor: kLightBrown,
                                                    textSize: kFontSize14,
                                                    textWeight: FontWeight.w500,
                                                  ),

                                                  TextWidget(
                                                    name: onlineVendors[index]['biz'].toString().toUpperCase(),
                                                    textColor: kRadioColor,
                                                    textSize: kFontSize14,
                                                    textWeight: FontWeight.w500,
                                                  ),

                                                  space(),

                                                  GestureDetector(
                                                    onTap:() async {
                                                      var url = "tel:${onlineVendors[index]['ph']}";
                                                      if (await canLaunch(url)) {
                                                        await launch(url);
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }
                                                    },
                                                    child: TextWidget(
                                                      name: onlineVendors[index]['ph'].toString().toUpperCase(),
                                                      textColor: kDoneColor,
                                                      textSize: kFontSize14,
                                                      textWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),

                          space(),
                                        ],
                                          )
                                          )
                                      );

                                    }
                            ),
                            )
                                  ],
                                )

                      )
                  )
        )
            );



  }

  void getOnline() {
    setState(() {
      PageConstants.onlineColor = true;
      onlineVendors.clear();
      onlineVendors = PageConstants.vendorCount.where((element) => element['ol'] == false && element['ud'] == Variables.userUid  ).toList();

    });

  }

  void getDetails(int index) {
    PageConstants.getVendor.add(PageConstants.vendorCount[index]);
    Navigator.push(context, PageTransition(type: PageTransitionType.fade,  child: BizMap(index:index)));




  }
}
