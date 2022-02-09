import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/customer_count.dart';
import 'package:easy_homes/dashboard/vendor/daily_row.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';


class CustomerWeeklyBooking extends StatefulWidget {
  @override
  _CustomerWeeklyBookingState createState() => _CustomerWeeklyBookingState();
}

class _CustomerWeeklyBookingState extends State<CustomerWeeklyBooking> {
   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];

  bool _loadMoreProgress = false;
  var _lastDocument;
  bool moreData = false;
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.08);
  }
bool progress = false;
  var loadKg = <dynamic>[];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDailyBooking();
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
          delegate: SliverChildListDelegate([
          Column(

        children: <Widget>[
          TransactionBox(bookings: loadKg.length.toString(),),
          CustomerCount(period: kWeekly,),
          itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
          itemsData.length == 0 && progress == true ? ErrorTitle(errorTitle: kNoBooking.toString()):

          ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _documents.length,
              itemBuilder: (context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Column(

                    children: <Widget>[
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          DateBookings(date:DateFormat('d MMM, yyyy').format(DateTime.parse(itemsData[index]['dt'])),
                            time:DateFormat('h:mm:a').format(DateTime.parse(itemsData[index]['dt'])),
                          ),

                          Column(
                            children: <Widget>[
                              BookingDetails(
                                kg: '${itemsData[index]['gk']} $kKG2',
                                type: ''.toString(),
                                number: ''.toString(),
                                rent: ''.toString(),
                                qty: ''.toString(),
                              ),

                              itemsData[index]['acy'] == null?Text(''):NewBookingDetails(
                                kg: '${itemsData[index]['gk']} $kKG2',
                                qty: loadKg.length.toString(),
                                type: ''.toString(),
                                number: ''.toString(),
                                rent: ''.toString(),
                                kgs: ''.toString(),
                                quantity: ''.toString(),
                                amt: ''.toString(),
                              )


                            ],
                          ),




                          AmountOrders( amount: itemsData[index]['amt'],mop: itemsData[index]['mp'],
                            gas: ''.toString() ,),



                        ],
                      ),



                    ],
                  ),
                );
              }
          ),
          progress == true || _loadMoreProgress == true
              || _documents.length < Variables.limit
              ?Text(''):
          moreData == true? PlatformCircularProgressIndicator():GestureDetector(
              onTap: (){loadMore();},
              child: SvgPicture.asset('assets/imagesFolder/load_more.svg',))





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

  Future<void> getDailyBooking() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily").where(
        'ud', isEqualTo: Variables.userUid)
        .where('yr',isEqualTo: DateTime.now().year)
        .where('mth',isEqualTo: DateTime.now().month)
        .where('wkm',isEqualTo: Jiffy().week).orderBy('dt',descending: true).limit(Variables.limit)

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
          itemsData.add(document.data());


             loadKg = List.from(data['kg']);

        });
      }
    }

  }


  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily").where(
        'ud', isEqualTo: Variables.userUid)
        .where('yr',isEqualTo: DateTime.now().year)
        .where('mth',isEqualTo: DateTime.now().month)
        .where('wkm',isEqualTo: Jiffy().week).

    orderBy('dt',descending: true).startAfterDocument(_lastDocument).limit(Variables.limit)

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
          itemsData.add(document.data());

          moreData = false;
             loadKg = List.from(data['kg']);

        });
      }
    }
  }



}

