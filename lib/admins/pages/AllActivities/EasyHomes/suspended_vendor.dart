import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/admit_vendor.dart';
import 'package:easy_homes/admins/constructors/cancel_construct.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_vendors.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/blocked_users.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/verify_biz_owner.dart';


import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';


import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';



class EasySuspendedVendor extends StatefulWidget {
  @override
  _EasySuspendedVendorState createState() => _EasySuspendedVendorState();
}

class _EasySuspendedVendorState extends State<EasySuspendedVendor> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

   var _documents = <DocumentSnapshot>[];

  var itemsData = <dynamic>[];

  var vendorData = <dynamic>[];
  bool _loadMoreProgress = false;
  bool moreData = false;
  var _lastDocument;
  bool progress = false;
  bool _publishModal = false;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.08);
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


  Widget bodyList(int index){
    return Card(
      elevation: 3,
      child: Column(

        children: <Widget>[
          space(),
          RemoveVendorConstruct(
            fn: itemsData[index]['fn'],
            ln: itemsData[index]['ln'],
            ph: itemsData[index]['ph'],
            date: '${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(itemsData[index]['red']))}:'
                '${DateFormat('h:mm a').format(DateTime.parse(itemsData[index]['red']))}',
            image: itemsData[index]['pix'],

            verify: (){unblockVendor(index);},
            delete: (){
              removeVendor(index);
            },
          ),

          space()



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
              cancel: kYellow,
              rating: kWhiteColor,
              addVendor: kWhiteColor,
            ),
            appBar:CancelAppBar(

              title: 'Suspended vendors'.toUpperCase(),),
            body: ProgressHUDFunction(
              inAsyncCall: _publishModal,
              color: kDoneColor,
              child: CustomScrollView(
                  slivers: <Widget>[
                    SilverAppBarCancel(
                      block: kBlackColor,
                      editPin: kBlackColor,
                      remove: kBlackColor,
                      suspend: kLightBrown,

                    ),

                    SliverList(
                        delegate: SliverChildListDelegate([

                          space(),
                          itemsData.length == 0 && progress == false
                              ? Center(child: PlatformCircularProgressIndicator())
                              : itemsData.length == 0 && progress == true
                              ? ErrorTitle(errorTitle: kReSuspendError.toString(),)
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
                  ]
              ),
            )

        )

    );



  }

  Future<void> getComments() async {
    final QuerySnapshot result = await FirebaseFirestore.instance

        .collectionGroup("companyVendors").where('appr',isEqualTo: false).where('su',isEqualTo: true)
        .orderBy('red', descending: false)

        .limit(Variables.limit)
        .get();

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
          _documents.add(document);
          itemsData.add(document.data());
        });
      }
    }
  }

  Future<void> loadMore() async {


    final QuerySnapshot result = await FirebaseFirestore.instance

        .collectionGroup("companyVendors").where('appr',isEqualTo: false).where('su',isEqualTo: true)
        .orderBy('red', descending: false)
        .startAfterDocument(_lastDocument)
        .limit(Variables.limit)
        .get();
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

          moreData = false;
        });
      }
    }
  }

  Future<void> unblockVendor(int index) async {

    showDialog(
        context: context,
        builder: (context) =>  SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child:  TextWidget(
              name: 'vendor re-admission'.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),
          ),

          children: <Widget>[
            ReAdmitVendor(title:kRemText,date:'${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(itemsData[index]['red']))}: '
                '${DateFormat('h:mm a').format(DateTime.parse(itemsData[index]['red']))}',),
            SizedBox(height: 20.h),
            YesNoBtn(no: (){
              Navigator.pop(context);
            }, yes: (){
              unblockVendorNow(index);
            })
          ],
        ));



  }

  Future<void> unblockVendorNow(int index) async {
    //unblocking the vendor that was removed
    Navigator.pop(context);
    setState(() {
      _publishModal = true;
    });
    try{

      await FirebaseFirestore.instance.collection
('vendor').doc(
          itemsData[index]['cbi'])
          .collection('companyVendors').doc(
          itemsData[index]['vId'])
          .update({
        'appr':true,
        'su':false
      });
      setState(() {

        itemsData.removeAt(index);
        _documents.removeAt(index);
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kConfirm5,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }catch (e){
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }

  }

  void removeVendor(int index) {
    showDialog(
        context: context,
        builder: (context) =>  SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child:  TextWidget(
              name: 'Remove vendor'.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),
          ),

          children: <Widget>[
            ReAdmitVendor(title:kPermRev,date:'${DateFormat('EE, d MMM, yyyy').format(DateTime.parse(itemsData[index]['red']))}: '
                '${DateFormat('h:mm a').format(DateTime.parse(itemsData[index]['red']))}',),
            SizedBox(height: 20.h),
            YesNoBtn(no: (){
              Navigator.pop(context);
            }, yes: (){
              removePermanent(index);
            })
          ],
        ));



  }

  Future<void> removePermanent(int index) async {
    //unblocking the vendor that was removed
    Navigator.pop(context);
    setState(() {
      _publishModal = true;
    });
    try{

      await FirebaseFirestore.instance.collection
('vendor').doc(
          itemsData[index]['cbi'])
          .collection('companyVendors').doc(
          itemsData[index]['vId'])
          .delete();
      setState(() {

        itemsData.removeAt(index);
        _documents.removeAt(index);
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: 'Vendor deleted successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }catch (e){
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }

  }



}
