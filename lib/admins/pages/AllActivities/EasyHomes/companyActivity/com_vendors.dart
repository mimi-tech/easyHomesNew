import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_daily_activity.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class CompaniesVendor extends StatefulWidget {
  @override
  _CompaniesVendorState createState() => _CompaniesVendorState();
}

class _CompaniesVendorState extends State<CompaniesVendor> {
  var itemsData = <dynamic>[];

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourseCompany();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextWidget(name: kBuz.toUpperCase(),
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),


              TextWidget(name: kViewAll,
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),
            ],
          ),
          space(),
          itemsData.length == 0 ?PlatformCircularProgressIndicator(): Container(
              height:40.0,
              child: ListView.builder(
                  physics:  BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount:itemsData.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0, ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          child: OutlineButton(
                            onPressed: (){
                              getCompanyDocId(context, Index);
                            },
                            child:  TextWidget(name: itemsData[Index]['fn'].toString().toUpperCase(),
                              textColor: kTextColor,
                              textSize: kFontSize,
                              textWeight: FontWeight.bold,),
                          ),
                        )


                    );
                  }
              )
          )
        ],
      ),
    );
  }

  void getCourseCompany() {
    itemsData.clear();
    itemsData = PageConstants.vendorCount.where((element) => element['cbi'] == PageConstants.companyUD).toList();

  }

  void getCompanyDocId(BuildContext context, int index) {
/*
    setState(() {
      PageConstants.companyUD = itemsData[index]['ud'];
      PageConstants.companyName = itemsData[index]['biz'];
    });

    Navigator.push(context,
        PageTransition(
            type: PageTransitionType
                .scale,
            alignment: Alignment
                .bottomCenter,
            child: CompanyDailyAnalysis()));*/

  }


}


class Count extends StatelessWidget {
  Count({required this.counting});
  final String counting;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(name: '${kVendor.toUpperCase()}- $counting',
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),

          Row(
            children: <Widget>[
              SvgPicture.asset('assets/imagesFolder/sy.svg',),
              SizedBox(width: 20.w,),
              SvgPicture.asset('assets/imagesFolder/clock.svg',color: kDoneColor,)
            ],
          )
        ],
      ),
    );
  }
}
