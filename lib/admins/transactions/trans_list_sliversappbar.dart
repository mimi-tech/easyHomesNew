import 'package:easy_homes/admins/transactions/failed_trans.dart';
import 'package:easy_homes/admins/transactions/fromTo.dart';
import 'package:easy_homes/admins/transactions/paymentList.dart';
import 'package:easy_homes/admins/transactions/success_trans.dart';
import 'package:easy_homes/colors/colors.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SilverAppBarTransList extends StatefulWidget implements PreferredSizeWidget{
  SilverAppBarTransList({
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
  _SilverAppBarTransListState createState() => _SilverAppBarTransListState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SilverAppBarTransListState extends State<SilverAppBarTransList> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        forceElevated: true,
        shape:  RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
            )
        ),
        backgroundColor: kLightBrown,
        pinned: false,
        automaticallyImplyLeading: false,
        floating: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[

              GestureDetector(
                onTap: () {
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AllPaymentTrans()));


                },
                child: TextWidget(
                  name: 'All',
                  textColor: widget.tutorialColor,
                  textSize: 16,
                  textWeight: FontWeight.bold,
                ),
              ),

              IconButton(icon: Icon(Icons.verified,color: widget.coursesColor,), onPressed: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: SuccessTrans()));

              }),
              IconButton(icon: Icon(Icons.error,color: widget.expertColor,), onPressed: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: FailedTrans()));

              }),
              IconButton(icon: Icon(Icons.calendar_today,color: widget.eventsColor,), onPressed: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: FromToTrans()));

              }),



            ]
        )
    );
  }
}