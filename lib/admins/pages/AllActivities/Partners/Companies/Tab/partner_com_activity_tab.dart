import 'package:easy_homes/admins/constructors/activity_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_daily_activity.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Analysis/partner_daily_analysis.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Activity/partner_com_daily_activity.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Activity/partner_company_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_admin_logs.dart';
import 'package:easy_homes/admins/partners/owner_screen.dart';
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

class PartnerCompanyActivityTab extends StatefulWidget {
  PartnerCompanyActivityTab({
    required this.azColor,
    required this.activityColor,
    required this.logColor,

    required this.azTextColor,
    required this.activityTextColor,
    required this.logTextColor
  });

  final Color azColor;
  final Color activityColor;
  final Color logColor;
  final Color azTextColor;
  final Color activityTextColor;
  final Color logTextColor;
  @override
  _PartnerCompanyActivityTabState createState() => _PartnerCompanyActivityTabState();
}

class _PartnerCompanyActivityTabState extends State<PartnerCompanyActivityTab> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: kWhiteColor,
      child: Column(
        children: <Widget>[
          // space(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){


                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PartnerCompanyDailyAnalysis(),
                    ),
                        (route) => false,
                  );
                },
                child: ActivityTabConstruct(title: 'A-Z',color1: widget.azColor,color2:  widget.azTextColor,),

              ),


              //SvgPicture.asset('assets/imagesFolder/A-Z.svg',),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerDailyAnalysisPage()));


                },
                child:  ActivityTabConstruct(title: kActivity,color1: widget.activityColor,color2:  widget.activityTextColor,),

              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PartnerComAdminLogs()));


                },
                child: ActivityTabConstruct(title: kLog,color1: widget.logColor,color2:  widget.logTextColor,),

              ),


            ],
          ),
        ],
      ),
    );


    /*Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
           color:widget.azColor,
            child: OutlineButton(
              onPressed: (){
                Navigator.push(context,
                    PageTransition(
                        type: PageTransitionType
                            .scale,
                        alignment: Alignment
                            .bottomCenter,
                        child: PartnerCompanyDailyAnalysis()));
              },
              child: TextWidget(name: 'A-Z'.toUpperCase(),
                textColor: widget.azTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,),
            ),
          ),
          //SvgPicture.asset('assets/imagesFolder/A-Z.svg',),
          Container(
            color: widget.activityColor,
            child: OutlineButton(

              onPressed: (){
                Navigator.push(context,
                    PageTransition(
                        type: PageTransitionType
                            .scale,
                        alignment: Alignment
                            .bottomCenter,
                        child: PartnerDailyAnalysisPage()));
              },
              child: TextWidget(name: kActivity.toUpperCase(),
                textColor: widget.activityTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,),
            ),
          ),

          Container(
            color: widget.logColor,
            child: OutlineButton(
              onPressed: (){
                Navigator.push(context,
                    PageTransition(
                        type: PageTransitionType
                            .scale,
                        alignment: Alignment
                            .bottomCenter,
                        child: PartnerComAdminLogs()));
              },
              child: TextWidget(name: kLog.toUpperCase(),
                textColor: widget.logTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,),
            ),
          )

        ],
      ),
    );*/
  }

}


