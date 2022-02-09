import 'dart:io';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/error.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/parter_count_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_activity_tabs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_analysis_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';


import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PartnerVendorLogs extends StatefulWidget {
  @override
  _PartnerVendorLogsState createState() => _PartnerVendorLogsState();
}

class _PartnerVendorLogsState extends State<PartnerVendorLogs> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  bool _publishModal = false;
  var itemsData = <dynamic>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanyVendors();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: PageAddVendor(
          rating: Colors.transparent,
          addVendor: Colors.transparent,
          cancel: Colors.transparent,
          block: Colors.transparent,

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
              TextWidget(name:  AdminConstants.bizName!.toUpperCase(),// AdminConstants.bizName!.toUpperCase(),// AdminConstants.bizName!.toUpperCase(),
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
        body: ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
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
                            ),


                          ],
                        )

                    ),
                    CountingTab(),
                    space(),

                    itemsData.length == 0?ErrorTitle(errorTitle: kVendorNotWork,):   DataTable(
                      columnSpacing: MediaQuery.of(context).size.width*0.04,
                      sortColumnIndex: 1,
                      sortAscending: true,
                      dataRowHeight: MediaQuery.of(context).size.width*0.2,
                      dividerThickness: 5,
                      columns: [
                        DataColumn(

                          label: Container(
                            color: kLightBrown.withOpacity(0.2),

                            child: Row(
                              children: <Widget>[
                                TextWidget(
                                  name:'Periods',
                                  textColor: kLightBrown,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.bold,
                                ),

                                Icon(Icons.arrow_drop_down,color: kLightBrown,)
                              ],
                            ),
                          ),),
                        DataColumn(label:  Row(
                          children: <Widget>[
                            SvgPicture.asset('assets/imagesFolder/small_cy.svg',),

                            TextWidget(
                              name:'Orders',
                              textColor: kTextColor,
                              textSize: kFontSize14,
                              textWeight: FontWeight.bold,
                            ),


                          ],
                        ),),

                        DataColumn(label:TextWidget(
                          name:'AMOUNT'.toUpperCase(),
                          textColor: kLightBrown,
                          textSize: kFontSize14,
                          textWeight: FontWeight.bold,
                        ),)

                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(TextWidget(
                            name:'Today',
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),

                          ),
                          DataCell(TextWidget(
                            name:DateTime.now().day == itemsData[0]['day']?itemsData[0]['dai'].toString():'0',
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),

                          ),

                          DataCell(TextWidget(
                            name:DateTime.now().day == itemsData[0]['day']?'#${itemsData[0]['amt'].toString()}':'0.00',
                            textColor: kSeaGreen,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),

                          ),
                        ]
                        ),
                        DataRow(cells: [

                          DataCell(TextWidget(
                            name:kWeekly,
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),
                          ),
                          DataCell(TextWidget(
                            name: Jiffy().week == itemsData[0]['wky']?itemsData[0]['wkb'].toString():'0',
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),
                          ),

                          DataCell(TextWidget(
                            name:Jiffy().week == itemsData[0]['wky']?'#${itemsData[0]['atw'].toString()}':'0.00',
                            textColor: kSeaGreen,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),

                          )]),

                        DataRow(cells: [

                          DataCell(TextWidget(
                            name:kMonthly,
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),
                          ),
                          DataCell(TextWidget(
                            name: DateTime.now().month == itemsData[0]['mth']?itemsData[0]['mtb'].toString():'0',
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),
                          ),

                          DataCell(TextWidget(
                            name:DateTime.now().month == itemsData[0]['mth']?'#${itemsData[0]['atm'].toString()}':'0.00',
                            textColor: kSeaGreen,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),

                          )]),
                        DataRow(cells: [

                          DataCell(TextWidget(
                            name:kYearly,
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),
                          ),
                          DataCell(TextWidget(
                            name: DateTime.now().year == itemsData[0]['yr']?itemsData[0]['yb'].toString():'0',
                            textColor: kTextColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),
                          ),

                          DataCell(TextWidget(
                            name:DateTime.now().year == itemsData[0]['yr']?'#${itemsData[0]['aty'].toString()}':'0.00',
                            textColor: kSeaGreen,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w400,
                          ),

                          )]),



                      ],

                    ),
                  ]
              )
          ),
        ),
      ),
    );
  }

  void getCompanyVendors() {

   setState(() {
     itemsData = PageConstants.allVendorCount.where((element) => element['vid'] == PageConstants.vendorID).toList();

   });
  }



}
