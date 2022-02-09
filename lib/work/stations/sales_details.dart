import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/work/constructors/details_construct.dart';
import 'package:easy_homes/work/stations/order_titles.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SalesDetails extends StatefulWidget {
  @override
  _SalesDetailsState createState() => _SalesDetailsState();
}

class _SalesDetailsState extends State<SalesDetails> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  String? filter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }

  var amount = <dynamic>[];

   var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;


Widget bodyList(int index){
    return Card(
      elevation: 5,
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  name: '${ DateFormat('EE, d MMM, yyyy').format(DateTime.parse(itemsData[index]['dt']))} \n${ DateFormat('h:mm:a').format(DateTime.parse(itemsData[index]['dt']))} ',
                  textColor: kRadioColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
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
                            kgs:  '${itemsData[index]['cKG']} Kg',

                            qty: ''.toString(), 
                                    number: ''.toString(),
                                    amt: ''.toString(),
                                    kg: ''.toString(),
                                    type: ''.toString(), quantity: ''.toString(),
                        )
                      ],
                    )
                        :
                    BookingDetails(
                                kg: '${itemsData[index]['gk']}'.toString(),
                                rent: itemsData[index]['re'] == true?'(RENT)':'', type: '', qty: ''.toString(), number: ''.toString(),
                              ),

                    itemsData[index]['acy'] == null?Text(''):NewBookingDetails(
                        rent: itemsData[index]['re'] == true?'(RENT)':'',

                        kgs:  itemsData[index]['cKG'],

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
                AmountOrderStations( gas: itemsData[index]['amt']  ,mop: itemsData[index]['mp'],)
                    :
                itemsData[index]['acy'] == null? AmountOrderStations( gas: itemsData[index]['aG'],mop: itemsData[index]['mp'] ,)
                    :AmountOrderNewStation(
                  gas: itemsData[index]['aG'],
                  cylinder: itemsData[index]['acy'],
                  mop: itemsData[index]['mp'],
                  total: itemsData[index]['aG'] + itemsData[index]['acy'],
                )

              ],
            ),
          ),
          SizedBox(height: 10,),


        ],
      ),
    );
}

  @override
  Widget build(BuildContext context) {
   return SafeArea(
            child: Scaffold(
                appBar:CancelAppBar(title: 'Sales Details'.toUpperCase(),),
                body:   CustomScrollView(
                slivers: <Widget>[
                SliverAppBar(

                backgroundColor: kWhiteColor,
                pinned: true,
                automaticallyImplyLeading: false,
                floating: true,
                // collapsedHeight: 80,

                flexibleSpace: OrderTitle(),

                ),
                SliverList(
                    delegate: SliverChildListDelegate([


                itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                itemsData.length == 0 && progress == true ? ErrorTitle(errorTitle:'Your have not sold any gas yet'):
                Column(
                  children: [

                    ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _documents.length,
                    itemBuilder: (context, int index) {
                      return  filter == null || filter == "" ?bodyList(index):
                      '${itemsData[index]['fn']}'.toLowerCase()
                          .contains(filter!.toLowerCase())

                          ?bodyList(index):Container();
                    } ),

                    progress == true || _loadMoreProgress == true
                        || _documents.length < Variables.monthsLimit
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
    ));

  }





Future<void> getData() async {
  final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily")
      .where('gd',isEqualTo: Variables.currentUser[0]['ca'])
      .orderBy('dt',descending: true)
      .limit(Variables.monthsLimit)
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



      });



    }
  }
}

Future<void> loadMore() async {

  final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily")
      .where('gd',isEqualTo: Variables.currentUser[0]['ca'])
      .orderBy('dt',descending: true).

  startAfterDocument(_lastDocument).limit(Variables.monthsLimit)

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


