

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/customer/customer_count.dart';
import 'package:easy_homes/dashboard/earnings_construct.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];

  bool moreData = false;
  var _lastDocument;
  bool _loadMoreProgress = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.08);
  }
late List <dynamic> kg;
  bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDailyBooking();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        //appBar: DashAppBar(title: 'My orders',),
        body: CustomScrollView(slivers: <Widget>[
         /* SilverAppBarDashBoard(
            tutorialColor: kDoneColor,
            eventsColor: kBlackColor,
            expertColor: kBlackColor,
            coursesColor: kBlackColor,
            publishColor: kBlackColor,
          ),*/
          SliverAppBar(

            backgroundColor: kWhiteColor,
            pinned: true,
            automaticallyImplyLeading: false,
            floating: true,
            // collapsedHeight: 80,

            flexibleSpace:Center(child: OrdersPeriod()),),
          SliverList(
            delegate: SliverChildListDelegate([

              Column(

                children: <Widget>[
                  //TransactionBox(bookings: _documents.length.toString(),),
                  // DailyRow(period: kToday,),
                  itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                  itemsData.length == 0 && progress == true ?  ErrorTitle(errorTitle: kNoBooking.toString()):

                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _documents.length,
                      itemBuilder: (context, int index) {
                        return Card(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                            child: Column(

                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[

                                    DateBookings(date:DateFormat('d MMM, yyyy').format(DateTime.parse(itemsData[index]['dt'])),
                                      time:DateFormat('h:mm:a').format(DateTime.parse(itemsData[index]['dt'])),
                                    ),

                                    Column(
                                      children: <Widget>[
                                        itemsData[index]['by'] == true?
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
                                                kgs:  itemsData[index]['kg'],

                                                quantity:  itemsData[index]['cQ'],
                                      qty: ''.toString(), 
                                    number: ''.toString(),
                                    amt: ''.toString(),
                                    kg: ''.toString(),
                                    type: ''.toString(),
                                            )
                                          ],
                                        )
                                            :
                                        BookingDetails(
                                          kg: '${itemsData[index]['gk']}',
                                          rent: itemsData[index]['re'] == true?'(RENT)':'',type: ''.toString(), number: ''.toString(), qty: ''.toString()
                                        ),

                                        itemsData[index]['acy'] == null?Text(''):NewBookingDetails(
                                            rent: itemsData[index]['re'] == true?'(RENT)':'',

                                            kgs:  itemsData[index]['kg'],

                                            quantity: itemsData[index]['cQ'],
                                  qty: ''.toString(),
                                  number: ''.toString(),
                                  amt: ''.toString(),
                                  kg: ''.toString(),
                                  type: ''.toString(),
                                        )


                                      ],
                                    ),



                                    itemsData[index]['by'] == true?
                                    AmountOrders( gas: itemsData[index]['amt'],amount: itemsData[index]['p4'],mop: itemsData[index]['mp'] ,)
                                        :
                                    itemsData[index]['acy'] == null? AmountOrders( gas: itemsData[index]['aG'],amount: itemsData[index]['p4'],mop: itemsData[index]['mp'] ,)
                                        :AmountOrderNew(
                                      gas: itemsData[index]['aG'],
                                      cye: itemsData[index]['py4'],
                                      cylinder: itemsData[index]['acy'],
                                      amount: itemsData[index]['p4'],
                                      mop: itemsData[index]['mp'],
                                      total: itemsData[index]['py4'] + itemsData[index]['p4'],
                                    )

                                  ],
                                ),

                                SizedBox(height: 10,)
                              ],
                            ),
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
            ),

          )
        ])
    )
    );

  }

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
          itemsData.add(document.data());
              kg = List.from(data['kg']);

        });
      }
    }

  }


  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily").where(
        'ud', isEqualTo: Variables.userUid)
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
          itemsData.add(document.data());

          moreData = false;



        });
      }
    }
  }




}

