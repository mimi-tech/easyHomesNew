

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_counting.dart';
import 'package:easy_homes/admins/pages/appbar_title.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_location.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/image_screen.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';

class EasyComOnlineVendors extends StatefulWidget {
  @override
  _EasyComOnlineVendorsState createState() => _EasyComOnlineVendorsState();
}

class _EasyComOnlineVendorsState extends State<EasyComOnlineVendors> {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    PageConstants.onlineColor = false;
  }
  @override
  Widget build(BuildContext context) {
    return  AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(

            height: MediaQuery.of(context).size.height * kModalHeight,
            child: onlineVendors.length == 0?

            NoWorkError(title: '$kOlError ${PageConstants.companyName}',)
                : SingleChildScrollView(
              child: Column(
                children: <Widget>[

              StickyHeader(
              header:  AdminHeader(title: '$kOl2 for ${PageConstants.companyName}',),

             content: ListView.builder(
                      shrinkWrap: true,
                      itemCount: onlineVendors.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
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
                                          name: onlineVendors[index]['biz'].toString().toUpperCase(),
                                          textColor: kRadioColor,
                                          textSize: kFontSize14,
                                          textWeight: FontWeight.w500,
                                        ),

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
                            ),
                          ),
                        );

                      }
              ),
              )
                    ],
                  )
    ),
        )
    );

  }

  void getOnline() {
    setState(() {
      PageConstants.onlineColor = true;
      onlineVendors.clear();
      onlineVendors = PageConstants.vendorCount.where((element) => element['ol'] == true && element['id'] == PageConstants.companyUD ).toList();

    });

  }

  void getDetails(int index) {


    setState(() {
      PageConstants.getVendorCount.clear();
      PageConstants.getVendor.clear();

      PageConstants.getVendor = PageConstants.vendorCount.where((element) => element['vId'] == onlineVendors[index]['vId']).toList();

      PageConstants.getVendorCount = PageConstants.allVendorCount.where((element) => element['vid'] == onlineVendors[index]['vId']).toList();


    });




    Navigator.push(context,
        PageTransition(
            type: PageTransitionType
                .scale,
            alignment: Alignment
                .bottomCenter,
            child: VendorLocationOnMap()));


  }
}
