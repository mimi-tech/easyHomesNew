import 'dart:io';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/upcoming_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/show_upcomings.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/parter_count_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_activity_tabs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_analysis_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';

import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/reg/constants/variables.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/work/constructors/verify_construct.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
import 'package:sticky_headers/sticky_headers.dart';
class PartnerUpcoming extends StatefulWidget {
  @override
  _PartnerUpcomingState createState() => _PartnerUpcomingState();
}

class _PartnerUpcomingState extends State<PartnerUpcoming> {
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
late DocumentSnapshot document;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];
  bool progress = false;
  @override
  Widget build(BuildContext context) {

    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(

            height: MediaQuery.of(context).size.height * kModalHeight,
            child:itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
            itemsData.length == 0 && progress == true ?
            NoOnGoing(title: kUpComingError,)
                : SingleChildScrollView(
                child: Column(
                    children: <Widget>[

                      StickyHeader(
                        header:  AdminHeader(title: kUpcoming,),


                        content:   ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _documents.length,
                            itemBuilder: (context, int index) {
                              return Container(
                                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ShowEasyBookingDetails(doc: _documents[index],)));


                                    },
                                    child: UpcomingConstruct(

                                      date: itemsData[index]['dd'],
                                      biz: itemsData[index]['biz'],
                                      address: itemsData[index]['ad'],
                                    ),

                                  )
                              );
                            }
                        ),
                      ),

                      progress == true || _loadMoreProgress == true
                          || _documents.length < Variables.limit
                          ?Text(''):
                      moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                          onTap: (){loadMore();},
                          child: SvgPicture.asset('assets/imagesFolder/load_more.svg',))



                    ]
                ))));
  }
  Future<void> getUpcomingOrders() async {
    final QuerySnapshot data = await FirebaseFirestore.instance.collection
("Upcoming")
        .where('vf',isEqualTo: false)
        .where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
        .where('mth',isEqualTo:  DateFormat('MM').format(DateTime.now()))
        .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
        .where('gv',isEqualTo: false ) .orderBy('day', descending: false)
        .get();
    final List<DocumentSnapshot> documents = data.docs;


    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    }else{
      for (DocumentSnapshot result in documents) {
        _lastDocument = documents.last;

        setState(() {
          /* _documents.clear();
          itemsData.clear();*/
          _documents.add(result);
          itemsData.add(result.data());
        });
      }
    }
  }


  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("Upcoming")
        .where('vf',isEqualTo: false)
        .where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
        .where('mth',isEqualTo:  DateFormat('MM').format(DateTime.now()))
        .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
        .where('gv',isEqualTo: false )
        .orderBy('day', descending: false).startAfterDocument(_lastDocument).limit(Variables.limit)

        .get();
    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
       for (document in documents) {
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


