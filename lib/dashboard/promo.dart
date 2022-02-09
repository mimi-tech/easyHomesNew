import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/cancel_construct.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';



class PromoScreen extends StatefulWidget {
  @override
  _PromoScreenState createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];
  bool moreData = false;
  var _lastDocument;
  bool _loadMoreProgress = false;

  String? filter;


  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }
  bool progress = false;

  Widget bodyList(int index){
    return Card(
      elevation: 3,
      child: Column(

        children: <Widget>[
          //space(),
          PromoConstruct(
            fn: itemsData[index]['fn'],
            ln: itemsData[index]['ln'],
            verify: '${DateFormat('h:mm a').format(DateTime.parse(itemsData[index]['tm']))}',
            date: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(itemsData[index]['tm']))}:',
            image: itemsData[index]['pix'],

            // verify: (){unblockVendor(index);},
            // delete: (){
            //   removeVendor(index);
            // },
          ),

         // space()



        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDailyBooking();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: PromoAppBar(title: kReferialEarnings,),
        body: SingleChildScrollView(
          child: Column(

          children: <Widget>[
            spacer(),
            WalletBox(title: 'Promo Balance',amount: '${VariablesOne.numberFormat.format(Variables.currentUser[0]['refact']).toString()}',),
          spacer(),
            //DailyRowSecond(),
            itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
            itemsData.length == 0 && progress == true ?  TextWidget(
              name: 'No promotional earning details'.toString(),
              textColor: kRadioColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,):

            ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _documents.length,
                itemBuilder: (context, int index) {
                  return filter == null || filter == "" ?bodyList(index):
                  '${itemsData[index]['fn']}'.toLowerCase()
                      .contains(filter!.toLowerCase())

                      ?bodyList(index):Container();
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
        ),

    )
    );

  }

  Future<void> getDailyBooking() async {

    final QuerySnapshot result = await  FirebaseFirestore.instance.collection
("promotion").where(
        'ud', isEqualTo: Variables.userUid)
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

    final QuerySnapshot result = await  FirebaseFirestore.instance.collection
("promotion").where(
        'ud', isEqualTo: Variables.userUid)
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

