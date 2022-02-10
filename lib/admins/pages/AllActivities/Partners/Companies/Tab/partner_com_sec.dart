import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';

import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/EasyHomes/companyActivity/com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_admin_log_second.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_admin_logs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';
import 'package:easy_homes/admins/pages/activity.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/admins/pages/tabs/admin_log_tab_second.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';
import 'package:easy_homes/admins/constructors/logs_construct.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';


class PartnerCompanySec extends StatefulWidget {
  @override
  _PartnerCompanySecState createState() => _PartnerCompanySecState();
}

class _PartnerCompanySecState extends State<PartnerCompanySec> {
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }


  bool progress = false;
  bool _publishModal = false;

  String? filter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdmins();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }



  Widget bodyList(index){
    return  Column(
      children: <Widget>[



        SectaryLogs(image: PageConstants.sectaries[index]['pix'],
            fn: PageConstants.sectaries[index]['fn'],
            ln: PageConstants.sectaries[index]['ln'],
            ph: PageConstants.sectaries[index]['ph'],
            biz: PageConstants.sectaries[index]['biz'],
            show: false,
            delete: (){
              //deleteAdmin(index);
            },

            call: () async {

              var url =
                  "tel:${PageConstants.sectaries[index]['ph']}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }

            },
            online: PageConstants.sectaries[index]['ol'] == true?Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                /*Center(
                  child: TextWidgetAlign(
                    name:  PageConstants.sectaries[index]['lg'] ,
                    textColor: kGreenColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),*/
                SvgPicture.asset('assets/imagesFolder/green_dot.svg',)

              ],
            ):

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Center(
                  child: TextWidgetAlign(
                    name:  PageConstants.sectaries[index]['lo'] ,
                    textColor: kRadioColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset('assets/imagesFolder/grey_dot.svg',)

              ],
            )
        ),


        Divider(),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    Iterable<dynamic> online =  PageConstants.sectaries.where((element) => element['ol'] == true);
    Iterable<dynamic> offline =  PageConstants.sectaries.where((element) => element['ol'] == false);

    return SafeArea(
        child: Scaffold(
            backgroundColor: kWhiteColor,
            bottomNavigationBar: PageAddVendor(
              block: kWhiteColor,
              cancel: kWhiteColor,
              addVendor: kWhiteColor,
              rating: kWhiteColor,
            ),
            appBar:SearchEasyAppBar(),
            body: ProgressHUDFunction(
                inAsyncCall: _publishModal,
                child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                          backgroundColor: kWhiteColor,
                          pinned: false,
                          //automaticallyImplyLeading: false,
                          floating: true,
                          bottom: PreferredSize(
                              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.42),
                              child: Column(
                                children: <Widget>[
                                  PartnerCompanyActivityTab(
                                    azTextColor: kTextColor,activityTextColor: kTextColor,logTextColor: kWhiteColor,
                                    azColor:kDividerColor,activityColor:kDividerColor,logColor: kBlackColor,),
                                  space(),
                                  PartnerCompaniesTabs(),

                                  PartnerLogTabCompany(
                                    venColor: kHintColor,
                                    secColor: kLightBrown,
                                    salesColor: kHintColor,
                                    online: online.length.toString(),
                                    offline: offline.length.toString(),
                                    title: '${PageConstants.companyName} secetries - ${PageConstants.sectaries.length}'.toString(),),
                                ],
                              )
                          )
                      ),

                      SliverList(
                        delegate: SliverChildListDelegate([

                          PageConstants.sectaries.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                          PageConstants.sectaries.length == 0 && progress == true ?
                          ErrorTitle(errorTitle:'No Sectary yet for ${PageConstants.companyName}') :

                          ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: PageConstants.sectaries.length,
                              itemBuilder: (context, int index) {
                                return filter == null || filter == "" ?bodyList(index):
                                '${ PageConstants.sectaries[index]['biz']}'.toLowerCase()
                                    .contains(filter!.toLowerCase())

                                    ?bodyList(index):Container();

                              }
                          )

                        ]),
                      ),
                    ]))));
  }

  Future<void> getAdmins() async {
    PageConstants.sectaries.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance
.collection('userReg').
    where('ouid', isEqualTo: PageConstants.companyUD).
    where('cat', isEqualTo: AdminConstants.admin)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        setState(() {

          PageConstants.sectaries.add(document.data);
          // PageConstants.getCompanies.clear();


        });
      }
    }
  }



}
