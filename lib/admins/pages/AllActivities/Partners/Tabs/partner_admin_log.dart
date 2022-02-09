import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/logs_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Activities/partner_vendor_logs.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_activity_tabs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_admin_tabs.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_sec_log.dart';

import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/remove_vendor.dart';
import 'package:easy_homes/admins/pages/showVendorDetails.dart';
import 'package:easy_homes/admins/pages/tabs/admin_log_tab.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerAdminLogs extends StatefulWidget {
  @override
  _PartnerAdminLogsState createState() => _PartnerAdminLogsState();
}

class _PartnerAdminLogsState extends State<PartnerAdminLogs> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  bool _publishModal = false;

  String? filter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }

  Widget bodyList(int index){
    return GestureDetector(
      onTap: (){

        setState(() {
          PageConstants.vendorID = PageConstants.vendorCount[index]['vId'];

        });
        Navigator.push(context,
            PageTransition(type: PageTransitionType.rightToLeft,
                child: PartnerVendorLogs()));

      },
      child: Column(
        children: <Widget>[

          AdminLogsConstruct(
            image: PageConstants.vendorCount[index]['pix'],
            fn: PageConstants.vendorCount[index]['fn'],
            ln: PageConstants.vendorCount[index]['ln'],
            ph: PageConstants.vendorCount[index]['ph'],
            biz: PageConstants.vendorCount[index]['biz'],

            cancelColor: true,
            delete: (){
              getVendor(index);
            },

            call: () async {

              var url =
                  "tel:${PageConstants.vendorCount[index]['ph']}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }

            },

            online:  GestureDetector(
              onTap: (){

                showVendorDetails(index);


              },
              child: Container(
                height: kContainerHeight.h,
                width: kContainerWidth.w,
                color:PageConstants.vendorCount[index]['ol'] == true?kLightGreen:kWhiteColor,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.my_location),
                    SizedBox(height: 10,),
                    PageConstants.vendorCount[index]['ol'] == true?SvgPicture.asset('assets/imagesFolder/green_dot.svg',)
                        : SvgPicture.asset('assets/imagesFolder/grey_dot.svg',)   ,

                  ],
                ),
              ),
            ),
          ),






          Divider(),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        bottomNavigationBar: PageAddVendor(
          block: kWhiteColor,
          cancel: kWhiteColor,
          addVendor: kWhiteColor,
          rating: kWhiteColor,
        ),
        appBar: SearchMainAdminAppBar(title:  AdminConstants.bizName!.toUpperCase(),),

        body:ModalProgressHUD(
          inAsyncCall: _publishModal,
          child: CustomScrollView(
            slivers: <Widget>[
            SliverAppBar(
            backgroundColor: kWhiteColor,
            pinned: false,
            automaticallyImplyLeading: false,
            floating: true,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.42),
                child: Column(
                        children: <Widget>[
                          PartnerActivityPage(
                            azTextColor: kTextColor,activityTextColor: kTextColor,logTextColor: kWhiteColor,
                            azColor:kDividerColor,activityColor:kDividerColor,logColor: kBlackColor,),
                          space(),
                          PartnerCompaniesTabs(),

                          space(),
                          PartnerAdminLogTab(


                            venColor: kLightBrown,
                            secColor: kHintColor,
                            salesColor: kHintColor,
                            offline: PageConstants.getLogOutCount.length.toString(),
                            online: PageConstants.getLoginCount.length.toString(),
                            title: 'All Vendors - ${PageConstants.vendorCount.length}'.toString(),),
                        ],
                      ),
            )
          ),


            SliverList(
                delegate: SliverChildListDelegate([

                      PageConstants.vendorCount.length == 0?
                      ErrorTitle(errorTitle:kNoVendor)
                          : ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: PageConstants.vendorCount.length,
                          itemBuilder: (context, int index) {
                            return filter == null || filter == "" ?bodyList(index):
                            '${ PageConstants.vendorCount[index]['biz']}'.toLowerCase()
                                .contains(filter!.toLowerCase())

                                ?bodyList(index):Container();


                          }
                      )

]
            ),
          ),
          ]
      ),
        ),
      )
    );
  }

  void getVendor(int index) {


    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(

          content:DeleteVendor(suspended: (){_suspend(index);}, confirm:(){deleteVendor(index);},name: '${PageConstants.vendorCount[index]['fn']}'
              ' ${PageConstants.vendorCount[index]['ln']} - $klog2}',),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kDone),
              onPressed: () {
                deleteVendor(index);
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(kCancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,

          children: <Widget>[
            DeleteVendor(suspended: (){_suspend(index);},  confirm:(){deleteVendor(index);},name: '${PageConstants.vendorCount[index]['fn']}'
                ' ${PageConstants.vendorCount[index]['ln']} - $klog2',),

          ],
        ));
  }

  Future<void> deleteVendor(int index) async {
    Navigator.pop(context);
    setState(() {
      _publishModal = true;
    });
    try {
      await FirebaseFirestore.instance.collection
('vendor').doc(
          PageConstants.vendorCount[index]['cbi'])
          .collection('companyVendors').doc(
          PageConstants.vendorCount[index]['vId'])
          .set({
        'appr':false,
        're':true,
        'red':DateTime.now().toString(),
      },SetOptions(merge: true));

      setState(() {
        //remove vendor at index
        PageConstants.vendorCount.removeAt(index);
        //minus vendor count
        PageConstants.vendorNumber--;
        _publishModal = false;
      });

      Fluttertoast.showToast(
          msg: kConfirm3,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }catch(e){
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


  void showVendorDetails(int index) {
    setState(() {
      PageConstants.getWorkingForAllVendor.clear();
      PageConstants.getWorkingForAllVendor = PageConstants.allVendorCount.where((element) => element['vid'] == PageConstants.vendorCount[index]['vId']).toList();

      PageConstants.getVendor.clear();
      PageConstants.getVendor.add(PageConstants.vendorCount[index]);

    });
    Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft,
            child: ShowVendorDetails()));


  }

  Future<void> _suspend(int index) async {
    Navigator.pop(context);
    setState(() {
      _publishModal = true;
    });
    try {
      await FirebaseFirestore.instance.collection
('vendor').doc(
          PageConstants.vendorCount[index]['cbi'])
          .collection('companyVendors').doc(
          PageConstants.vendorCount[index]['vId'])
          .set({
        'appr':false,
        'su':true,
        'red':DateTime.now().toString(),
      },SetOptions(merge: true));

      setState(() {
        //remove vendor at index
        PageConstants.vendorCount.removeAt(index);
        //minus vendor count
        PageConstants.vendorNumber--;
        _publishModal = false;
      });

      Fluttertoast.showToast(
          msg: kConfirm4,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kGreenColor);
    }catch(e){
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
