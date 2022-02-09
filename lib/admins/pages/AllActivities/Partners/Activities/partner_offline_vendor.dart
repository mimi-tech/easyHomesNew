

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/admins/admin_constants.dart';

import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_counting.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_count.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';
import 'package:easy_homes/admins/pages/appbar_title.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_location.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_appBar.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:easy_homes/utils/searchbar.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerOffLineVendors extends StatefulWidget {
  @override
  _PartnerOffLineVendorsState createState() => _PartnerOffLineVendorsState();
}

class _PartnerOffLineVendorsState extends State<PartnerOffLineVendors> {
  Widget space() {
    return SizedBox(height: 10.h);
  }
  static  List<dynamic> onlineVendors = <dynamic> [];
  String? filter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnline();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  Widget bodyList(int index){
    return   GestureDetector(
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
                      name: onlineVendors[index]['biz'].toString().toUpperCase(),
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),
                    space(),
                    GestureDetector(
                      onTap: () async {
                        var url =
                            "tel:${onlineVendors[index]['ph']}";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: TextWidget(
                        name: onlineVendors[index]['ph'],
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),


              ],
            ),


          ],
        ),
      ),
    );


  }


  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(

          height: MediaQuery.of(context).size.height * kModalHeight,
          child: onlineVendors.length == 0?

          NoWorkError(title: '$kOffError ')
              : SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  StickyHeader(
                      header:SearchBar(title: kOff2,),


                      content:ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: onlineVendors.length,
                          itemBuilder: (context, int index) {
                            return filter == null || filter == "" ?bodyList(index):
                            '${onlineVendors[index]['fn']}'.toLowerCase()
                                .contains(filter!.toLowerCase())

                                ?bodyList(index):Container();
                          })
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
      onlineVendors = PageConstants.vendorCount.where((element) => element['ol'] == false ).toList();

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
