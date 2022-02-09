import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/parter_count_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_activity_tabs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_analysis_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';


import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';


import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';



class PartnerCancelOrder extends StatefulWidget {
  @override
  _PartnerCancelOrderState createState() => _PartnerCancelOrderState();
}

class _PartnerCancelOrderState extends State<PartnerCancelOrder> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

   var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];

  var vendorData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.08);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    //PageConstants.allVendorCount.clear();
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: PageAddVendor(
            block: kWhiteColor,
            cancel: kYellow,
            rating: kWhiteColor,
            addVendor: Colors.transparent,
            users: Colors.transparent,

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
                TextWidget(name: kCancelOrder.toUpperCase(),// AdminConstants.bizName!.toUpperCase(),// AdminConstants.bizName!.toUpperCase(),
                  textColor: kLightBrown,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,),


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
          body: SingleChildScrollView(
              child: Column(
                  children: <Widget>[

                    Container(
                        color: kHintColor,
                        child:  Column(
                          children: <Widget>[
                            PartnerActivityPage(
                              azTextColor: kTextColor,activityTextColor: kTextColor,logTextColor: kWhiteColor,
                              azColor:kDividerColor,activityColor:  Colors.transparent,logColor: kBlackColor,),
                            space(),
                            PartnerCompaniesTabs(),

                            space(),
                            PartnerCountTab(

                              counting: PageConstants.vendorNumber.toString(),
                              analysisColor: Colors.transparent,
                              cardColorMonth: Colors.transparent,
                              currentColor: Colors.transparent,
                              cardColorWeek: Colors.transparent,
                              cardColorToday: Colors.transparent,
                              cardColorYear: Colors.transparent,),


                          ],
                        )

                    ),
                    CountingTab(),
                    space(),
                    itemsData.length == 0 && progress == false
                        ? Center(child: PlatformCircularProgressIndicator())
                        : itemsData.length == 0 && progress == true
                        ? TextWidget(
                      name: kNoCancelOrder.toString(),
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    )
                        : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _documents.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            elevation: 20,
                            child: Column(

                              children: <Widget>[

                                Row(

                                  children: <Widget>[
                                    VendorPix(pix:itemsData[index]['px'] ,pixColor: Colors.transparent,),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextWidget(
                                          name: '${itemsData[index]['fn']} ${itemsData[index]['ln']}',
                                          textColor: kTextColor,
                                          textSize: kFontSize,
                                          textWeight: FontWeight.w500,
                                        ),


                                        GestureDetector(
                                          onTap:() async {
                                            var url = "tel:${itemsData[index]['ph']}";
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },

                                          child: TextWidget(
                                            name: itemsData[index]['ph'],
                                            textColor: kDoneColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),


                                    Spacer(),

                                    RaisedButton(
                                      onPressed: (){

                                        // getVendorDetails(index);
                                      },
                                      color: kLightBrown,
                                      child: TextWidget(
                                        name: itemsData[index]['tm'],
                                        textColor: kWhiteColor,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),



                                Divider(),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:<Widget>[
                                          TextWidget(
                                            name: itemsData[index]['dt'],
                                            textColor: kDarkRedColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,
                                          ),

                                          TextWidget(
                                            name: itemsData[index]['bz'],
                                            textColor: kTextColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,
                                          ),


                                          TextWidget(
                                            name: itemsData[index]['cn'],
                                            textColor: kTextColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,
                                          ),

                                          TextWidget(
                                            name: itemsData[index]['ad'],
                                            textColor: kTextColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.w500,
                                          ),
                                        ]
                                    )
                                ),

                                space()



                              ],
                            ),
                          );
                        }),
                    progress == true ||
                    progress == true ||
                        _loadMoreProgress == true ||
                        _documents.length < Variables.limit
                        ? Text('')
                        : moreData == true
                        ? PlatformCircularProgressIndicator()
                        : GestureDetector(
                        onTap: () {
                          loadMore();
                        },
                        child: SvgPicture.asset(
                          'assets/imagesFolder/load_more.svg',
                        ))
                  ])),
        )
    );
  }

  Future<void> getComments() async {
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection("cancelOrder")
        .where('wk',isEqualTo: Jiffy().week)
        .where('yr',isEqualTo: DateTime.now().year)
        .where('cbi', isEqualTo:  Variables.userUid )
        .orderBy('ts', descending: true)
        .limit(Variables.limit)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());
        });
      }
    }
  }

  Future<void> loadMore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection("cancelOrder")
        .where('wk',isEqualTo: Jiffy().week)
        .where('yr',isEqualTo: DateTime.now().year)
        .where('cbi', isEqualTo:  Variables.userUid )
        .orderBy('ts', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(Variables.limit)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        _loadMoreProgress = true;
      });
    } else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          itemsData.add(document.data());

          moreData = false;
        });
      }
    }
  }


}
