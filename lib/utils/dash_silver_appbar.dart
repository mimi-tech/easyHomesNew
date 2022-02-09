import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/customer_bookings.dart';
import 'package:easy_homes/dashboard/dashbarTab_W.dart';
import 'package:easy_homes/dashboard/dashbarTab_status.dart';
import 'package:easy_homes/dashboard/deposit-details.dart';
import 'package:easy_homes/dashboard/list_all_payment.dart';
import 'package:easy_homes/dashboard/reset_trans_pin.dart';
import 'package:easy_homes/dashboard/trans_pin.dart';
import 'package:easy_homes/dashboard/vendor/orders.dart';
import 'package:easy_homes/dashboard/vendor/payment.dart';
import 'package:easy_homes/dashboard/withdrawal_details.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SilverAppBarDashBoard extends StatefulWidget implements PreferredSizeWidget{
  SilverAppBarDashBoard({
    required this.tutorialColor,
    required this.coursesColor,
    required this.expertColor,
    required this.eventsColor,
    required this.publishColor,
  });
  final Color tutorialColor;
  final Color coursesColor;
  final Color expertColor;
  final Color eventsColor;
  final Color publishColor;

  @override
  _SilverAppBarDashBoardState createState() => _SilverAppBarDashBoardState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SilverAppBarDashBoardState extends State<SilverAppBarDashBoard> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceElevated: true,
        shape:  RoundedRectangleBorder(
        borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
    )
    ),
    backgroundColor: kWhiteColor,
    pinned: false,
    automaticallyImplyLeading: false,
    floating: true,
    title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: <Widget>[

      GestureDetector(
        onTap: () {
          //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DepositDetails()));
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DashBoardDepositTab()));


        },
        child: TextWidget(
          name: 'Deposits',
          textColor: widget.coursesColor,
          textSize: 14,
          textWeight: FontWeight.bold,
        ),
      ),

      GestureDetector(
        onTap: () {
          //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: WithdrawalDetails()));
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DashBoardWithdrawalTab()));

    },
        child: TextWidget(
          name: 'Withdrawals',
          textColor: widget.tutorialColor,
          textSize: 14,
          textWeight: FontWeight.bold,
        ),
      ),

      GestureDetector(
        onTap: () {
          //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListOfAllPayment()));
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DashBoardStatusTab()));


        },
        child: TextWidget(
          name: 'Status',
          textColor: widget.eventsColor,
          textSize: 14,
          textWeight: FontWeight.bold,
        ),
      ),

    ]
    )
    );
  }
}