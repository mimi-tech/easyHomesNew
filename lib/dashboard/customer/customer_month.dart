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



class CustomerMonth extends StatefulWidget {
  @override
  _CustomerMonthState createState() => _CustomerMonthState();
}

class _CustomerMonthState extends State<CustomerMonth> {
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

  var loadKg = <dynamic>[];
  var loadQuantity = <dynamic>[];
  var loadImage = <dynamic>[];
  bool progress = false;
 var viewKg = <dynamic>[];
  var viewQuantity = <dynamic>[];
  var viewImage = <dynamic>[];

  var viewKgNew = <dynamic>[];
  var viewQuantityNew = <dynamic>[];
  var viewImageNew = <dynamic>[];


  var viewAmtNew = <dynamic>[];


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
          CustomerCount(period: kMonthly,),
          itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
          itemsData.length == 0 && progress == true ?  ErrorTitle(errorTitle: kNoBooking.toString()):

          ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _documents.length,
              itemBuilder: (context, int index) {
                return  Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: Column(

                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                  DateBookings(date:itemsData[index]['dt'], time: '',),

                    Column(
                      children: <Widget>[
                        itemsData[index]['us'] == 0 || itemsData[index]['us'] == null ?Text(''):   BookingDetails(

                          kg: '${itemsData[index]['kg']}',
                          qty: itemsData[index]['cQ'],
                          type: itemsData[index]['bg'],
                          number: itemsData[index]['no'], rent: '',

                        ),

                        itemsData[index]['acy'] == 0 ||itemsData[index]['acy'] == null ?Text(''): NewBookingDetails(
                          amt:itemsData[index]['nam'],
                          kg: itemsData[index]['nKG'],
                          qty: itemsData[index]['ncQ'],
                          type: itemsData[index]['bg'],
                          number: itemsData[index]['nno'], 
                                                quantity: '',
                                                kgs: '',
                                                rent: '',

                        ),
                      ],
                    ),




                          AmountOrders( amount: itemsData[index]['amt'],mop: itemsData[index]['mp'], gas: ''.toString() ,),



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
        .where('mth',isEqualTo: DateTime.now().month).orderBy('dt',descending: true).limit(Variables.limit)

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

          //loadKg = result.data['kg'];
          loadQuantity.addAll(data['cQ']);
          loadKg.addAll(data['kg']);
          loadImage.addAll(data['cyt']);

        });
      }
    }

  }

  void getBookingDetails(int index, itemsData, itemsData2) {

    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name: itemsData[index]['dt'].toUpperCase() + " " +itemsData[index]['tm'],
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
              name:  itemsData.toString() + " " +itemsData2.toString(),
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

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily").where(
        'ud', isEqualTo: Variables.userUid)
        .where('yr',isEqualTo: DateTime.now().year)
        .where('mth',isEqualTo: DateTime.now().month).

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
          loadQuantity.addAll(data['cQ']);
          loadKg.addAll(data['kg']);
          loadImage.addAll(data['cyt']);

        });
      }
    }
  }

}

