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
import 'package:url_launcher/url_launcher.dart';



class PartnerComment extends StatefulWidget {
  @override
  _PartnerCommentState createState() => _PartnerCommentState();
}

class _PartnerCommentState extends State<PartnerComment> {
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
          cancel: kWhiteColor,
          rating: kYellow,
          addVendor: Colors.transparent,
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
    TextWidget(name: kRate2.toUpperCase(),// AdminConstants.bizName!.toUpperCase(),// AdminConstants.bizName!.toUpperCase(),
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
    PartnerCountTab(counting: PageConstants.vendorNumber.toString(),
      analysisColor: Colors.transparent,
      cardColorMonth: Colors.transparent,
      currentColor: Colors.transparent,
      cardColorWeek: Colors.transparent,
      cardColorToday: Colors.transparent,
      cardColorYear: Colors.transparent,
    )
    ],
    )

    ),
    CountingTab(),
    space(),
              itemsData.length == 0 && progress == false
                  ? Center(child: PlatformCircularProgressIndicator())
                  : itemsData.length == 0 && progress == true
                  ? TextWidget(
                name: kNoComment.toString(),
                textColor: kRadioColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              )
                  : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _documents.length,
                  itemBuilder: (context, int index) {
                    return Column(

                      children: <Widget>[

                        Row(

                          children: <Widget>[
                            VendorPix(pix:itemsData[index]['pix'] ,pixColor: Colors.transparent,),


                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextWidget(
                                  name: '${itemsData[index]['fn']}',
                                  textColor: kTextColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.w500,
                                ),

                                TextWidget(
                                  name: itemsData[index]['dt'],
                                  textColor: kDarkRedColor,
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

                                setState(() {
                                  vendorData.clear();
                                  vendorData = PageConstants.vendorCount.where((element) => element['vId'] == itemsData[index]['vid']).toList();

                                });
                                getVendorDetails(index);},
                              color: kLightBrown,
                              child: TextWidget(
                                name: 'Details',
                                textColor: kWhiteColor,
                                textSize: kFontSize,
                                textWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),

                        space(),



                      ],
                    );
                  }),
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

        .collection("comments")
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

        .collection("comments")
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

  void getVendorDetails(int index) {

    showDialog(
        context: context,
        builder: (context) => Platform.isIOS ?
        CupertinoAlertDialog(
          title:Column(
            children: <Widget>[
              TextWidget(
                name: '${vendorData[0]['fn']} ${vendorData[0]['ln']}',
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),


              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 32,
                    child: ClipOval(

                      child: CachedNetworkImage(

                        imageUrl: vendorData[0]['pix'],
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
                        fit: BoxFit.cover,
                        width: 55.w,
                        height: 60.h,

                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      TextWidget(
                        name: '${vendorData[0]['biz']}',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),



                      Row(
                        children: <Widget>[
                          TextWidget(
                            name: '${vendorData[0]['ph']}',
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.w500,
                          ),
                          SizedBox(width: 10.w,),
                          GestureDetector(
                              onTap:() async {
                                var url = "tel:${vendorData[0]['ph']}";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },

                              child: Icon(Icons.call,color: kDoneColor,))
                        ],
                      ),

                    ],
                  ),


                ],
              ),

              TextWidget(
                name: '${vendorData[0]['str']}',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ],
          ),

          content: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: TextWidget(
                  name: itemsData[index]['tt'],
                  textColor: kDarkRedColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.normal,
                ),
              ),


            ],
          ),



          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Column(
            children: <Widget>[
              TextWidget(
                name: '${vendorData[0]['fn']} ${vendorData[0]['ln']}',
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),


              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 32,
                    child: ClipOval(

                      child: CachedNetworkImage(

                        imageUrl: vendorData[0]['pix'],
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
                        fit: BoxFit.cover,
                        width: 55.w,
                        height: 60.h,

                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      TextWidget(
                        name: '${vendorData[0]['biz']}',
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),



                      Row(
                        children: <Widget>[
                          TextWidget(
                            name: '${vendorData[0]['ph']}',
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.w500,
                          ),
                          SizedBox(width: 10.w,),
                          GestureDetector(
                              onTap:() async {
                                var url = "tel:${vendorData[0]['ph']}";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },

                              child: Icon(Icons.call,color: kDoneColor,))
                        ],
                      ),

                    ],
                  ),


                ],
              ),

              TextWidget(
                name: '${vendorData[0]['str']}',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ],
          ),
          children: <Widget>[

            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: TextWidget(
                name: itemsData[index]['tt'],
                textColor: kDarkRedColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,
              ),
            ),


            spacer(),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: RaisedButton(
                color: kDoneColor,
                onPressed: (){Navigator.pop(context);},
                child: TextWidget(
                  name: kDone,
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),
              ),
            )


          ],
        )

    );


  }
}
