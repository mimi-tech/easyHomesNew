import 'dart:async';


import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_count.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_tab.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';

import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/reg/constants/variables.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
class PartnerComActivitiesPage extends StatefulWidget {
  @override
  _PartnerComActivitiesPageState createState() => _PartnerComActivitiesPageState();
}

class _PartnerComActivitiesPageState extends State<PartnerComActivitiesPage> {
  dynamic sum = 0;
  var amount = <dynamic>[];

   var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;

  @override
  void initState() {

    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    amount.clear();
    return SafeArea(child: Scaffold(
        backgroundColor: kWhiteColor,
        bottomNavigationBar: TotalAmount(day:'$kToday ',name: sum <=  0?'0':'#${sum.toString()}',),
        appBar: EasyAppBarSecond(),
        body:CustomScrollView(

            slivers: <Widget>[
              SliverAppBar(
                  backgroundColor: kWhiteColor,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  floating: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverHeight),
                    child:Column(
                      children: <Widget>[
                        PartnerCompanyActivityTab(
                          azTextColor: kTextColor,activityTextColor: kWhiteColor,logTextColor: kTextColor,
                          azColor:kDividerColor,activityColor: kBlackColor,logColor:kDividerColor,),
                        space(),
                        PartnerCompaniesTabs(),

                        space(),
                        PartnerCompanyCountTab(
                          counting: PageConstants.partnerVendorNumber.toString(),
                          analysisColor: kDoneColor,
                          currentColor: kLightBrown,
                          cardColorToday: kLightBrown,
                          cardColorWeek: kHintColor,
                          cardColorMonth: kHintColor,
                          cardColorYear: kHintColor,

                        ),


                      ],
                    ),
                  )
              ),
              SliverAppBar(
                backgroundColor: kWhiteColor,
                pinned: true,
                automaticallyImplyLeading: false,
                //floating: true,

                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverHeight2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      CountingTab(),
                      space(),
                      space(),
                    ],
                  ),
                ),

              ),

              SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: <Widget>[

                        itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                        itemsData.length == 0 && progress == true ? ErrorTitle(errorTitle:'$kNoVendor for  ${PageConstants.companyName }'):
                        ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _documents.length,
                            itemBuilder: (context, int index) {


                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: kHorizontal),

                                child: Column(

                                  children: <Widget>[

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: <Widget>[
                                          DateBookings(date:itemsData[index]['dt'], time: '',),

                                          Column(
                                            children: <Widget>[
                                              itemsData[index]['us'] == 0 || itemsData[index]['us'] == null ?Text(''):   BookingDetails(

                                                kg: '${itemsData[index]['kg']}',
                                                qty: itemsData[index]['cQ'],
                                                type: itemsData[index]['bg'],
                                                number: itemsData[index]['no'], rent: '',

                                              ),

                                              itemsData[index]['acy'] == 0 ||itemsData[index]['acy'] == null ?Text(''): NewBookingDetails(
                                                amt:itemsData[index]['nam'],
                                                kg: itemsData[index]['nKG'],
                                                qty: itemsData[index]['ncQ'],
                                                type: itemsData[index]['bg'],
                                                number: itemsData[index]['nno'], 
                                                quantity: '',
                                                kgs: '',
                                                rent: '',

                                              ),
                                            ],
                                          ),




                                          AmountBooking( amount: itemsData[index]['amt'],)
                                        ]
                                    ),


                                    Divider(),

                                  ],
                                ),
                              );
                            }
                        ),
                        progress == true || _loadMoreProgress == true
                            || _documents.length < Variables.dailyLimit
                            ?Text(''):
                        moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                            onTap: (){loadMore();},
                            child: SvgPicture.asset('assets/imagesFolder/load_more.svg',))



                      ],
                    )

                  ]))])

    ));
  }


  Future<void> getData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily")
        .where('cbi', isEqualTo: PageConstants.companyUD)
        .where('day', isEqualTo: DateTime.now().day)
        .where('mth', isEqualTo: DateTime.now().month)
        .where('yr', isEqualTo: DateTime
        .now().year).orderBy('tm', descending: true).limit(Variables.dailyLimit)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
      setState(() {
        progress = true;
      });

    }else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());

          amount.add(data[
'amt']);
          sum += data['amt'];


        });



      }
    }
  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily")
        .where('cbi', isEqualTo: PageConstants.companyUD)
        .where('day', isEqualTo: DateTime
        .now().day).where('mth', isEqualTo: DateTime
        .now().month).where('yr', isEqualTo: DateTime
        .now().year).orderBy('tm', descending: true).
    startAfterDocument(_lastDocument).limit(Variables.dailyLimit)

        .get();
    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
          itemsData.add(document.data());
          amount.add(data[
'amt']);

          sum += data['amt'];

          moreData = false;


        });
      }
    }
  }
}
