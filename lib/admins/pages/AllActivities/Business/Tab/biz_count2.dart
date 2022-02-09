import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_vendor_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_count.dart';
import 'package:badges/badges.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/applied_vendors.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/all.dart';
import 'package:easy_homes/admins/partners/business_screen.dart';
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
import 'package:easy_homes/admins/pages/tabs/show_company_admins.dart';
class BizVendorsSecond extends StatefulWidget {
  @override
  _BizVendorsSecondState createState() => _BizVendorsSecondState();
}

class _BizVendorsSecondState extends State<BizVendorsSecond> {
  var itemsData = <dynamic>[];
   var _documents = <DocumentSnapshot>[];
  bool progress = false;
  List<dynamic> vendorWorking = <dynamic>[];
  List<dynamic> transitCount = <dynamic>[];


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

    /* Iterable<dynamic> count = vendorWorking.where((element) => (element == true));
    Iterable<dynamic> logout = vendorWorking.where((element) => (element == false));
    Iterable<dynamic> transit = vendorWorking.where((element) => (element == true));
*/

    Iterable<dynamic> count =  PageConstants.vendorCount.where((element) => element['ol'] == true);
    Iterable<dynamic> logout =  PageConstants.vendorCount.where((element) => element['ol'] == false);
    Iterable<dynamic> transit =  PageConstants.vendorCount.where((element) => element['tr'] == true);

    PageConstants.getLoginCount.clear();
    PageConstants.getLogOutCount.clear();
    PageConstants.getWorkingCount.clear();

    PageConstants.getLoginCount.addAll(count);
    PageConstants.getLogOutCount.addAll(logout);
    PageConstants.getWorkingCount.addAll(transit);
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      PageTransition(
                          type: PageTransitionType
                              .scale,
                          alignment: Alignment
                              .bottomCenter,
                          child: ShowCompanyAdmins()));
                },
                child: TextWidget(name: kSectary.toUpperCase(),
                  textColor: kDoneColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,),
              ),

              TextWidget(name: kVendor.toUpperCase(),
                textColor: kDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.bold,),
              Badge(
                badgeContent: TextWidget(
                  name:  AdminConstants.appliedVendorList.length.toString(),
                  textColor: kWhiteColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: kBadgeMargin),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        AdminConstants.appliedColor = true;
                      });
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.bottomCenter,
                              child: AppliedVendors()));
                    },
                    child: TextWidget(
                      name: kAppliedVendor,
                      textColor: AdminConstants.appliedColor == true?kLightDoneColor: kDoneColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.bold,
                    ),
                  ),
                ),
                toAnimate: true,
                badgeColor: kRedColor,
                shape: BadgeShape.circle,
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
              ),

              GestureDetector(
                onTap: (){
                  _showAllCompanies();
                },
                child: TextWidget(name: kViewAll,
                  textColor: kDoneColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,),
              ),
            ],
          ),


          PageConstants.vendorCount.length == 0?
          TextWidgetAlign(
            name: kNoVendorCompany,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,):  Row(
            children: <Widget>[
              AllCompanyTabs(
                pressFunction: (){
                  setState(() {
                    VariablesOne.allColor = true;
                    VariablesOne.selected = null;
                  });
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BusinessScreen()));



                },),
              Expanded(
                child: Container(
                    height:40.0,
                    child: ListView.builder(
                        physics:  BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount:PageConstants.vendorCount.length,
                        itemBuilder: (BuildContext ctxt, int Index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0, ),
                              child: Container(
                                color: VariablesOne.selected == Index?kDoneColor:Colors.transparent ,
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                child: OutlineButton(
                                  onPressed: (){
                                    setState(() {
                                      VariablesOne.allColor = false;
                                      VariablesOne.selected = Index;
                                    });
                                    getCompanyDocId(context, Index);
                                  },
                                  child:  TextWidget(name: PageConstants.vendorCount[Index]['fn'].toString().toUpperCase(),
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
          ),
          BusinessCountingPage(login: count.length,logOut: logout.length,transit: transit.length,counting: PageConstants.vendorCount.length,),


        ],
      ),
    );
  }

  Future<void> getCourseCompany() async {


    /*get the applied vendor count*/
    final QuerySnapshot data = await FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('cbi', isEqualTo: Variables.userUid)
        .where('appr', isEqualTo: false)
        .orderBy('ts', descending: true)
        .get();

    final List<DocumentSnapshot> vendorDoc = data.docs;

    for (DocumentSnapshot venList in vendorDoc) {
      setState(() {
        AdminConstants.appliedVendorList.clear();
        AdminConstants.appliedVendorList.add(venList.data);
      });
    }

  }

  void getCompanyDocId(BuildContext context, int index) {

    setState(() {
      PageConstants.companyUD = PageConstants.vendorCount[index]['vId'];
      PageConstants.companyName = PageConstants.vendorCount[index]['biz'];
    });
    print(PageConstants.companyUD);
    Navigator.push(context,
        PageTransition(
            type: PageTransitionType
                .scale,
            alignment: Alignment
                .bottomCenter,
            child: BizVendorLogs()));

  }

  void _showAllCompanies() {

    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidgetAlign(
            name: kListOfBuz,
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
                physics:  BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount:PageConstants.getCompanies.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0, ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: GestureDetector(
                          onTap: (){
                            getCompanyDocId(context, Index);
                          },
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.ac_unit,color: kLightBrown,),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                                    child:  TextWidget(name: '${PageConstants.getCompanies[Index]['fn'].toString().toUpperCase()} ${PageConstants.getCompanies[Index]['ln'].toString().toUpperCase()}',

                                      textColor: kTextColor,
                                      textSize: kFontSize,
                                      textWeight: FontWeight.normal,),

                                  ),
                                ],
                              ),
                              space(),
                            ],
                          ),
                        ),
                      )


                  );
                }
            ),
          ),

          actions: <Widget>[

            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kDone),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidgetAlign(
              name:  kListOfBuz,
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            Container(
              width: double.maxFinite,
              child: ListView.builder(
                  physics:  BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:PageConstants.getCompanies.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0, ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              getCompanyDocId(context, Index);
                            },
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.ac_unit,color: kLightBrown,),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                                      child: TextWidget(name: '${PageConstants.getCompanies[Index]['fn'].toString().toUpperCase()} ${PageConstants.getCompanies[Index]['ln'].toString().toUpperCase()}',

                                        textColor: kTextColor,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.normal,),

                                    ),
                                  ],
                                ),
                                space(),
                              ],
                            ),
                          ),
                        )


                    );
                  }
              ),
            ),


            Container(
                margin: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                child: DoneVendor(title: kDone,nextFunction: (){Navigator.pop(context);},bgColor: kDoneColor,))
          ],
        ));

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
