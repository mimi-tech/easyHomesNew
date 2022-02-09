

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_location.dart';

import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:easy_homes/utils/searchbar.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class EasyOffLineVendors extends StatefulWidget {
  @override
  _EasyOffLineVendorsState createState() => _EasyOffLineVendorsState();
}

class _EasyOffLineVendorsState extends State<EasyOffLineVendors> {
  Widget space() {
    return SizedBox(height: 10.h);
  }
  static  List<dynamic> onlineVendors = <dynamic> [];
  String? filter;
  List<DocumentSnapshot> _documents = <DocumentSnapshot> [];
  // var tempSearchStore = [];
  StreamSubscription? _stream;

  bool progress = false;
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool prog = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnline();
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
    _stream!.cancel();

  }

  Widget bodyList(int index){
    return   GestureDetector(
      onTap: (){
        getDetails(index);
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kCardRadius),
            topRight: Radius.circular(kCardRadius),
          ),),
        color: kWhiteColor,
        elevation: kCardElevation,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width:imageRightShift.w),
                ImageScreen(image: onlineVendors[index]['pix'],),
                SizedBox(width:imageRightShift.w),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      name: '${onlineVendors[index]['fn']} ${onlineVendors[index]['ln']}',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),

                    TextWidget(
                      name: onlineVendors[index]['biz'].toString().toUpperCase(),
                      textColor: kRadioColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),
                    space(),
                    GestureDetector(
                      onTap: () async {
                        var url =
                            "tel:${onlineVendors[index]['ph']}";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: TextWidget(
                        name: onlineVendors[index]['ph'],
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),


              ],
            ),


          ],
        ),
      ),
    );


  }


  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Container(

          height: MediaQuery.of(context).size.height * kModalHeight,
          child: onlineVendors.length == 0?

          NoWorkError(title: '$kOlError ')
              : SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  StickyHeader(
                      header:SearchBar(title: kOl4,),


                      content:Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: onlineVendors.length,
                              itemBuilder: (context, int index) {
                                return filter == null || filter == "" ?bodyList(index):
                                '${onlineVendors[index]['fn']}'.toLowerCase()
                                    .contains(filter!.toLowerCase())

                                    ?bodyList(index):Container();
                              }),

                          prog == true || _loadMoreProgress == true
                              || onlineVendors.length < 1
                              ?Text(''):
                          moreData == true? PlatformCircularProgressIndicator():GestureDetector(
                              onTap: (){loadMore();},
                              child: SvgPicture.asset('assets/imagesFolder/load_more.svg',)  )
                        ],
                      )
                  )
                ],
              )
          ),
        )

    );


  }

  void getOnline() {

    // setState(() {
    //   PageConstants.onlineColor = true;
    //   onlineVendors.clear();
    //   onlineVendors = PageConstants.vendorCount.where((element) => element['ol'] == false).toList();
    //
    // });


    try{
      _stream = FirebaseFirestore.instance.collectionGroup('companyVendors')
          .where('appr', isEqualTo: true)
          .where('ol',isEqualTo: false)
          .orderBy('ts',descending: true).limit(VariablesOne.limit)
          .snapshots().listen((result) {
        final List < DocumentSnapshot > documents = result.docs;

        if (documents.length != 0) {
          onlineVendors.clear();
          for (DocumentSnapshot document in documents) {

            _lastDocument = documents.last;
            setState(() {
              onlineVendors.add(document.data());
              _documents.add(document);

            });
          }
        }else{

          setState(() {
            progress = true;
          });
        }
      });


    }catch(e){
      VariablesOne.notifyFlutterToastError(title: kError);
    }

  }

  Future<void> loadMore() async {
    try {
      _stream = FirebaseFirestore.instance.collectionGroup('companyVendors')
          .where('appr', isEqualTo: true)
          .where('ol', isEqualTo: false)
          .orderBy('ts', descending: true).
      startAfterDocument(_lastDocument).limit(VariablesOne.limit)

          .snapshots().listen((event) {
        final List <DocumentSnapshot> documents = event.docs;
        if (documents.length == 0) {
          setState(() {
            _loadMoreProgress = true;
          });
        } else {
          for (DocumentSnapshot document in documents) {
            _lastDocument = documents.last;

            setState(() {
              moreData = true;
              _documents.add(document);
              onlineVendors.add(document.data());

              moreData = false;
            });
          }
        }
      });
    } catch (e) {
      VariablesOne.notifyFlutterToastError(title: kError);
    }
  }




  void getDetails(int index) {


    setState(() {
      PageConstants.getVendorCount.clear();
      PageConstants.getVendor.clear();

      PageConstants.getVendor = PageConstants.vendorCount.where((element) => element['vId'] == onlineVendors[index]['vId']).toList();

      PageConstants.getVendorCount = PageConstants.allVendorCount.where((element) => element['vid'] == onlineVendors[index]['vId']).toList();


    });




    Navigator.push(context,
        PageTransition(
            type: PageTransitionType
                .scale,
            alignment: Alignment
                .bottomCenter,
            child: VendorLocationOnMap()));


  }
}
