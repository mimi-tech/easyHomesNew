import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/dashboard_page.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dashboard/vendor/self_orders.dart';
import 'package:easy_homes/dashboard/vendor/view_orders.dart';
import 'package:easy_homes/dashboard/vendor/view_rate.dart';
import 'package:easy_homes/dashboard/vendor/subscriber_chart..dart';
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

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class VendorTodayEarnings extends StatefulWidget {
  @override
  _VendorTodayEarningsState createState() => _VendorTodayEarningsState();
}

class _VendorTodayEarningsState extends State<VendorTodayEarnings> {
  double height = 5.0;
  double elevation = 20;
  var itemsData = <dynamic>[];
  var _ongoingDoc = <DocumentSnapshot>[];

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }

  var data = <SubscriberSeries>[];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingOrders();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PlatformScaffold(
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
                      IconButton(icon: Icon(

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

                      margin: EdgeInsets.symmetric(
                          horizontal: kHorizontal),
                      child: Card(
                        elevation: kCardElevation2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                kCardBorder ),
                          ),
                          child: Column(children: <Widget>[
                            spacer(),
                            TextWidget(
                              name: kToday.toUpperCase(),
                              textColor: kRadioColor,
                              textSize: kFontSize,
                              textWeight: FontWeight.w500,
                            ),

                            SizedBox(height: 20.h,),
                          itemsData.length == 0?TextWidget(name: '0.00'.toUpperCase(),
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,): TextWidget(
                              name: itemsData[0]['day'] == DateTime.now().day &&
                                  itemsData[0]['wky'] == Jiffy().week
                                  ? '#${VariablesOne.numberFormat.format(itemsData[0]['p4d']).toString()}'
                                  : '0.00',
                              textColor: kBlackColor,
                              textSize: kFontSize,
                              textWeight: FontWeight.bold,
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
                                  Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                          'assets/imagesFolder/small_cy.svg'),
                                      SizedBox(width: 4,),
                                      itemsData.length == 0 ?TextWidget(name: '0'.toUpperCase(),
                                        textColor: kTextColor,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.bold,):TextWidget(
                                        name: itemsData[0]['day'] == DateTime.now().day
                                            ? ' ${itemsData[0]['dai'].toString()} Orders'
                                            : '0 Order',
                                        textColor: kBlackColor,
                                        textSize: kFontSize14,
                                        textWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton(
                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset('assets/imagesFolder/clock.svg'),
                                        SizedBox(width: 4,),
                                        itemsData.length == 0?TextWidget(name: 'None'.toUpperCase(),
                                          textColor: kTextColor,
                                          textSize: kFontSize14,
                                          textWeight: FontWeight.bold,): TextWidget(
                                          name: itemsData[0]['day'] == DateTime.now().day
                                              ? 'Time taken'
                                              : '0 hr',
                                          textColor: kBlackColor,
                                          textSize: kFontSize14,
                                          textWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: TextWidget(
                                            name: '${itemsData[0]['tt']}',
                                            textColor: kDoneColor,
                                            textSize: kFontSize14,
                                            textWeight: FontWeight.w500,
                                          ),
                                      ),
                                       ]

                                  ),
                                ],
                              ),
                            ),
                            spacer(),
                          ])
                      ),
                    ),
                    spacer(),

                    /*display the wallet details*/

                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: kHorizontal),
                      child: Card(
                        elevation: kCardElevation2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              kCardBorder ),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: kHorizontal),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              spacer(),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  TextWidget(
                                    name: kWalletBal.toUpperCase(),
                                    textColor: kDoneColor,
                                    textSize: kFontSize14,
                                    textWeight: FontWeight.bold,
                                  ),
                                  MoneyFormatColors(
                                    color: kTextColor,
                                    title: TextWidget(
                                      name: '${VariablesOne.numberFormat.format(Variables.currentUser[0]['wal']).toString()}',
                                      textColor: kTextColor,
                                      textSize: kFontSize,
                                      textWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),


                              Divider(),
                              itemsData.length == 0?Container(
                                height: 30.h,
                              ):SubscriberChart(
                                data: data,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    spacer(),
                    ViewRatings(),
                    spacer(),

                    ViewOrders(orderHistory:'',orderCount: DashboardConstants.upcomingOrders.length,totalOrder: itemsData.length == 0?'':itemsData[0]['ab'].toString(),),
                    spacer(),
                    VendorSelfOrders(ongoing: _ongoingDoc.length == 0?'0':_ongoingDoc.length.toString(),),
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
    DashboardConstants.upcomingOrders.clear();
    DashboardConstants.ongoingOrders.clear();

    setState(() {
  VariablesOne.isUpcoming = true;
});

    final QuerySnapshot result = await FirebaseFirestore.instance
.collection('Upcoming')
        .where('vid', isEqualTo:Variables.userUid )
        .where('vf',isEqualTo: false)
        //.where('day',isGreaterThanOrEqualTo: DateFormat('d').format(DateTime.now()))
        .where('mth',isGreaterThanOrEqualTo:  DateFormat('MM').format(DateTime.now()))
        .where('yr',isEqualTo: DateFormat('yyyy').format(DateTime.now()))
        .where('gv',isEqualTo: false )
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {

    } else {

     for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {DashboardConstants.upcomingOrders.add(document.data());

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


    FirebaseFirestore.instance
        .collection('vendorCount')
        .where('vid', isEqualTo: Variables.userUid).get().then((value) {
      value.docs.forEach((result) {
        setState(() {
          itemsData.add(result.data());
          data = [
            SubscriberSeries(
              year: "S",
              subscribers: result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 7
                  ? result.data()['amt']
                  : 100000,
              barColor:result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 7
                  ?  charts.ColorUtil.fromDartColor(kSeaGreen)
                  :  charts.ColorUtil.fromDartColor(kLightGreen),
            ),
            SubscriberSeries(
              year: "M",
              subscribers: result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 1

                  ? result.data()['amt']
                  : 150000,
              barColor:result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 1
                  ?  charts.ColorUtil.fromDartColor(kSeaGreen)
                  :  charts.ColorUtil.fromDartColor(kLightGreen),
            ),
            SubscriberSeries(
              year: "T",
              subscribers: result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 2
                  ? result.data()['amt']
                  : 120000,
              barColor:result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 2
                  ?  charts.ColorUtil.fromDartColor(kSeaGreen)
                  :  charts.ColorUtil.fromDartColor(kLightGreen),
            ),
            SubscriberSeries(
              year: "W",
              subscribers: result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 3
                  ? result.data()['amt']
                  : 110000,
              barColor:result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 3
                  ?  charts.ColorUtil.fromDartColor(kSeaGreen)
                  :  charts.ColorUtil.fromDartColor(kLightGreen),
            ),
            SubscriberSeries(
              year: "TH",
              subscribers: result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 4
                  ? result.data()['amt']
                  : 90000,
              barColor:result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 4
                  ?  charts.ColorUtil.fromDartColor(kSeaGreen)
                  :  charts.ColorUtil.fromDartColor(kLightGreen),
            ),
            SubscriberSeries(
              year: "F",
              subscribers: result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 5
                  ? result.data()['amt']
                  : 80000,
              barColor:result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 5
                  ?  charts.ColorUtil.fromDartColor(kSeaGreen)
                  :  charts.ColorUtil.fromDartColor(kLightGreen),
            ),
            SubscriberSeries(
              year: "SAT",
              subscribers: result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 6
                  ? result.data()['amt']
                  : 130000,
              barColor:result.data()['day'] ==
                  DateTime.now().day && result.data()['wkd'] == 6
                  ?  charts.ColorUtil.fromDartColor(kSeaGreen)
                  :  charts.ColorUtil.fromDartColor(kLightGreen),
            ),

          ];
        });
      });
    });
    
    
  }
}
