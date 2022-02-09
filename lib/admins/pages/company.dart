import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/constructors/biz_details.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_daily_activity.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/applied_vendors.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/all.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class Companies extends StatefulWidget {
  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  var itemsData = <dynamic>[];
   var _documents = <DocumentSnapshot>[];
bool progress  = false;
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
      color: kWhiteColor,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          space(),
          Container(
            alignment: Alignment.topLeft,
            child: GestureDetector(
            onTap: (){
    _showAllCompanies();
    },
        child: BizConstruct(),

            ),
          ),


    space(),
          itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
          itemsData.length == 0 && progress == true ? TextWidget(name: kNoVendorCompany,
          textColor: kTextColor,
          textSize: kFontSize,
          textWeight: FontWeight.bold,):

          Row(


            children: <Widget>[
          AllCompanyTabs(
            pressFunction: (){
              setState(() {
                VariablesOne.allColor = true;
                VariablesOne.selected = null;
              });
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                builder: (BuildContext context) => OwnerScreen(),
              ),
                  (route) => false,
            );


          },),
              Expanded(
                child: Container(
                    height:bizHeight.h,

                    child: ListView.builder(
                        physics:  BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount:itemsData.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext ctxt, int Index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0, ),
                              child: Container(
                                width: bizWidth.w,
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(kBizCir),
                                        side: BorderSide(
                                            color: kRadioColor,style: BorderStyle.solid,width: kBizSolid.w
                                        )
                                    ),
                                    primary: VariablesOne.selected == Index?kDoneColor:Colors.transparent ,

                                  ),

                                  onPressed: (){
                                    setState(() {
                                      VariablesOne.allColor = false;
                                      VariablesOne.selected = Index;
                                    });
                                    getCompanyDocId(context, Index);
                                  },
                                  child:  TextWidget(name: itemsData[Index]['cc'].toString().toUpperCase(),
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

  Future<void> getCourseCompany() async {
    if( PageConstants.getCompanies.length == 0){
    PageConstants.getCompanies.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection('AllBusiness').orderBy('date').limit(Variables.limit).get();

    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
      setState(() {
        progress = true;
      });

    }else{
      for (DocumentSnapshot document in documents) {
        setState(() {

          _documents.add(document);
          itemsData.add(document.data());

          // PageConstants.getCompanies.clear();

          PageConstants.getCompanies.add(document.data());

        });

      }
    }




  }else{
      setState(() {
        itemsData.addAll( PageConstants.getCompanies);
      });
    }
  }

  void getCompanyDocId(BuildContext context, int index) {

   setState(() {
     PageConstants.companyUD = itemsData[index]['id'];
     PageConstants.companyName = itemsData[index]['biz'];
   });

   Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyDailyAnalysis()));

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
            textColor: kDoneColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),

          /*Row(
            children: <Widget>[
              SvgPicture.asset('assets/imagesFolder/sy.svg',),
              SizedBox(width: 20.w,),
              SvgPicture.asset('assets/imagesFolder/clock.svg',color: kDoneColor,)
            ],
          )*/
        ],
      ),
    );
  }
}

class BizCount extends StatelessWidget {
  BizCount({required this.counting});
  final String counting;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(name: '${'Gas station'.toUpperCase()}- $counting',
            textColor: kDoneColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),

          /*Row(
            children: <Widget>[
              SvgPicture.asset('assets/imagesFolder/sy.svg',),
              SizedBox(width: 20.w,),
              SvgPicture.asset('assets/imagesFolder/clock.svg',color: kDoneColor,)
            ],
          )*/
        ],
      ),
    );
  }
}
