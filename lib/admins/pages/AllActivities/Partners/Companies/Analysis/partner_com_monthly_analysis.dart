import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/analysis_const.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_count_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';
import 'package:easy_homes/admins/pages/appbar_title.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class PartnerComMonthlyAnalysisPage extends StatefulWidget {
  @override
  _PartnerComMonthlyAnalysisPageState createState() =>
      _PartnerComMonthlyAnalysisPageState();
}

class _PartnerComMonthlyAnalysisPageState extends State<PartnerComMonthlyAnalysisPage> {
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
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: TotalAmount(
              day: ' $kWeekly ',
              name: sum <= 0 ? '0' : '#${sum.toString()}',
            ),
            appBar: EasyAppBarSecond(),
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                  backgroundColor: kWhiteColor,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  floating: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(
                        MediaQuery.of(context).size.height * kSliverHeight),
                    child: Column(
                      children: <Widget>[
                        PartnerCompanyActivityTab(
                          azTextColor: kTextColor,
                          activityTextColor: kWhiteColor,
                          logTextColor: kTextColor,
                          azColor: kDividerColor,
                          activityColor: kBlackColor,
                          logColor: kDividerColor,
                        ),
                        space(),
                        PartnerCompaniesTabs(),
                        space(),
                        space(),
                        PartnerComAnalysisTab(
  counting: PageConstants.partnerVendorNumber.toString(),
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
                  )),

              SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: <Widget>[

                        itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                        itemsData.length == 0 && progress == true ? ErrorTitle(errorTitle:kNoVendorMonth):
                        ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _documents.length,
                            itemBuilder: (context, int index) {


                              return Card(
                                elevation: 2,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical:18.0),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            AdminDateSecond( date: '${DateFormat('MMMM').format(DateTime.parse(itemsData[index]['dt']))}',
                                              time:'${DateFormat('yyyy').format(DateTime.parse(itemsData[index]['dt']))}',
                                            ),
                                            OrderCount(count:itemsData[index]['oc']),
                                            PartnerAdminAmount(oAmount: itemsData[index]['amo'],
                                              pAmount: itemsData[index]['amp'],
                                              bAmount: itemsData[index]['amg'],
                                              vAmount: itemsData[index]['va'],
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
                  ]))
            ])));
  }

  Future<void> getData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
.collectionGroup("CountSM")
        .where('id',isEqualTo:  PageConstants.companyUD)
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

          amount.add(data[
'amo']);
          count.add(data[
'oc']);
          sum += data['amt'];
          counting += data['oc'];

        });
        print(document);


      }
    }
  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
.collectionGroup("CountSM")
        .where('id',isEqualTo:  PageConstants.companyUD)
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
          amount.add(data[
'amo']);
          count.add(data[
'oc']);
          sum += data['amt'];
          counting += data['oc'];

          moreData = false;


        });
      }
    }
  }}


