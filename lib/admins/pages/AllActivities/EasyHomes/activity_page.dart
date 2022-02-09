import 'dart:async';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/admins/pages/tabs/count_tab.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/pages/activity.dart';
import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';

import 'package:easy_homes/admins/constructors/qty.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:intl/intl.dart';


class VendorActivitiesPage extends StatefulWidget {
  @override
  _VendorActivitiesPageState createState() => _VendorActivitiesPageState();
}

class _VendorActivitiesPageState extends State<VendorActivitiesPage> {

  dynamic sum = 0;
  var amount = <dynamic>[];

   var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    amount.clear();
    return  SafeArea(
            child: Scaffold(
              backgroundColor: kWhiteColor,
                bottomNavigationBar: TotalAmount(
                  day: '$kToday ',
                  name: sum <= 0 ? '0' : '#${sum.toString()}',
                ),
                appBar: MainAdminAppBar(title:  AdminConstants.bizName!.toUpperCase(),),
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: kWhiteColor,
                      pinned: false,
                      //automaticallyImplyLeading: false,
                      floating: true,

                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverHeight),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                           ActivityPage(azTextColor: kTextColor,activityTextColor: kWhiteColor,logTextColor: kTextColor,
                          azColor:kDividerColor,activityColor: kBlackColor,logColor:kDividerColor,),


                            CompaniesTabs(),
                            space(),
                            space(),
                            CountTab(
      counting: PageConstants.vendorNumber.toString(),
                              analysisColor: kDoneColor,
                              currentColor: kLightBrown,
                              cardColorToday: kLightBrown,
                              cardColorWeek: kHintColor,
                              cardColorMonth: kHintColor,
                              cardColorYear: kHintColor,
                            ),
                          ],
                        ),
                      ),

                    ),

                SliverAppBar(
                  backgroundColor: kWhiteColor,
                  pinned: true,
                  //automaticallyImplyLeading: false,
                  //floating: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverHeight2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        CountingTab(),
                        space(),
                       space(),
                      ],
                    ),
                  ),

                ),

                SliverList(
                delegate: SliverChildListDelegate([

           /* Column(
              children: <Widget>[

                itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                itemsData.length == 0 && progress == true ? ErrorTitle(errorTitle:kNoVendor):
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _documents.length,
                    itemBuilder: (context, int index) {


                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),

                        child: Column(

                          children: <Widget>[

                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: <Widget>[
                                  DateBookings(date:'${DateFormat('EE ,d MMM, yyyy').format(DateTime.parse(itemsData[index]['dt']))}',

                                      time:'${DateFormat('h:mm:a').format(DateTime.parse(itemsData[index]['dt']))}'
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



                                  AdminAmount( amount: itemsData[index]['p3'],)
                            ]
                        ),



                            Divider(),

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
            )*/
    ]
                )
            )
                ]
                )
            )
                          );
                        
                  
                
            
  }



 

  Future<void> getData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily").where('day', isEqualTo: DateTime
        .now().day).where('mth', isEqualTo: DateTime
        .now().month).where('yr', isEqualTo: DateTime
        .now().year).orderBy('tm', descending: true).limit(Variables.limit)
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

          amount.add(data[
'amt']);
          sum += data['amt'];


        });



      }
    }
  }

  Future<void> loadMore() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
.collection("vendorDaily").where('day', isEqualTo: DateTime
        .now().day).where('mth', isEqualTo: DateTime
        .now().month).where('yr', isEqualTo: DateTime
        .now().year).orderBy('tm', descending: true).
        startAfterDocument(_lastDocument).limit(Variables.limit)

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
          amount.add(data[
'amt']);

          sum += data['amt'];

          moreData = false;


        });
      }
    }
  }

}
