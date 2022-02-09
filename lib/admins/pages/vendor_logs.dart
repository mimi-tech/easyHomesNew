
import 'package:easy_homes/admins/constructors/logs_construct.dart';

import 'package:easy_homes/admins/pages/page_constants.dart';


import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/admin_header.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jiffy/jiffy.dart';

import 'package:sticky_headers/sticky_headers.dart';

class VendorLogs extends StatefulWidget {
  @override
  _VendorLogsState createState() => _VendorLogsState();
}

class _VendorLogsState extends State<VendorLogs> {
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

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 600),
      curve: Curves.decelerate,
      child: Container(

          height: MediaQuery.of(context).size.height * 0.9,
          child: itemsData.length == 0?

          NoWorkError(title: kVendorNotWork,)
              : SingleChildScrollView(
              child: Column(
                children: <Widget>[

              StickyHeader(
              header:  AdminHeader(title: '${itemsData[0]['fn']} Vendor Analysis',),


              content:  Column(
                children: <Widget>[
              VendorLogsConstruct(
                dailyNo: DateTime.now().day == itemsData[0]['day']?itemsData[0]['dai'].toString():'0' ,
                dailyAmt: DateTime.now().day == itemsData[0]['day']?'#${itemsData[0]['amt'].toString()}':'0.00',
                weekNo: Jiffy().week == itemsData[0]['wky']?itemsData[0]['wkb'].toString():'0',
                weekAmt: Jiffy().week == itemsData[0]['wky']?'#${itemsData[0]['atw'].toString()}':'0.00',
                monthNo: DateTime.now().month == itemsData[0]['mth']?itemsData[0]['mtb'].toString():'0',
                monthAmt: DateTime.now().month == itemsData[0]['mth']?'#${itemsData[0]['atm'].toString()}':'0.00',
                yearNo: DateTime.now().year == itemsData[0]['yr']?itemsData[0]['yb'].toString():'0',
                yearAmt: DateTime.now().year == itemsData[0]['yr']?'#${itemsData[0]['aty'].toString()}':'0.00',

              ),

                ],
              ),
              )
            ]
          )
          ),
        ),
      );

  }

  void getCompanyVendors() {

    itemsData = PageConstants.allVendorCount.where((element) => element['vid'] == PageConstants.vendorID).toList();

  }

 

}
