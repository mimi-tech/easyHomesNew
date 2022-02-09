import 'dart:io';


import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/show_upcomings.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_count.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_analysis.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';
import 'package:easy_homes/admins/pages/appbar_title.dart';

import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
class PartnerCompanyUpcoming extends StatefulWidget {
  @override
  _PartnerCompanyUpcomingState createState() => _PartnerCompanyUpcomingState();
}

class _PartnerCompanyUpcomingState extends State<PartnerCompanyUpcoming> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingOrders();
  }
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05);
  }
  late DocumentSnapshot result;
 bool progress = false;
   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];
  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        bottomNavigationBar: PageAddVendor(
          rating: Colors.transparent,
          addVendor: Colors.transparent,
          cancel: Colors.transparent,
          block: Colors.transparent,
        ),
        appBar: AppBar(
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
          PartnerAppBarTitle(),

              GestureDetector(
                  onTap: (){

                    Platform.isIOS?CupertinoActionSheet(

                      actions: <Widget>[
                        SelectType()
                      ],
                    ):showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => SelectType()
                    );

                  },
                  child: SvgPicture.asset('assets/imagesFolder/add_circle.svg',)),
            ],
          ),
        ),
        body:SingleChildScrollView(
            child: Column(
                children: <Widget>[

                  Container(
                      color: kHintColor,
                      child:  Column(
                        children: <Widget>[
                          PartnerCompanyActivityTab(
                            azTextColor: kTextColor,activityTextColor: kWhiteColor,logTextColor: kTextColor,
                            azColor:kDividerColor,activityColor: kBlackColor,logColor:kDividerColor,),
                          space(),
                          PartnerCompaniesTabs(),

                          space(),
                          PartnerCompanyCountTab(counting:  PageConstants.partnerVendorNumber.toString(),
                            analysisColor: Colors.transparent,
                            cardColorMonth: Colors.transparent,
                            currentColor: Colors.transparent,
                            cardColorWeek: Colors.transparent,
                            cardColorToday: Colors.transparent,
                            cardColorYear: Colors.transparent,
                          ),


                        ],
                      )

                  ),
                  //CompanyCountingPage(),

                  space(),



                  itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                  itemsData.length == 0 && progress == true ?Center(
                    child: TextWidgetAlign(
                      name: 'No upcoming order',
                      textColor: kLightBrown,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,),

                  ):  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _documents.length,
                      itemBuilder: (context, int index) {
                        return Container(
                            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ShowEasyBookingDetails(doc: result,)));

                              },
                              child: Row(

                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        SvgPicture.asset('assets/imagesFolder/calendar.svg',),
                                      ],
                                    ),
                                    space(),
                                    SizedBox(width:10.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                             TextWidget(
                                            name:'${DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(itemsData[index]['dd']))}' ,
                                            textColor: kTextColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,),



                                          ],
                                        ),

                                        TextWidget(
                                          name:'From: ${itemsData[index]['biz']}' ,
                                          textColor: kRadioColor,
                                          textSize: kFontSize14,
                                          textWeight: FontWeight.w400,),


                                        Container(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: ScreenUtil()
                                                  .setWidth(250),
                                              minHeight: ScreenUtil()
                                                  .setHeight(20),
                                            ),
                                            child: ReadMoreText(
                                              'To: ${itemsData[index]['ad']}' ,
                                              //doc.data['desc'],
                                              trimLines: 1,
                                              colorClickableText: kLightBrown,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: ' ...',
                                              trimExpandedText: '  less',
                                              style: GoogleFonts.oxanium(
                                                fontSize: ScreenUtil().setSp(kFontSize14, ),
                                                color: kRadioColor,

                                              ),
                                            ),
                                          ),
                                        ),
                                        space(),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(

                                      children: <Widget>[
                                        SvgPicture.asset('assets/imagesFolder/back_right.svg'),
                                      ],
                                    ),


                                  ]
                              ),
                            )
                        );
                      }
                  )



                ]
            ))));
  }
  Future<void> getUpcomingOrders() async {


    final QuerySnapshot data = await FirebaseFirestore.instance.collection
("Upcoming")
        .where('dl',isEqualTo: false)
        .where('cbi',isEqualTo: PageConstants.companyUD)
        .orderBy('day',descending: false)
        .get();
    final List<DocumentSnapshot> documents = data.docs;


    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
      for ( result in documents) {
        setState(() {
          /* _documents.clear();
          itemsData.clear();*/
          _documents.add(result);
          itemsData.add(result.data);
        });
      }
    }


  }

}
