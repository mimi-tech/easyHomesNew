import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_activity_page.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_daily_activity.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyAnalysis/com_Daily_analysis.dart';
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

class CompanyActivityTab extends StatefulWidget {
  CompanyActivityTab({
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
  _CompanyActivityTabState createState() => _CompanyActivityTabState();
}

class _CompanyActivityTabState extends State<CompanyActivityTab> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyDailyAnalysis()));

            },
            child: Container(
              decoration: BoxDecoration(
                  color:widget.azColor,
                  border: Border.all(color: kRadioColor,width: 1.0)
              ),


              width:kAZWidth.w,
              height: kAZHeight.h,

              child: Center(
                child: TextWidget(name: 'A-Z'.toUpperCase(),
                  textColor: widget.azTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.normal,),
              ),

            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyDailyAnalysisPage()));


            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kRadioColor,width: 1.0),
                color: widget.activityColor,
              ),
              width:kAZWidth.w,
              height: kAZHeight.h,
              child:  Center(
                child: TextWidget(name: kActivity.toUpperCase(),
                  textColor: widget.activityTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.normal,),
              ),

            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CompanyAdminLogs()));

            },
            child: Container(
              width:kAZWidth.w,
              height: kAZHeight.h,
              decoration: BoxDecoration(
                border: Border.all(color: kRadioColor,width: 1.0),
                color: widget.logColor,
              ),

              child:  Center(
                child: TextWidget(name: kLog.toUpperCase(),
                  textColor: widget.logTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.normal,),
              ),
            ),
          ),




        ],
      ),
    );
  }

}


