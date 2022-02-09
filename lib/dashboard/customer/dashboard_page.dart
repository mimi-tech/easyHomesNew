import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/all_business.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/account_details.dart';
import 'package:easy_homes/funds/deposit_amount.dart';
import 'package:easy_homes/funds/funds_bottom.dart';
import 'package:easy_homes/dashboard/customer/view_customer_order.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/funds_bottom.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/withdrawal/withdrawal_amount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/dashboard/vendor/subscriber_series.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';


class CustomerDashBoard extends StatefulWidget {
  @override
  _CustomerDashBoardState createState() => _CustomerDashBoardState();
}

class _CustomerDashBoardState extends State<CustomerDashBoard> {
  double height = 5.0;
  double elevation = 20;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }

  var data = <SubscriberSeries>[];
  var itemsData = <dynamic>[];
  var _ongoingDoc = <DocumentSnapshot>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingOrders();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child:Stack(
                  children: <Widget>[
                    Container(

                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: kLightBrown,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: 10),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  PlatformIconButton(icon: Icon(

                                      Icons.arrow_back_ios,
                                    color: kWhiteColor,
                                  ), onPressed: (){
                                   Navigator.pop(context);
                                  }),
                                  TextWidget(
                                    name: kDashBoard.toUpperCase(),
                                    textColor: kWhiteColor,
                                    textSize: 20,
                                    textWeight: FontWeight.bold,
                                  ),
                                  ProfilePicture()
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  height: height.h,
                                ),


                                Container(

                                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                                  child: Card(
                                    elevation: kCardElevation2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            kCardBorder ),
                                      ),
                                      child: Column(
                                          children: <Widget>[
                                        spacer(),
                                        TextWidget(
                                          name: 'Wallet balance'.toUpperCase(),
                                          textColor: kRadioColor,
                                          textSize: kFontSize,
                                          textWeight: FontWeight.w500,
                                        ),

                                        SizedBox(height: 20.h,),
                                            MoneyFormatSecond(
                                          color: kBlackColor,
                                          title: TextWidgetAlign(
                                            name: '${VariablesOne.numberFormat.format(Variables.currentUser[0]['wal']).toString()}',
                                            textColor: kBlackColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.bold,
                                          ),
                                        ),

                                        Divider(),
                                        SizedBox(
                                          height: height.h,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: kHorizontal),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              GestureDetector(
                                                  onTap:(){
                                                    Platform.isIOS ?
                                                    /*show ios bottom modal sheet*/
                                                    showCupertinoModalPopup(

                                                        context: context, builder: (BuildContext context) {
                                                      return CupertinoActionSheet(
                                                        actions: <Widget>[
                                                          FundWallet()
                                                          //DepositAmount()
                                                        ],
                                                      );
                                                    })

                                                        : showModalBottomSheet(
                                                        isDismissible: false,
                                                        isScrollControlled: true,
                                                        context: context,
                                                        builder: (context) => FundWallet()
                                                    );

                                                  },

                                                  child: Containers(name: 'FUND WALLET',)),
                                              GestureDetector(

                                                  onTap:(){
                                                    Platform.isIOS ?
                                                    /*show ios bottom modal sheet*/
                                                    showCupertinoModalPopup(

                                                        context: context, builder: (BuildContext context) {
                                                      return CupertinoActionSheet(
                                                        actions: <Widget>[
                                                          WithdrawalAmount()
                                                        ],
                                                      );
                                                    })

                                                        : showModalBottomSheet(
                                                        isDismissible: false,
                                                        isScrollControlled: true,
                                                        context: context,
                                                        builder: (context) => WithdrawalAmount()
                                                    );

                                                  },
                                                  child: Containers(name: 'WITHDRAWAL',)),
                                            ],
                                          ),
                                        ),
                                        spacer(),
                                      ])
                                  ),
                                ),
                                spacer(),

                                /*display the ACCOUNT details*/
                                AccountDetails(),
                                spacer(),


                                ViewCustomerOrders(
                                  ongoing:_ongoingDoc.length,
                                  orderHistory: itemsData.length,
                                  orderCount: DashboardConstants.upcomingOrders.length,),
                                spacer(),
                                spacer(),



                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ))));
  }

  Future<void> getUpcomingOrders() async {
    DashboardConstants.ongoingOrders.clear();
    DashboardConstants.upcomingOrders.clear();
    DashboardConstants.allOrders.clear();

    setState(() {
      VariablesOne.isUpcoming = true;
    });
    print('pppppppppp');
    final QuerySnapshot result = await   FirebaseFirestore.instance.collection("Upcoming")
        .where('cud', isEqualTo:Variables.userUid )
        .where('vf',isEqualTo: false)
       // .where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
        .where('mth',isGreaterThanOrEqualTo:  DateFormat('MM').format(DateTime.now()))
        .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
        .where('gv',isEqualTo: false )
        .get();
    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){

    }else {
      for ( DocumentSnapshot document in documents) {
        print(document);
        setState(() {
          DashboardConstants.upcomingOrders.add(document.data());

        });

      }}

//for ongoing order
    FirebaseFirestore.instance.collection('customer')
        .where('vid', isEqualTo: Variables.currentUser[0]['vid'])
        .where('cud', isEqualTo: Variables.userUid) //Variables.userUid)
        .where('del',isEqualTo: false)
        .get().then((value) {
      value.docs.forEach((result) {
        setState(() {

          DashboardConstants.ongoingOrders.add(result.data());
          _ongoingDoc.add(result);
        });
      });
    });
   /* ///for customer

    FirebaseFirestore.instance.collection('vendorDaily')
        .where('ud', isEqualTo: Variables.userUid)
        .get().then((value) {
      value.docs.forEach((result) {
       setState(() {
         itemsData.add(result.data);
         DashboardConstants.allOrders.add(result.data());
       });
      });


    });


    if(Variables.userCat == AdminConstants.owner){
      ///for owner

      FirebaseFirestore.instance.collection('vendorDaily')
          .where('od', isEqualTo: Variables.userUid)
          .get().then((value) {
        value.docs.forEach((result) {
          setState(() {
            itemsData.add(result.data);
            DashboardConstants.allOrders.add(result.data());
          });
        });
      });

    }else if (Variables.userCat == AdminConstants.partner){
      ///for partner

      FirebaseFirestore.instance.collection
('vendorDaily')
          .where('pd', isEqualTo: Variables.userUid)
          .get().then((value) {
        value.docs.forEach((result) {
          setState(() {
            itemsData.add(result.data);
            DashboardConstants.allOrders.add(result.data());
          });
        });
      });
    }else if(Variables.userCat == AdminConstants.business){
      ///for business

      FirebaseFirestore.instance.collection
('vendorDaily')
          .where('cbi', isEqualTo: Variables.userUid)
          .get().then((value) {
        value.docs.forEach((result) {
          setState(() {
            itemsData.add(result.data());
            DashboardConstants.allOrders.add(result.data());
          });
        });
      });
    }

    *//*get ongoing order*//*
    FirebaseFirestore.instance.collection('customer')
        .where('vid', isEqualTo: Variables.currentUser[0]['vid'])
        .where('cud', isEqualTo: Variables.userUid) //Variables.userUid)
        .where('del',isEqualTo: false)
        .get().then((value) {
      value.docs.forEach((result) {
       setState(() {

         DashboardConstants.ongoingOrders.add(result.data());
         _ongoingDoc.add(result);
       });
      });
    });*/

  }



}


class Containers extends StatelessWidget {
  Containers({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration:BoxDecoration(
        color:kLightBrown.withOpacity(0.2),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),

      ),

      child: TextWidget(name: name,
        textColor: kLightBrown,
        textSize: kFontSize14,
        textWeight: FontWeight.bold,
      ),
    );
  }
}
