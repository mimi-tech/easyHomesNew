
import 'dart:io';
import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/constructors/biz_details.dart';
import 'package:easy_homes/admins/pages/tabs/all.dart';
import 'package:easy_homes/admins/pages/tabs/show_company_admins.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Activity/partner_company_page.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/partners/partner_screen.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class PartnerCompaniesTabs extends StatefulWidget {
  @override
  _PartnerCompaniesTabsState createState() => _PartnerCompaniesTabsState();
}

class _PartnerCompaniesTabsState extends State<PartnerCompaniesTabs> {

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
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
              GestureDetector(
                onTap: () {
                  _showAllCompanies();
                },
                child: BizConstruct(),

              ),

            ],
          ),
          space(),
          PageConstants.getCompanies.length == 0 ?TextWidget(name: kNoVendorCompany,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,): Row(
            children: <Widget>[
              AllCompanyTabs(
                pressFunction: (){
                  setState(() {
                    VariablesOne.allColor = true;
                    VariablesOne.selected = null;
                  });

                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerScreen()));



                },),
              Expanded(
                child: Container(
                    height:bizHeight.h,
                    child: ListView.builder(
                        physics:  BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount:PageConstants.getCompanies.length,
                        itemBuilder: (BuildContext ctxt, int Index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0, ),
                              child: Container(
                                color: VariablesOne.selected == Index?kDoneColor:Colors.transparent ,
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                child: FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(kBizCir),
                                      side: BorderSide(
                                          color: kRadioColor,style: BorderStyle.solid,width: kBizSolid.w
                                      )
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      VariablesOne.allColor = false;
                                      VariablesOne.selected = Index;
                                    });
                                    getCompanyDocId(context, Index);
                                  },
                                  child:  TextWidget(name: PageConstants.getCompanies[Index]['cc'].toString().toUpperCase(),
                                    textColor: VariablesOne.selected == Index?kWhiteColor:kTextColor,
                                    textSize: kFontSize,
                                    textWeight: FontWeight.bold,),
                                ),
                              )


                          );
                        }
                    )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void getCompanyDocId(BuildContext context, int index) {

    setState(() {
      PageConstants.companyUD = PageConstants.getCompanies[index]['id'];
      PageConstants.companyName = PageConstants.getCompanies[index]['biz'];
    });
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerCompanyDailyAnalysis()));



  }

  void _showAllCompanies() {

    showModalBottomSheet(

        isScrollControlled: true,
        context: context,
        builder: (context) => BizScreen()
    );




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
