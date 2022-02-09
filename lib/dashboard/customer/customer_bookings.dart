import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/customer_count.dart';
import 'package:easy_homes/dashboard/earnings_construct.dart';
import 'package:easy_homes/dashboard/vendor/daily_row.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dashboard/vendor/trans_box.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/dash_appbar.dart';
import 'package:easy_homes/utils/dash_silver_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


class CustomerBookings extends StatefulWidget {
  @override
  _CustomerBookingsState createState() => _CustomerBookingsState();
}

class _CustomerBookingsState extends State<CustomerBookings> {
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: DashAppBar(title: kAllTrans,),
      body: CustomScrollView(slivers: <Widget>[
        SilverAppBarDashBoard(

          tutorialColor: kDoneColor,
          eventsColor: kBlackColor,
          expertColor: kBlackColor,
          coursesColor: kBlackColor,
          publishColor: kBlackColor,
        ),

        SliverAppBar(

          backgroundColor: kWhiteColor,
          pinned: true,
          automaticallyImplyLeading: false,
          //floating: true,
          // collapsedHeight: 80,

          flexibleSpace:Center(child: OrdersPeriod()),),
        SliverList(
          delegate: SliverChildListDelegate([

            Column(

        children: <Widget>[
          //TransactionBox(bookings: DashboardConstants.allOrders.length.toString(),),


          DashboardConstants.allOrders.length == 0 ?  TextWidget(
            name: 'Sorry you have no booking'.toString(),
            textColor: kRadioColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,):

          ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: DashboardConstants.allOrders.length,
              itemBuilder: (context, int index) {
                return  Card(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Column(

                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            DateBookings(date:DateFormat('d MMM, yyyy').format(DateTime.parse(DashboardConstants.allOrders[index]['dt'])),
                              time:DateFormat('h:mm:a').format(DateTime.parse(DashboardConstants.allOrders[index]['dt'])),
                            ),

                            Column(
                              children: <Widget>[
                                DashboardConstants.allOrders[index]['by'] == true?
                                Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    TextWidget(
                                      name: '0 TKG',
                                      textColor: kBlackColor,
                                      textSize: kFontSize14,
                                      textWeight: FontWeight.bold,
                                    ),

                                    NewBookingDetails(
                                      rent: '',
                                      kgs:  DashboardConstants.allOrders[index]['kg'],

                                      quantity:  DashboardConstants.allOrders[index]['cQ'],
                                      type: ''.toString(),
                                      kg: ''.toString(),
                                      number: ''.toString(),
                                      qty: ''.toString(),
                                      amt: ''.toString(),
                                    )
                                  ],
                                )


                                    :
                                BookingDetails(
                                  kg: '${DashboardConstants.allOrders[index]['gk']}',
                                  rent: DashboardConstants.allOrders[index]['re'] == true?'(RENT)':'',
                                  type: ''.toString(),
                                  qty: ''.toString(),
                                  number: ''.toString(),
                                ),

                                DashboardConstants.allOrders[index]['acy'] == null?Text(''):NewBookingDetails(
                                    rent: DashboardConstants.allOrders[index]['re'] == true?'(RENT)':'',

                                    kgs:  DashboardConstants.allOrders[index]['kg'],

                                    quantity: DashboardConstants.allOrders[index]['cQ'],
                                  type: ''.toString(),
                                  kg: ''.toString(),
                                  number: ''.toString(),
                                    qty: ''.toString(),
                                      amt: ''.toString(),
                                )


                              ],
                            ),



                            DashboardConstants.allOrders[index]['by'] == true?
                            AmountOrders( gas: DashboardConstants.allOrders[index]['amt'],amount: DashboardConstants.allOrders[index]['p3'],mop: DashboardConstants.allOrders[index]['mp'] ,)
                                :
                            DashboardConstants.allOrders[index]['acy'] == null? AmountOrders( gas: DashboardConstants.allOrders[index]['aG'],amount: DashboardConstants.allOrders[index]['p3'],mop: DashboardConstants.allOrders[index]['mp'] ,)
                                :AmountOrderNew(
                              gas: DashboardConstants.allOrders[index]['aG'],
                              cye: DashboardConstants.allOrders[index]['py3'],
                              cylinder: DashboardConstants.allOrders[index]['acy'],
                              amount: DashboardConstants.allOrders[index]['p3'],
                              mop: DashboardConstants.allOrders[index]['mp'],
                              total: DashboardConstants.allOrders[index]['py3'] + DashboardConstants.allOrders[index]['p3'],
                            )

                          ],
                        ),

                        SizedBox(height: 10,)
                      ],
                    ),
                  ),
                );
              }
          )



        ],
      ),
      ]
    )

    )
        ]
    )
    )
    );
  }





}

