

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/customer_count.dart';
import 'package:easy_homes/dashboard/vendor/daily_row.dart';
import 'package:easy_homes/dashboard/vendor/dashboard_constants.dart';
import 'package:easy_homes/dashboard/vendor/trans_box.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/details_list.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/dash_appbar.dart';
import 'package:easy_homes/utils/dash_silver_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class OrdersHistory extends StatefulWidget {
  @override
  _OrdersHistoryState createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {

  bool moreData = false;
  var _lastDocument;
  bool _loadMoreProgress = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.08);
  }
  var loadKg = <dynamic>[];
  var loadQuantity = <dynamic>[];
  var loadImage = <dynamic>[];

  var viewKg = <dynamic>[];
  var viewQuantity = <dynamic>[];
  var viewImage = <dynamic>[];

  var viewKgNew = <dynamic>[];
  var viewQuantityNew = <dynamic>[];
  var viewImageNew = <dynamic>[];


  var viewAmtNew = <dynamic>[];

  bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getDailyBooking();
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
          SliverList(
              delegate: SliverChildListDelegate([Column(

                children: <Widget>[
                  TransactionBoxSecond(bookings: '',),

                  CustomerCount(period: 'Periods',),
                    DashboardConstants.allOrders.length == 0?  TextWidget(
                    name: kNoBooking2.toString(),
                    textColor: kRadioColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,):

                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:  DashboardConstants.allOrders.length,
                      itemBuilder: (context, int index) {
                        return  Container(
                          margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                          child: Column(

                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[

                                  DateBookings(date: DashboardConstants.allOrders[index]['dt'], time: ''.toString(),),

                                  Column(
                                    children: <Widget>[
                                       DashboardConstants.allOrders[index]['us'] == 0 ||  DashboardConstants.allOrders[index]['us'] == null ?Text(''):   BookingDetails(

                                        kg: '${ DashboardConstants.allOrders[index]['kg']}',
                                        qty:  DashboardConstants.allOrders[index]['cQ'],
                                        type:  DashboardConstants.allOrders[index]['bg'],
                                        number:  DashboardConstants.allOrders[index]['no'], rent: ''.toString(),

                                      ),

                                       DashboardConstants.allOrders[index]['acy'] == 0 || DashboardConstants.allOrders[index]['acy'] == null ?Text(''): NewBookingDetails(
                                        amt: DashboardConstants.allOrders[index]['nam'],
                                        kg:  DashboardConstants.allOrders[index]['nKG'],
                                        qty:  DashboardConstants.allOrders[index]['ncQ'],
                                        type:  DashboardConstants.allOrders[index]['bg'],
                                        number:  DashboardConstants.allOrders[index]['nno'], kgs: ''.toString(), rent: ''.toString(), quantity: ''.toString(),

                                      ),
                                    ],
                                  ),




                                  AmountOrders( amount:  DashboardConstants.allOrders[index]['amt'],mop:  DashboardConstants.allOrders[index]['mp'], gas: ''.toString() ,),



                                ],
                              ),


                            ],
                          ),
                        );
                      }
                  ),




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
/*

  Future<void> getDailyBooking() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily").where(
        'ud', isEqualTo: Variables.userUid)
        .orderBy('dt',descending: true).limit(Variables.limit)
        .get();


    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
      setState(() {
        progress = true;
      });

    }else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;

        setState(() {
          _documents.add(document);
           DashboardConstants.allOrders.add(document.data);

          //loadKg = result.data['kg'];
          loadQuantity.addAll(data['cQ']);
          loadKg.addAll(data['kg']);
          loadImage.addAll(data['cyt']);
        });
      }
    }

  }


  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily").where(
        'id', isEqualTo: Variables.userUid)
        .orderBy('dt',descending: true).startAfterDocument(_lastDocument).limit(Variables.limit)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if(documents.length == 0){
      setState(() {
        _loadMoreProgress = true;
      });

    }else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;

        setState(() {
          moreData = true;
          _documents.add(document);
           DashboardConstants.allOrders.add(document.data);

          moreData = false;

          //loadKg = result.data['kg'];
          loadQuantity.addAll(data['cQ']);
          loadKg.addAll(data['kg']);
          loadImage.addAll(data['cyt']);

        });
      }
    }
  }
*/


  /*void getBookingDetails(int index,  DashboardConstants.allOrders,  DashboardConstants.allOrders2) {

    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name:  DashboardConstants.allOrders[index]['dt'].toUpperCase() + " " + DashboardConstants.allOrders[index]['tm'],
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content: DetailsList(length: viewKg,kg: viewKg, image: viewImage,quantity: viewQuantity),

          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kDone),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidget(
              name:   DashboardConstants.allOrders.toString() + " " + DashboardConstants.allOrders2.toString(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            DetailsList(length: viewKg,kg: viewKg, image: viewImage,quantity: viewQuantity),
            spacer(),
            DetailsBtn()
          ],
        ));


  }

}

*/