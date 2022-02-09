
import 'dart:io';

import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_offline_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_online_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_schedule.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_upcomings.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/upcomings.dart';

import 'package:easy_homes/admins/pages/company.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class CompanyCountingPage extends StatefulWidget {
  @override
  _CompanyCountingPageState createState() => _CompanyCountingPageState();
}

class _CompanyCountingPageState extends State<CompanyCountingPage> {

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount();

  }

  @override
  Widget build(BuildContext context) {



   /* PageConstants.getLoginCount.clear();
    PageConstants.getLogOutCount.clear();
    PageConstants.getWorkingCount.clear();

    PageConstants.getLoginCount.addAll(count);
    PageConstants.getLogOutCount.addAll(logout);
    PageConstants.getWorkingCount.addAll(transit);*/

    return Column(
      children: <Widget>[

         Column(
          children: <Widget>[
            Container(

              child: Column(
                children: <Widget>[
                  space(),
                  space(),
                  Count(counting: VariablesOne.vendorCount.toString(),),

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
                                EasyComOnlineVendors()
                              ],
                            );
                          })

                              : showModalBottomSheet(

                              isScrollControlled: true,
                              context: context,
                              builder: (context) => EasyComOnlineVendors()
                          );



                        },
                        child: OnlineCards(title:kOnline,
                          image: 'assets/imagesFolder/green_dot.svg',
                          count: VariablesOne.onlineVendorCount.toString(),),


                      ),
                      GestureDetector(
                        onTap: (){

                          Platform.isIOS ?
                          /*show ios bottom modal sheet*/
                          showCupertinoModalPopup(

                              context: context, builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              actions: <Widget>[
                                EasyComOffLineVendors()
                              ],
                            );
                          })

                              : showModalBottomSheet(

                              isScrollControlled: true,
                              context: context,
                              builder: (context) => EasyComOffLineVendors()
                          );


                          },
    child: OnlineCards(title:kOffLine,image: 'assets/imagesFolder/grey_dot.svg',count: '${VariablesOne.vendorCount - VariablesOne.onlineVendorCount}'.toString(),)),


                      GestureDetector(
                        onTap: (){

                          Platform.isIOS ?
                          /*show ios bottom modal sheet*/
                          showCupertinoModalPopup(

                              context: context, builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              actions: <Widget>[
                                CompanyScheduledScreen()
                              ],
                            );
                          })

                              : showModalBottomSheet(

                              isScrollControlled: true,
                              context: context,
                              builder: (context) => CompanyScheduledScreen()
                          );



                        },
            child: OnlineCards(title:kOnGoing,image: '',count:VariablesOne.ongoingOrderCount.toString())),


                      GestureDetector(
                          onTap: (){

                            Platform.isIOS ?
                            //show ios bottom modal sheet
                            showCupertinoModalPopup(

                                context: context, builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                actions: <Widget>[
                                  EasyUpcoming()
                                ],
                              );
                            })

                                : showModalBottomSheet(

                                isScrollControlled: true,
                                context: context,
                                builder: (context) => EasyUpcoming()
                            );

                          },
                          child: OnlineCards(title:'Stations',image: 'assets/imagesFolder/green_dot.svg',count:VariablesOne.onlineStationCount.toString()))

                    ],
                  ),
                ),
                space(),
                //space(),

    VendorIcons(),
                Divider()
              ],
            ),
          ],
        )
      ],
    );
  }

  void getCount() {
    PageConstants.getComUpcoming.clear();
   setState(() {

     PageConstants.companyVendorCount = VariablesOne.vendorCount;

     // PageConstants.getComUpcoming =  PageConstants.getUpcoming.where((element) => element['id'] == PageConstants.companyUD
     //
     // ).toList();



   });



  }
}

