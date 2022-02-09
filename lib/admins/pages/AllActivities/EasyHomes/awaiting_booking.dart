import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/comment_modal.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/rating_construct.dart';

import 'package:easy_homes/admins/pages/activity.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/admins/transactions/paymentList.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';


class EasyAwaitingBooking extends StatefulWidget {
  @override
  _EasyAwaitingBookingState createState() => _EasyAwaitingBookingState();
}

class _EasyAwaitingBookingState extends State<EasyAwaitingBooking> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  String? filter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stream.cancel();
  }
   var _documents = <DocumentSnapshot>[];
 late StreamSubscription stream;
  var itemsData = <dynamic>[];

  var vendorData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.08);
  }

  Widget bodyList(int index){
    return  Card(
      child: Column(

        children: <Widget>[
          space(),

          RatingConstruct(
            fn: itemsData[index]['fn'],
            ln: itemsData[index]['ln'],
            ph: itemsData[index]['ph'],
            image: itemsData[index]['pix'],
            date: "${itemsData[index]['dt']} \n ${itemsData[index]['add']}",
          ),


          space(),



        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    //PageConstants.allVendorCount.clear();
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: PageAddVendor(
          block: kWhiteColor,
          cancel: kWhiteColor,
          rating: kYellow,
          addVendor: kWhiteColor,
        ),

        appBar:SearchBottomAdminAppBar(title: 'Awaiting Bookings'.toUpperCase(),),

        body: CustomScrollView(
          slivers: <Widget>[
            SilverAppBarComments(
          block: kBlackColor,
          editPin: kBlackColor,
          remove: kBlackColor,
          suspend: kYellow,

        ),

        SliverList(
            delegate: SliverChildListDelegate([

              itemsData.length == 0 && progress == false
                  ? Center(child: PlatformCircularProgressIndicator())
                  : itemsData.length == 0 && progress == true
                  ? ErrorTitle(errorTitle: kNoAwaiting.toString(),)
                  : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _documents.length,
                  itemBuilder: (context, int index) {


                    return filter == null || filter == "" ?bodyList(index):
                    '${itemsData[index]['fn']}'.toLowerCase()
                        .contains(filter!.toLowerCase())

                        ?bodyList(index):Container();



                  }),
              progress == true ||
                  _loadMoreProgress == true ||
                  _documents.length < Variables.limit
                  ? Text('')
                  : moreData == true
                  ? PlatformCircularProgressIndicator()
                  : GestureDetector(
                  onTap: () {
                    loadMore();
                  },
                  child: SvgPicture.asset(
                    'assets/imagesFolder/load_more.svg',
                  ))
            ])),
      ]),
    ));
  }

  Future<void> getComments() async {
    stream = FirebaseFirestore.instance
        .collection("awaitBooking")
        .where('mat',isEqualTo: false)
        .orderBy('ts', descending: true)
        .limit(Variables.limit)
        .snapshots().listen((result) async {

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
       for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;
        setState(() {
          itemsData.clear();
          _documents.clear();
          _documents.add(document);
          itemsData.add(document.data());
          //PageConstants.comments.add(document.data());
        });
      }
    }
  });}

  Future<void> loadMore() async {
    stream = FirebaseFirestore.instance

        .collection("awaitBooking")
        .where('mat',isEqualTo: false)

        .orderBy('ts', descending: true)
        .startAfterDocument(_lastDocument)
        .limit(Variables.limit)
        .snapshots().listen((result) async {
          final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        setState(() {
          _loadMoreProgress = true;
        });
      } else {
         for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        _lastDocument = documents.last;

          setState(() {
            moreData = true;
            _documents.add(document);
            itemsData.add(document.data());
            //PageConstants.comments.add(document.data());
            moreData = false;
          });
        }
      }
    });
  }



}
