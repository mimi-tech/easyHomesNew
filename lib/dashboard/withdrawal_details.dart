

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dashboard/vendor/daily_row.dart';
import 'package:easy_homes/dashboard/vendor/trans_box.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/dash_appbar.dart';
import 'package:easy_homes/utils/dash_silver_appbar.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class WithdrawalDetails extends StatefulWidget {
  @override
  _WithdrawalDetailsState createState() => _WithdrawalDetailsState();
}

class _WithdrawalDetailsState extends State<WithdrawalDetails> {
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
        //appBar: DashAppBar(title: 'All withdrawals'.toUpperCase(),),
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

            flexibleSpace:Center(child:  DailyRowSecond()),),
          SliverList(
              delegate: SliverChildListDelegate([

                Column(

                  children: <Widget>[
                    // TransactionBox(),


                    itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                    itemsData.length == 0 && progress == true ?TextWidget(
                      name: kNoHistory2,
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,):

                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _documents.length,
                        itemBuilder: (context, int index) {
                          return  Column(
                            children: [
                              Divider(),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextWidget(
                                      name:  DateFormat('d MMM, yyyy').format(DateTime.parse(itemsData[index]['ts'])),
                                      textColor: kRadioColor,
                                      textSize: kFontSize14,
                                      textWeight: FontWeight.w500,
                                    ),
                                    spacer(),
                                    Column(
                                      children: <Widget>[



                                        TextWidget(
                                          name: itemsData[index]['dp'].toString(),
                                          textColor: kRadioColor,
                                          textSize: kFontSize14,
                                          textWeight: FontWeight.w500,
                                        ),
                                        TextWidget(
                                          name: DateFormat('h:mm:a').format(DateTime.parse(itemsData[index]['ts'])),
                                          textColor: kTextColor,
                                          textSize: kFontSize14,
                                          textWeight: FontWeight.w500,
                                        ),






                                      ],
                                    ),
                                    spacer(),
                                    Column(
                                      children: <Widget>[

                                        MoneyFormatColors(
                                          color: itemsData[index]['dp'] == kDeposit ||
                                              itemsData[index]['dp'] == 'Delivery' ||
                                              itemsData[index]['dp'] == 'Gas order'||
                                              itemsData[index]['dp'] == 'referral'||
                                              itemsData[index]['dp'] == kPromos||
                                              itemsData[index]['dp'] == kTxnFailureAdd

                                              ?kSeaGreen:kDarkRedColor,
                                          title: TextWidget(
                                            name:itemsData[index]['amt'].toString(), /*itemsData[index]['amt'] == null?
                                  '${VariablesOne.numberFormat.format(0).toString()}'
                                      :'${VariablesOne.numberFormat.format(itemsData[index]['amt']).toString()}',*/
                                            textColor: itemsData[index]['dp'] == kDeposit ||
                                                itemsData[index]['dp'] == 'Delivery'||
                                                itemsData[index]['dp'] == 'Gas order'||
                                                itemsData[index]['dp'] == 'referral'||
                                                itemsData[index]['dp'] == kPromos||
                                                itemsData[index]['dp'] == kTxnFailureAdd

                                                ?kSeaGreen:kDarkRedColor,
                                            textSize: kFontSize14,
                                            textWeight: FontWeight.w500,
                                          ),
                                        ),


                                      ],
                                    ),


                                  ],
                                ),
                              ),
                            ],
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
        .collection("History").where('ud', isEqualTo: Variables.userUid)
        .where('dp', isEqualTo: kWith)

        .orderBy('ts',descending: true).limit(Variables.limit)
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
        .collection("History").where(
        'ud', isEqualTo: Variables.userUid)
        .where('dp', isEqualTo: kWith)
        .orderBy('ts',descending: true).startAfterDocument(_lastDocument).limit(Variables.limit)
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

