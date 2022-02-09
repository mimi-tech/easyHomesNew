import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/sheduled.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_offline_vendor.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_online_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_schedule.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_upcomings.dart';
import 'package:easy_homes/admins/pages/company.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class PartnerCountingPage extends StatefulWidget {
  @override
  _PartnerCountingPageState createState() => _PartnerCountingPageState();
}

class _PartnerCountingPageState extends State<PartnerCountingPage> {

  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  List<dynamic> vendorWorking = <dynamic>[];
  List<dynamic> transitCount = <dynamic>[];
  bool progress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount();
  }

  @override
  Widget build(BuildContext context) {
    /*Iterable<dynamic> count = vendorWorking.where((element) =>
    (element == true));
    Iterable<dynamic> logout = vendorWorking.where((element) =>
    (element == false));
    Iterable<dynamic> transit = vendorWorking.where((element) =>
    (element == true));*/


    Iterable<dynamic> count =  PageConstants.vendorCount.where((element) => element['ol'] == true);
    Iterable<dynamic> logout =  PageConstants.vendorCount.where((element) => element['ol'] == false);
    Iterable<dynamic> transit =  PageConstants.vendorCount.where((element) => element['tr'] == true);



    PageConstants.getLoginCount.clear();
    PageConstants.getLogOutCount.clear();
    PageConstants.getWorkingCount.clear();

    PageConstants.getLoginCount.addAll(count);
    PageConstants.getLogOutCount.addAll(logout);
    PageConstants.getWorkingCount.addAll(transit);

    return Column(
      children: <Widget>[

        PageConstants.vendorCount.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
        PageConstants.vendorCount.length == 0 && progress == true ? TextWidget(
          name: '',
          textColor: kDoneColor,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ) : Column(
          children: <Widget>[
            Container(

              child: Column(
                children: <Widget>[
                  space(),
                  Count(counting: vendorWorking.length.toString(),),
                  space(),
                ],
              ),

            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  space(),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[


                        GestureDetector(
                            onTap: (){
                              Platform.isIOS ?
                              //show ios bottom modal sheet
                              showCupertinoModalPopup(

                                  context: context, builder: (BuildContext context) {
                                return CupertinoActionSheet(
                                  actions: <Widget>[
                                    PartnerOnlineVendors()
                                  ],
                                );
                              })

                                  : showModalBottomSheet(

                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => PartnerOnlineVendors()
                              );
                            },

                            child: OnlineCards(title:kOnline,image: 'assets/imagesFolder/green_dot.svg',count: count.length == 0 ?'0':count.length.toString(),)),



                        GestureDetector(
                          onTap: (){

                            Platform.isIOS ?
                            /*show ios bottom modal sheet*/
                            showCupertinoModalPopup(

                                context: context, builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                actions: <Widget>[
                                  PartnerOffLineVendors()
                                ],
                              );
                            })

                                : showModalBottomSheet(

                                isScrollControlled: true,
                                context: context,
                                builder: (context) => PartnerOffLineVendors()
                            );
                            },
                          child: OnlineCards(title:kOffLine,image: 'assets/imagesFolder/grey_dot.svg',count: logout.length == 0 ?'0':logout.length.toString(),)),

                       GestureDetector(
                          onTap: (){

                            Platform.isIOS ?
                            /*show ios bottom modal sheet*/
                            showCupertinoModalPopup(

                                context: context, builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                actions: <Widget>[
                                  PartnerScheduledScreen()
                                ],
                              );
                            })

                                : showModalBottomSheet(

                                isScrollControlled: true,
                                context: context,
                                builder: (context) => ScheduledScreen()
                            );
                            },
                           child: OnlineCards(title:kOnGoing,image: '',count:transit.length.toString())),




                        GestureDetector(
                            onTap: (){

                              Platform.isIOS ?
                              //show ios bottom modal sheet
                              showCupertinoModalPopup(

                                  context: context, builder: (BuildContext context) {
                                return CupertinoActionSheet(
                                  actions: <Widget>[
                                    PartnerUpcoming()
                                  ],
                                );
                              })

                                  : showModalBottomSheet(

                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => PartnerUpcoming()
                              );

                            },
                            child: OnlineCards(title:kUpComing2,image: '',count:PageConstants.getUpcoming.length.toString()))

                      ],
                    ),
                  ),
                  space(),
                  space(),

                  VendorIcons(),
                  Divider()
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> getCount() async {
    if(PageConstants.vendorCount.length == 0){
    PageConstants.vendorCount.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collectionGroup('companyVendors')
        .where('appr', isEqualTo: true)
        //.where('cbi', isEqualTo: Variables.userUid)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          vendorWorking.add(data['ol']);
          transitCount.add(data['tr']);
          PageConstants.vendorCount.add(document.data());
          PageConstants.vendorNumber = vendorWorking.length;
        });
      }}
    }else {
      for(int i= 0; i < PageConstants.vendorCount.length; i++){

        setState(() {
          vendorWorking.add(PageConstants.vendorCount[i]['ol']);
          transitCount.add(PageConstants.vendorCount[i]['tr']);
          PageConstants.vendorNumber = vendorWorking.length;
        });
      }
    }

if(PageConstants.getUpcoming.length == 0){
      final QuerySnapshot res = await FirebaseFirestore.instance.collection("Upcoming")
          .where('vf',isEqualTo: false)
          //.where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
          .where('mth',isGreaterThanOrEqualTo:  DateFormat('MM').format(DateTime.now()))
          .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
          .where('gv',isEqualTo: false )
          .get();

      final List <DocumentSnapshot> doc = res.docs;

      if(doc.length == 0){
        setState(() {
          progress = true;
        });

      }else{
        for (DocumentSnapshot document in doc) {
          setState(() {
            PageConstants.getUpcoming.add(document.data());

          });

        }
      }
    }}
  }


