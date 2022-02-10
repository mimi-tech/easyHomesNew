import 'dart:io';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_count2.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_vendors.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:jiffy/jiffy.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';

class BizVendorLogs extends StatefulWidget {
  @override
  _BizVendorLogsState createState() => _BizVendorLogsState();
}

class _BizVendorLogsState extends State<BizVendorLogs> {
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

    return  AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 600),
      curve: Curves.decelerate,
      child: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
                children: <Widget>[
                  space(),
                  space(),
                  Center(
                    child: TextWidgetAlign(
                      name: 'Vendor Analysis for ${PageConstants.venName }'.toUpperCase(),
                      textColor: kDoneColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ),
                  space(),
                  space(),

                  itemsData.length == 0?Center(
                    child: TextWidgetAlign(
                      name:'$kVendorNotWork',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ):   DataTable(
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
    );
  }

  void getCompanyVendors() {

    setState(() {
      itemsData = PageConstants.allVendorCount.where((element) => element['vid'] == PageConstants.vv).toList();

    });

    print('second ${PageConstants.vendorID}');
  }



}
