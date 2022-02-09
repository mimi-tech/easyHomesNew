import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/order_history.dart';
import 'package:easy_homes/dashboard/customer/w.dart';
import 'package:easy_homes/dashboard/deposit-details.dart';
import 'package:easy_homes/dashboard/list_all_payment.dart';
import 'package:easy_homes/dashboard/vendor/orders.dart';
import 'package:easy_homes/dashboard/vendor/payment.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class DashBoardTab extends StatefulWidget {


  @override
  _DashBoardTabState createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLightBrown,
          bottom: TabBar(
            tabs: [
              Tab( text: 'D/W'),
              Tab( text: "My orders"),
              //Tab( text: "Payments"),
              Tab( text: "History"),

            ],
          ),
          title: TextWidgetAlign(
            name: kAllTrans,
            textColor: kWhiteColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,),


        ),
        body: TabBarView(
          children: [
            //DWTransaction(),
            DepositDetails(),
            MyOrders(),
           // ListOfAllPayment(),
            PaymentTransaction(),
          ],
        ),
      ),
    );
  }
}
