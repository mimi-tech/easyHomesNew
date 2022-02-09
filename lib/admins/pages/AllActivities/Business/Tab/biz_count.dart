
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_offline_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_online_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_schedule.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_upcoming.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_upcomings.dart';
import 'package:easy_homes/admins/pages/company.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class BusinessCountingPage extends StatefulWidget {
  BusinessCountingPage({
    required this.counting,
    required this.login,
    required this.logOut,
    required this.transit,
  });
  final int counting;
  final int login;
  final int logOut;
  final int transit;
  @override
  _BusinessCountingPageState createState() => _BusinessCountingPageState();
}

class _BusinessCountingPageState extends State<BusinessCountingPage> {




  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcoming();
  }
  @override
  Widget build(BuildContext context) {



    return Column(
      children: <Widget>[

        Column(
          children: <Widget>[
            Container(

              child: Column(
                children: <Widget>[

                  BizCount(counting: widget.counting.toString()),

                ],
              ),

            ),

            Column(
              children: <Widget>[

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: kWhiteColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){

                          Platform.isIOS ?
                          /*show ios bottom modal sheet*/
                          showCupertinoModalPopup(

                              context: context, builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              actions: <Widget>[
                                BizOnlineVendors()
                              ],
                            );
                          })

                              : showModalBottomSheet(

                              isScrollControlled: true,
                              context: context,
                              builder: (context) => BizOnlineVendors()
                          );



                        },
                        child: OnlineCards(title:kOnline,image: 'assets/imagesFolder/green_dot.svg',count: widget.login.toString(),)),


                      GestureDetector(
                        onTap: (){

                          Platform.isIOS ?
                          /*show ios bottom modal sheet*/
                          showCupertinoModalPopup(

                              context: context, builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              actions: <Widget>[
                                BizOffLineVendors()
                              ],
                            );
                          })

                              : showModalBottomSheet(

                              isScrollControlled: true,
                              context: context,
                              builder: (context) => BizOffLineVendors()
                          );


                        },
                        child: OnlineCards(title:kOffLine,image: 'assets/imagesFolder/grey_dot.svg',count: widget.logOut.toString(),)),

                      GestureDetector(
                        onTap: (){
                          Platform.isIOS ?
                          /*show ios bottom modal sheet*/
                          showCupertinoModalPopup(

                              context: context, builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              actions: <Widget>[
                                BizScheduledScreen()
                              ],
                            );
                          })

                              : showModalBottomSheet(

                              isScrollControlled: true,
                              context: context,
                              builder: (context) => BizScheduledScreen()
                          );


                        },
                        child: OnlineCards(title:kOnGoing,image: '',count:widget.transit.toString())),



                      GestureDetector(
                          onTap: (){

                            Platform.isIOS ?
                            //show ios bottom modal sheet
                            showCupertinoModalPopup(

                                context: context, builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                actions: <Widget>[
                                  BizUpcoming()
                                ],
                              );
                            })

                                : showModalBottomSheet(

                                isScrollControlled: true,
                                context: context,
                                builder: (context) => BizUpcoming()
                            );

                          },
                          child: OnlineCards(title:kUpComing2,image: '',count:PageConstants.getUpcoming.length.toString()))


                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Future<void> getUpcoming() async {
    if(PageConstants.getUpcoming.isEmpty){
    PageConstants.getUpcoming.clear();
    final QuerySnapshot res = await FirebaseFirestore.instance.collection("Upcoming")
        .where('cbi', isEqualTo: Variables.userUid)
        .where('vf',isEqualTo: false)
        //.where('day',isGreaterThanOrEqualTo: DateTime.now().day)
        .where('mth',isGreaterThanOrEqualTo: DateTime.now().month)
        .where('yr',isEqualTo: DateTime.now().year)
        .where('gv',isEqualTo: false )
        .get();

    final List <DocumentSnapshot> doc = res.docs;

    if (doc.length == 0) {} else {
      for (DocumentSnapshot document in doc) {
        setState(() {
          PageConstants.getUpcoming.add(document.data());
        });
      }
    }
  }}
}

