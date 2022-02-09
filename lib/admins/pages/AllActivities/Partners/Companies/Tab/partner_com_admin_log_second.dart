

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_sales.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_sec.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/sales_girls.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_sales.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_sec.dart';

import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/show_company_admins.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class PartnerLogTabCompany extends StatefulWidget {
  PartnerLogTabCompany({

    required this.title,
    required this.online,
    required this.offline,
    required this.secColor,
    required this.salesColor,
    required this.venColor,


  });

  final String title;
  final String online;
  final String offline;

  final Color venColor;
  final Color secColor;
  final Color salesColor;

  @override
  _PartnerLogTabCompanyState createState() => _PartnerLogTabCompanyState();
}

class _PartnerLogTabCompanyState extends State<PartnerLogTabCompany> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  var itemsData = <dynamic>[];
   var _documents = <DocumentSnapshot>[];
  bool progress = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          space(),
          space(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerComAdminLogs()));

                },
                child: TextWidget(
                  name: 'All Vendors'.toUpperCase(),
                  textColor: widget.venColor,
                  textSize: 14,
                  textWeight: FontWeight.bold,
                ),
              ),
              //SizedBox(width: spaceSec.w,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerCompanySec()));

                },
                child: TextWidget(
                  name: 'All Secetries'.toUpperCase(),
                  textColor: widget.secColor,
                  textSize: 14,
                  textWeight: FontWeight.bold,
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerComSalesGirls()));

                },
                child: TextWidget(
                  name: 'All sales'.toUpperCase(),
                  textColor: widget.salesColor,
                  textSize: 14,
                  textWeight: FontWeight.bold,
                ),
              ),



            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  elevation: kLogsElevation,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset('assets/imagesFolder/green_dot.svg'),
                        SizedBox(width: 10,),
                        TextWidget(
                          name: widget.online,
                          textColor: kDoneColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        ),


                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  elevation: kLogsElevation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset('assets/imagesFolder/grey_dot.svg'),
                      SizedBox(width: 10,),
                      TextWidget(
                        name: widget.offline,
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),


                    ],
                  ),
                ),
              )
            ],
          ),
          space(),
          Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextWidget(
                name: widget.title,
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
              Spacer(),
              SvgPicture.asset('assets/imagesFolder/clock.svg',color: kDoneColor,),
              SizedBox(width: 40.w,),
              Icon(Icons.remove_circle,color: kDoneColor,size: 18,)
            ],
          ),
          Divider()
        ],
      ),
    );
  }


}

