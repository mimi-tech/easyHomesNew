import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_upcomings.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_offline_vendor.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_online_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_schedule.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_upcoming.dart';
import 'package:easy_homes/admins/pages/company.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PartnerCompanyCountingPage extends StatefulWidget {
  @override
  _PartnerCompanyCountingPageState createState() => _PartnerCompanyCountingPageState();
}

class _PartnerCompanyCountingPageState extends State<PartnerCompanyCountingPage> {

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  List<dynamic> vendorWorking = <dynamic>[];
  List<dynamic> transitCount = <dynamic>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount();
  }

  @override
  Widget build(BuildContext context) {


  /*  Iterable<dynamic> count = vendorWorking.where((element) => (element == true));
    Iterable<dynamic> logout = vendorWorking.where((element) => (element == false));
    Iterable<dynamic> transit = transitCount.where((element) => (element == true));
*/

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

        Column(
          children: <Widget>[
            Container(

              child: Column(
                children: <Widget>[
                  space(),
                  space(),
                  Count(counting: vendorWorking.length.toString(),),

                ],
              ),

            ),

            Column(
              children: <Widget>[

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
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
                        child: OnlineCards(title:kOnline,
                          image: 'assets/imagesFolder/green_dot.svg',
                          count: count.length == 0 ?'0':count.length.toString(),),

                      ),
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
                              builder: (context) => PartnerScheduledScreen()
                          );
                        },
                          child: OnlineCards(title:kOnGoing,image: '',count:transitCount.length.toString())),



                      GestureDetector(
                          onTap: (){

                            Platform.isIOS ?
                            //show ios bottom modal sheet
                            showCupertinoModalPopup(

                                context: context, builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                actions: <Widget>[
                                  CompanyUpcoming()
                                ],
                              );
                            })

                                : showModalBottomSheet(

                                isScrollControlled: true,
                                context: context,
                                builder: (context) => CompanyUpcoming()
                            );

                          },
                          child: OnlineCards(title:kUpComing2,image: '',count:PageConstants.getComUpcoming.length.toString()))

                    ],
                  ),
                ),
                space(),
                VendorIcons(),
                Divider()
              ],
            ),
          ],
        )
      ],
    );
  }

  Future<void> getCount() async {
    if(PageConstants.vendorCount.length == 0) {
      PageConstants.vendorCount.clear();
      PageConstants.getUpcoming.clear();
      FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('appr', isEqualTo: true)
          .where('id', isEqualTo: PageConstants.companyUD)
          .get().then((value) {
        value.docs.forEach((result) {
          setState(() {
            vendorWorking.add(result.data()['ol']);
            transitCount.add(result.data()['tr']);
            PageConstants.vendorCount.add(result.data());
            PageConstants.partnerVendorNumber = vendorWorking.length;
          });
        });
      });
    }else{
      {for(int i= 0; i < PageConstants.vendorCount.length; i++){

        setState(() {
          vendorWorking.add(PageConstants.vendorCount[i]['ol']);
          transitCount.add(PageConstants.vendorCount[i]['tr']);
          PageConstants.partnerVendorNumber = vendorWorking.length;
        });
      }
    }

    if(PageConstants.getUpcoming.length == 0){
    final QuerySnapshot res = await FirebaseFirestore.instance.collection("Upcoming")
        .where('gd', isEqualTo: PageConstants.companyUD )
        .where('vf',isEqualTo: false)
        //.where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
        .where('mth',isGreaterThanOrEqualTo:  DateFormat('MM').format(DateTime.now()))
        .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
        .where('gv',isEqualTo: false )
        .orderBy('day', descending: false)
        .get();

    final List <DocumentSnapshot> doc = res.docs;

    if(doc.length == 0){

    }else{
      for (DocumentSnapshot document in doc) {
        setState(() {
          PageConstants.getUpcoming.add(document.data());

        });

      }
    }

    setState(() {
      PageConstants.getComUpcoming.clear();
      PageConstants.getComUpcoming =  PageConstants.getUpcoming.where((element) => element['gd'] == PageConstants.companyUD

      ).toList();
    });

  }}
}}

