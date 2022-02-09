
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/analysis_const.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';

import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_counting_analysis.dart';

import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_vendors_tabs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


class BizMonthlyAnalysisPage extends StatefulWidget {
  @override
  _BizMonthlyAnalysisPageState createState() => _BizMonthlyAnalysisPageState();
}

class _BizMonthlyAnalysisPageState extends State<BizMonthlyAnalysisPage> {

  dynamic sum = 0;
  var amount = <dynamic>[];
  var count = <dynamic>[];
  dynamic counting = 0;
   var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;
  Widget spacer(){
    return SizedBox(height:10.h);
  }
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
        bottomNavigationBar: TotalAmount(name: sum <=  0?0.toString():'$sum'.toString(), day: counting.toString(),),
        appBar: MainAdminAppBar(title:  AdminConstants.bizName!.toUpperCase(),),
        body:CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: kWhiteColor,
                pinned: false,
                automaticallyImplyLeading: false,
                floating: true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverAppHeight),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      space(),

                      BusinessActivityPage(azTextColor: kTextColor,activityTextColor: kWhiteColor,logTextColor: kTextColor,
                        azColor:kDividerColor,activityColor: kBlackColor,logColor:kDividerColor,),

                      space(),
                      BizVendorsTabs(),

                      BizAnalysisTab(
                       counting: PageConstants.vendorNumber.toString(),
                        analysisColor: kLightBrown,
                        currentColor: kDoneColor,
                        cardColorToday: kHintColor,
                        cardColorWeek: kHintColor,
                        cardColorMonth: kLightBrown,
                        cardColorYear: kHintColor,
                      ),
                      CountingTab(),

                    ],
                  ),
                ),

              ),



              SliverList(
                  delegate: SliverChildListDelegate([

                    Column(
                      children: <Widget>[

                        itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                        itemsData.length == 0 && progress == true ? ErrorTitle(errorTitle:kNoVendor):
                        ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _documents.length,
                            itemBuilder: (context, int index) {


                              return Card(
                                elevation: kEle,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical:kHeight16),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: kHeight15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AdminDateSecond( date: '${DateFormat('MMMM').format(DateTime.parse(itemsData[index]['dt']))}',
                                              time:'${DateFormat('yyyy').format(DateTime.parse(itemsData[index]['dt']))}',
                                            ),
                                            OrderCount(count:itemsData[index]['oc']),
                                            BusinessAdminAmount(

                                              bAmount: itemsData[index]['amc'],
                                              total: itemsData[index]['amt'],
                                            )



                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            }
                        ),
                        progress == true || _loadMoreProgress == true
                            || _documents.length < Variables.limit
                            ?Text(''):
                        moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                            onTap: (){loadMore();},
                            child: SvgPicture.asset('assets/imagesFolder/load_more.svg',))



                      ],
                    )
                  ]
                  )
              )
            ]
        )));
  }


  Future<void> getData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup("countBM")
        .orderBy('dt', descending: true).limit(Variables.limit)
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

          amount.add(data['amc']);
          count.add(data['oc']);
          sum += data['amt'];
          counting += data['oc'];

        });


      }
    }
  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance.collectionGroup("countBM")
        .orderBy('dt', descending: true).
    startAfterDocument(_lastDocument).limit(Variables.limit)

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
          amount.add(data['amc']);
          count.add(data['oc']);
          sum += data['amt'];
          counting += data['oc'];

          moreData = false;


        });
      }
    }
  }}
