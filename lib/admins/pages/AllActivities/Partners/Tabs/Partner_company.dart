import 'dart:io';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/constructors/biz_details.dart';
import 'package:easy_homes/admins/pages/tabs/all.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/admins/partners/partner_screen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Activity/partner_company_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/applied_vendors.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class PartnerCompanies extends StatefulWidget {
  @override
  _PartnerCompaniesState createState() => _PartnerCompaniesState();
}

class _PartnerCompaniesState extends State<PartnerCompanies> {
  var itemsData = <dynamic>[];
   var _documents = <DocumentSnapshot>[];
  bool progress = false;

  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
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
              Container(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    _showAllCompanies();
                  },
                  child: BizConstruct(),

                ),
              ),

            ],
          ),
          space(),
          itemsData.length == 0 && progress == false ? Center(
              child: PlatformCircularProgressIndicator()) :
          itemsData.length == 0 && progress == true ? TextWidget(
            name: kNoVendorCompany,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          )
              : Row(
            children: <Widget>[
              AllCompanyTabs(
                pressFunction: () {
                  setState(() {
                    VariablesOne.allColor = true;
                    VariablesOne.selected = null;
                  });


                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PartnerScreen(),
                    ),
                        (route) => false,
                  );
                },),
              Expanded(
                child: Container(
                    height: bizHeight.h,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: PageConstants.getCompanies.length,
                        itemBuilder: (BuildContext ctxt, int Index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0,),
                              child: Container(
                                color: VariablesOne.selected == Index
                                    ? kDoneColor
                                    : Colors.transparent,
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                child: FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(
                                          kBizCir),
                                      side: BorderSide(
                                          color: kRadioColor,
                                          style: BorderStyle.solid,
                                          width: kBizSolid.w
                                      )
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      VariablesOne.allColor = false;
                                      VariablesOne.selected = Index;
                                    });
                                    getCompanyDocId(context, Index);
                                  },
                                  child: TextWidget(name: PageConstants
                                      .getCompanies[Index]['cc']
                                      .toString()
                                      .toUpperCase(),
                                    textColor: VariablesOne.selected == Index
                                        ? kWhiteColor
                                        : kTextColor,
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

  Future<void> getCourseCompany() async {
    if(PageConstants.getCompanies.isEmpty){
    PageConstants.getCompanies.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collection('AllBusiness')
        //.where('ouid', isEqualTo: Variables.userUid)
        .orderBy('date')
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        setState(() {
          /* itemsData.clear();
          _documents.clear();*/
          _documents.add(document);
          itemsData.add(document.data());
          // PageConstants.getCompanies.clear();
          PageConstants.getCompanies.add(document.data());
        });
      }
    }


  }else{
      setState(() {
        itemsData.addAll(PageConstants.getCompanies);
      });
    }

  }

  /*
   setState(() {
          /* itemsData.clear();
          _documents.clear();*/
          _documents.add(result);
          itemsData.add(result.data);
          // PageConstants.getCompanies.clear();
          PageConstants.getCompanies.add(result.data);

        });

  */

  void getCompanyDocId(BuildContext context, int index) {
    setState(() {
      PageConstants.companyUD = itemsData[index]['id'];
      PageConstants.companyName = itemsData[index]['biz'];
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
          TextWidget(
            name: '${kVendor.toUpperCase()}- $counting',
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/imagesFolder/sy.svg',
              ),
              SizedBox(
                width: 20.w,
              ),
              SvgPicture.asset(
                'assets/imagesFolder/clock.svg',
                color: kDoneColor,
              )
            ],
          )
        ],
      ),
    );
  }
}
