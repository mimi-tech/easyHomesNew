
import 'dart:io';
import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_vendor_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/stations/station_home.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/all.dart';
import 'package:easy_homes/admins/pages/tabs/show_company_admins.dart';
import 'package:easy_homes/admins/partners/business_screen.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class BizVendorsTabs extends StatefulWidget {
  @override
  _BizVendorsTabsState createState() => _BizVendorsTabsState();
}

class _BizVendorsTabsState extends State<BizVendorsTabs> {

  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          space(),
          space(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              GestureDetector(
                onTap: () {
                  _showAllCompanies();
                },
                child: BizConstruct(),

              ),
              /*GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ShowCompanyAdmins()));

                },
                child: TextWidget(name: kSectary.toUpperCase(),
                  textColor: kDoneColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,),
              ),

              GestureDetector(
                onTap: (){_showAllCompanies();},
                child: TextWidget(name: kViewAll,
                  textColor: kDoneColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,),
              ),*/
            ],
          ),

          PageConstants.getCompanies.length == 0 ?TextWidget(name: '0',
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
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BusinessScreen()));



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
      //PageConstants.vv = PageConstants.getCompanies[index]['vId'];
      PageConstants.companyName = PageConstants.getCompanies[index]['biz'];
     // PageConstants.venName = PageConstants.getCompanies[index]['fn'];
    });
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: StationHome()));



   /* Platform.isIOS ?
    *//*show ios bottom modal sheet*//*
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          BizVendorLogs()
        ],
      );
    })

        : showModalBottomSheet(

        isScrollControlled: true,
        context: context,
        builder: (context) => BizVendorLogs()
    );
*/


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
          content: ListView.builder(
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
            ListView.builder(
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
