import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/biz/business/B_all.dart';
import 'package:easy_homes/dashboard/biz/business/B_month.dart';
import 'package:easy_homes/dashboard/biz/business/B_today.dart';
import 'package:easy_homes/dashboard/biz/business/B_week.dart';
import 'package:easy_homes/dashboard/biz/business/B_year.dart';
import 'package:easy_homes/dashboard/biz/owner/O_all.dart';
import 'package:easy_homes/dashboard/biz/owner/O_month.dart';
import 'package:easy_homes/dashboard/biz/owner/O_today.dart';
import 'package:easy_homes/dashboard/biz/owner/O_week.dart';
import 'package:easy_homes/dashboard/biz/owner/O_year.dart';
import 'package:easy_homes/dashboard/biz/partner/P_all.dart';
import 'package:easy_homes/dashboard/biz/partner/P_month.dart';
import 'package:easy_homes/dashboard/biz/partner/P_today.dart';
import 'package:easy_homes/dashboard/biz/partner/P_week.dart';
import 'package:easy_homes/dashboard/biz/partner/P_year.dart';
import 'package:easy_homes/dashboard/customer/order_history.dart';
import 'package:easy_homes/dashboard/customer/w.dart';
import 'package:easy_homes/dashboard/deposit-details.dart';
import 'package:easy_homes/dashboard/list_all_payment.dart';
import 'package:easy_homes/dashboard/vendor/all_vendor_bookings.dart';
import 'package:easy_homes/dashboard/vendor/monthly_analysis.dart';
import 'package:easy_homes/dashboard/vendor/orders.dart';
import 'package:easy_homes/dashboard/vendor/payment.dart';
import 'package:easy_homes/dashboard/vendor/transactions.dart';
import 'package:easy_homes/dashboard/vendor/weekly_analysis.dart';
import 'package:easy_homes/dashboard/vendor/yearly_analysis.dart';
import 'package:easy_homes/dashboard/withdrawal_details.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class DashboardTxnTab extends StatefulWidget {


  @override
  _DashboardTxnTabState createState() => _DashboardTxnTabState();
}

class _DashboardTxnTabState extends State<DashboardTxnTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBrown,
          bottom: TabBar(
            tabs: [
              Tab( text: kAll),
              Tab( text: kToday),
              Tab( text: kWeekly),
              Tab( text: kMonthly),
              Tab( text: kYearly),

            ],
          ),
          title: TextWidgetAlign(
            name: kMyEarnings,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),


        ),
        body: TabBarView(
          children: [
            BAll(),
            BToday(),
            BWeek(),
            BMonth(),
            BYear(),
          ],
        ),
      ),
    );
  }
}

class OwnerTxnTab extends StatefulWidget {


  @override
  _OwnerTxnTabState createState() => _OwnerTxnTabState();
}

class _OwnerTxnTabState extends State<OwnerTxnTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBrown,
          bottom: TabBar(
            tabs: [
              Tab( text: kAll),
              Tab( text: kToday),
              Tab( text: kWeekly),
              Tab( text: kMonthly),
              Tab( text: kYearly),

            ],
          ),
          title: TextWidgetAlign(
            name: kMyEarnings,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),


        ),
        body: TabBarView(
          children: [
            OAll(),
            OToday(),
            OWeek(),
            OMonth(),
            OYear(),
          ],
        ),
      ),
    );
  }
}


class PartnerTxnTab extends StatefulWidget {
  @override
  _PartnerTxnTabState createState() => _PartnerTxnTabState();
}

class _PartnerTxnTabState extends State<PartnerTxnTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBrown,
          bottom: TabBar(
            tabs: [
              Tab( text: kAll),
              Tab( text: kToday),
              Tab( text: kWeekly),
              Tab( text: kMonthly),
              Tab( text: kYearly),
            ],
          ),
          title: TextWidgetAlign(
            name: kMyEarnings,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),


        ),
        body: TabBarView(
          children: [
            PAll(),
            PToday(),
            PWeek(),
            PMonth(),
            PYear(),
          ],
        ),
      ),
    );
  }
}


class VendorTxnTab extends StatefulWidget {
  @override
  _VendorTxnTabState createState() => _VendorTxnTabState();
}

class _VendorTxnTabState extends State<VendorTxnTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBrown,
          bottom: TabBar(
            tabs: [
              Tab( text: kAll),
              Tab( text: kToday),
              Tab( text: kWeekly),
              Tab( text: kMonthly),
              Tab( text: kYearly),

            ],
          ),
          title: TextWidgetAlign(
            name: kMyEarnings,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),


        ),
        body: TabBarView(
          children: [
            AllBookingTransaction(),
            BookingTransaction(),
            WeeklyBookingTransaction(),
            MonthlyBookingTransaction(),
            YearlyBookingTransaction(),
          ],
        ),
      ),
    );
  }
}

