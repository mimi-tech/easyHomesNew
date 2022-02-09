import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/constructors/cards.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/easy_offline_vendor.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/easy_online_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/sheduled.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/upcomings.dart';
import 'package:easy_homes/admins/pages/company.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountingPage extends StatefulWidget {
  @override
  _CountingPageState createState() => _CountingPageState();
}

class _CountingPageState extends State<CountingPage> {

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
bool progress = false;
    List<dynamic> workingDocuments = <dynamic> [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount();
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
    space(),
        space(),
        Count(counting: VariablesOne.vendorCount.toString(),),

      ],
    ),

    ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Row(
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
                           EasyOnlineVendors()
                         ],
                       );
                     })

                         : showModalBottomSheet(

                         isScrollControlled: true,
                         context: context,
                         builder: (context) => EasyOnlineVendors()
                     );
                   },

                   child: OnlineCards(title:kOnline,image: 'assets/imagesFolder/green_dot.svg',count: VariablesOne.onlineVendorCount.toString(),)),

          GestureDetector(
              onTap: (){
                Platform.isIOS ?
                //show ios bottom modal sheet
                showCupertinoModalPopup(

                    context: context, builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    actions: <Widget>[
                      EasyOffLineVendors()
                    ],
                  );
                })

                    : showModalBottomSheet(

                    isScrollControlled: true,
                    context: context,
                    builder: (context) => EasyOffLineVendors()
                );
              },
              child: OnlineCards(title:kOffLine,image: 'assets/imagesFolder/grey_dot.svg',count: '${VariablesOne.vendorCount - VariablesOne.onlineVendorCount}'.toString(),)),

          GestureDetector(
              onTap: (){
                Platform.isIOS ?
                //show ios bottom modal sheet
                showCupertinoModalPopup(

                context: context, builder: (BuildContext context) {
                return CupertinoActionSheet(
                actions: <Widget>[
                  ScheduledScreen()
                ],
                );
                })

                    : showModalBottomSheet(

                isScrollControlled: true,
                context: context,
                builder: (context) => ScheduledScreen()
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

     FirebaseFirestore.instance.collection('sessionActivity')
         .snapshots().listen((result) {
       final List <DocumentSnapshot> documents = result.docs;
       if(documents.length != 0){

         for (DocumentSnapshot document in documents) {
           Map<String, dynamic> data = document.data() as Map<String, dynamic>;
           setState(() {
             workingDocuments.add(data);
            VariablesOne.vendorCount = data['vec'];
             VariablesOne.onlineVendorCount = data['olv'];
            VariablesOne.ongoingOrderCount = data['ong'];
            VariablesOne.onlineStationCount = data['olst'];
            VariablesOne.stationCount = data['stc'];
             PageConstants.vendorNumber = data['vec'];

           });
         }
       }
    });



/*setState(() {
  vendorWorking.add(result.data['ol']);
  transitCount.add(result.data['tr']);
  PageConstants.vendorCount.add(result.data);
  PageConstants.vendorNumber = vendorWorking.length;
});*/


//upcoming order
}
}

