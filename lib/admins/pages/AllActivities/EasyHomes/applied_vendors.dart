import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/search.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/applied_vendor_details.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/admins/pages/verify_vendor.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';


import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';

class AppliedVendors extends StatefulWidget {
  @override
  _AppliedVendorsState createState() => _AppliedVendorsState();
}

class _AppliedVendorsState extends State<AppliedVendors> {


  bool progress = false;
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  bool moreData = false;
  var itemsData = <dynamic>[];

   var _documents = <DocumentSnapshot>[];

  Icon actionIcon =  Icon(Icons.search,color: kRadioColor,size: 25,);
bool checkSearch = true;
  TextEditingController searchController = TextEditingController();
  String? filter;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppliedVendor();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  Widget bodyList(int index){
  return RefreshIndicator(
    child: ListView(
      shrinkWrap: true,
      children: <Widget>[

        GestureDetector(
          onTap: () async {
            setState(() {
              AdminConstants.vendorDetails.clear();
              AdminConstants.vendorDetails.add(itemsData[index]);
            });
            final value = await Navigator.of(context).push(

              MaterialPageRoute(
                builder: (context) =>
                    AppliedVendorDetails(),
              ),
            );

            if (value != null && value == 'Done') {

              getAppliedVendor();

            }

          },
          child: Row(
            children: <Widget>[
              SizedBox(width:imageRightShift.w),

              VendorPix(pix:itemsData[index]['pix'] ,pixColor: Colors.transparent,),
              SizedBox(width:imageRightShift.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    name: '${itemsData[index]['fn']} ${itemsData[index]['ln']}',
                    textColor: kLightBrown,
                    textSize: kFontSize,
                    textWeight: FontWeight.w600,
                  ),

                  TextWidget(
                    name: itemsData[index]['date'],
                    textColor: kTextColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),


                  TextWidget(
                    name: itemsData[index]['biz'],
                    textColor: kDoneColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),
                  Container(

                    child: ConstrainedBox(

                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setWidth(250),
                        minHeight: ScreenUtil()
                            .setHeight(kConstrainedHeight),
                      ),
                      child: ReadMoreText(itemsData[index]['str'],

                          trimLines: 1,
                          colorClickableText:kRedColor,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' ...',
                          trimExpandedText: ' \n show less...',
                          style: GoogleFonts.oxanium(
                              textStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(kFontSize14, ),
                                color: kTextColor,
                                fontWeight:FontWeight.bold,
                              )
                          )
                      ),
                    ),
                  ),


                ],
              )

            ],
          ),
        ),
        Divider(),

      ],
    ),
    onRefresh: _getData,
  );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: PageAddVendor(
              block: kWhiteColor,
              cancel: kWhiteColor,
              addVendor: kYellow,
              rating: kWhiteColor,
            ),
            appBar: AppBar(
              iconTheme: IconThemeData(color: kBlackColor, size: 20.0),
              backgroundColor: kWhiteColor,
              title: checkSearch ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
              TextWidget(
              name: kAppliedVendor.toUpperCase(),
              // AdminConstants.bizName!.toUpperCase(),
              textColor: kDoneColor,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),
            AdminConstants.category == AdminConstants.admin.toLowerCase()
                ? Text('')
                : GestureDetector(
                onTap: () {

                  Platform.isIOS
                      ? showCupertinoModalPopup(

                      context: context, builder: (BuildContext context) {
                    return CupertinoActionSheet(
                      actions: <Widget>[
                        VerifyVendor()
                      ],
                    );
                  })
                      : showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => VerifyVendor());

                },
                child: SvgPicture.asset(
                  'assets/imagesFolder/add_new.svg',
                )),
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            checkSearch = false;
                          });
                        },
                        child: SearchIcon())
         ]
        ):

              Container(

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Expanded(
                      child: TextFormField(
                          controller: searchController,
                          style: Fonts.textSize,
                          autocorrect: true,
                          autofocus: true,
                             cursorColor: kBlackColor,
                          keyboardType: TextInputType.text,
                          decoration: Variables.searchInput),
                    ),

                    GestureDetector(
                        onTap: (){
                          setState(() {
                            checkSearch = true;
                          });
                        },
                        child: CancelIcon())
                  ],
                ),
              )

            ),
            body: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              space(),

              itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
              itemsData.length == 0 && progress == true ?Center(
                child: TextWidget(name: kNoAppliedVendor,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),
              ):


              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                    physics:  BouncingScrollPhysics(),
                    //shrinkWrap: true,
                    itemCount:itemsData.length,
                    itemBuilder: (BuildContext ctxt, int index) {

                      return filter == null || filter == "" ?bodyList(index):
                      '${ itemsData[index]['fn']}'.toLowerCase()
                          .contains(filter!.toLowerCase())

                          ?bodyList(index):Container();

                    }
                ),
              ),



            ])));
  }

  Future<void> _getData() async {

    setState(() {

      getAppliedVendor();
    });
  }


  Future<void> getAppliedVendor() async {
    itemsData.clear();
    /*get the applied vendor count*/
    final QuerySnapshot data = await FirebaseFirestore.instance
        .collectionGroup('companyVendors')
    // .where('cbi', isEqualTo: Variables.userUid)
        .where('appr', isEqualTo: false)
        .where('re', isEqualTo: false)
        .where('su', isEqualTo: false)
        .orderBy('ts', descending: true)

        .get();

    final List<DocumentSnapshot> vendorDoc = data.docs;
    if(vendorDoc.length == 0){
      setState(() {
        progress = true;
      });

    }else {
      for (DocumentSnapshot venList in vendorDoc) {

        setState(() {
          _documents.add(venList);
          itemsData.add(venList.data());
        });
      }
    }
  }

  static void verify(BuildContext context) {
    Platform.isIOS
        ? showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          VerifyVendor()
        ],
      );
    })
        : showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => VerifyVendor());
  }


}
