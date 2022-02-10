import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/biz_bottombar.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/verify_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_daily_activity.dart';

import 'package:easy_homes/admins/pages/activity.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_location.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/admin_appBar.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:easy_homes/utils/searchbar.dart';
import 'package:easy_homes/work/constructors/verify_construct.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';

class BizBlockedBusiness extends StatefulWidget {
  @override
  _BizBlockedBusinessState createState() => _BizBlockedBusinessState();
}

class _BizBlockedBusinessState extends State<BizBlockedBusiness> {
  late Iterable<dynamic> se;
  static  List<dynamic> block = <dynamic>[];

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBlock();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAdminAppBar(title: 'Blocked gas station(s)',),
        bottomNavigationBar: BizBottomBar(
          block: kWhiteColor,
          cancel: kWhiteColor,
          addVendor: kWhiteColor,
          rating: kYellow,
        ),
        body: block.length == 0 ?NoOnGoing(title: 'None of your gas stations is blocked'):ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
        itemCount: block.length,
        itemBuilder: (context, int index) {
              return GestureDetector(
              onTap: (){
                getCompanyDocId(index);
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
          ImageScreen(image: block[index]['pix'],),
                    SizedBox(width:imageRightShift.w),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[


                        TextWidget(
                          name: block[index]['biz'].toString().toUpperCase(),
                          textColor: kRadioColor,
                          textSize: kFontSize14,
                          textWeight: FontWeight.w500,
                        ),

                        block[index]['add'] == null?Text(''): Container(

                          child: ConstrainedBox(

                            constraints: BoxConstraints(
                              maxWidth: ScreenUtil().setWidth(250),
                              minHeight: ScreenUtil()
                                  .setHeight(kConstrainedHeight),
                            ),
                            child: ReadMoreText(block[index]['add'],

                                trimLines: 1,
                                colorClickableText:kRedColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: ' ...',
                                trimExpandedText: ' \n show less...',
                                style: GoogleFonts.oxanium(
                                    textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(kFontSize14, ),
                                      color: kTextColor,
                                      fontWeight:FontWeight.bold,
                                    )
                                )
                            ),
                          ),
                        ),


                        space(),
                        GestureDetector(
                          onTap: () async {
                            var url =
                                "tel:${block[index]['ph']}";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: TextWidget(
                            name: block[index]['ph'],
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
  }),
      ),
    );
}

  void getBlock() {
setState(() {
  se =  PageConstants.getCompanies.where((element) => element['apr'] == false);
block.addAll(se);
});
  }

  void getCompanyDocId(int index) {
    
  }
}
