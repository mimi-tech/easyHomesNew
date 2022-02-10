
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/logs_construct.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_admin_log_second.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_sec.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';


import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/remove_vendor.dart';

import 'package:easy_homes/admins/pages/tabs/admin_log_tab.dart';

import 'package:easy_homes/admins/pages/vendor_logs.dart';
import 'package:easy_homes/admins/pages/showVendorDetails.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';

import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerComAdminLogs extends StatefulWidget {
  @override
  _PartnerComAdminLogsState createState() => _PartnerComAdminLogsState();
}

class _PartnerComAdminLogsState extends State<PartnerComAdminLogs> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  String? filter;
  var itemsData = <dynamic>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanyVendors();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }
  late Iterable<dynamic> login;
  late Iterable<dynamic> logout;
  bool _publishModal = false;
  bodyList(index){
    return GestureDetector(
      onTap: (){

        setState(() {
          PageConstants.vendorID = itemsData[index]['vId'];

        });
        showModalBottomSheet(

            isScrollControlled: true,
            context: context,
            builder: (context) => VendorLogs()
        );

      },
      child: Column(
        children: <Widget>[

          AdminLogsConstruct(
            image: itemsData[index]['pix'],
            fn: itemsData[index]['fn'],
            ln: itemsData[index]['ln'],
            ph: itemsData[index]['ph'],
            biz: itemsData[index]['biz'],
            cancelColor: false,
            delete: (){
              getVendor(index);
            },

            call: () async {

              var url =
                  "tel:${itemsData[index]['ph']}";
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
                color:itemsData[index]['ol'] == true?kLightGreen:kWhiteColor,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.my_location),
                    SizedBox(height: 10,),
                    itemsData[index]['ol'] == true?SvgPicture.asset('assets/imagesFolder/green_dot.svg',)
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
        bottomNavigationBar: PageAddVendor(
          block: kWhiteColor,
          cancel: kWhiteColor,
          addVendor: kWhiteColor,
          rating: kWhiteColor,
        ),
        appBar: SearchEasyAppBar(),
        body: ProgressHUDFunction(
          inAsyncCall: _publishModal,
          child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                    backgroundColor: kWhiteColor,
                    pinned: false,
                    automaticallyImplyLeading: false,
                    floating: true,
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverAppHeight),
                        child: Text('')
                    ),

                  flexibleSpace: Column(
                    children: <Widget>[
                      space(),

                      PartnerCompanyActivityTab(
                        azTextColor: kTextColor,activityTextColor: kTextColor,logTextColor: kWhiteColor,
                        azColor:kDividerColor,activityColor:kDividerColor,logColor: kBlackColor,),
                      space(),
                      PartnerCompaniesTabs(),

                      PartnerLogTabCompany(
                        venColor: kLightBrown,
                        secColor: kHintColor,
                        salesColor: kHintColor,
                        offline: logout.length.toString(),
                        online:  login.length.toString(),
                        title: '${PageConstants.companyName} vendors - ${itemsData.length}'.toString(),),


                    ],
                  ),
                ),



                SliverList(
                    delegate: SliverChildListDelegate([

                      itemsData.length == 0?
                      ErrorTitle(errorTitle: kVendorNotWork,)
                          : ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: itemsData.length,
                          itemBuilder: (context, int index) {
                            return   filter == null || filter == "" ?bodyList(index):
                            '${ itemsData[index]['biz']}'.toLowerCase()
                                .contains(filter!.toLowerCase())

                                ?bodyList(index):Container();





                          }
                      )
                    ]
                    )

                ),
              ]
          ),
        ),
      ),
    );
  }




  void getCompanyVendors() {

    setState(() {
      itemsData = PageConstants.vendorCount.where((element) => element['cbi'] == PageConstants.companyUD).toList();
      login = itemsData.where((element) => element['cbi'] == PageConstants.companyUD  &&
          element['ol'] == true).toList();

      logout = itemsData.where((element) => element['cbi'] == PageConstants.companyUD  &&
          element['ol'] == false).toList();

    });

  }
  void showVendorDetails(int index) {
    setState(() {
      PageConstants.getWorkingForAllVendor.clear();
      PageConstants.getWorkingForAllVendor = PageConstants.allVendorCount.where((element) => element['vid'] == itemsData[index]['vId']).toList();

      PageConstants.getVendor.clear();
      PageConstants.getVendor.add(itemsData[index]);

    });

    Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft,
            child: ShowVendorDetails()));

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

  Future<void> _suspend(int index) async {
    Navigator.pop(context);
    setState(() {
      _publishModal = true;
    });
    try {
      await FirebaseFirestore.instance.collection('vendor').doc(
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
