import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/biz_bottombar.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/verify_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Activity/biz_admin_log.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';


import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/admins/pages/tabs/admin_log_tab_second.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';

import 'package:easy_homes/reg/constants/variables.dart';

import 'package:easy_homes/admins/constructors/logs_construct.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/read_more.dart';
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
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';


class StationSales extends StatefulWidget {
  @override
  _StationSalesState createState() => _StationSalesState();
}

class _StationSalesState extends State<StationSales> {
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
    return   
            Card(
              elevation: kEle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextWidget(
                      name: '${PageConstants.sectaries[index]['fn']} ${PageConstants.sectaries[index]['ln']}'.toUpperCase(),
                      textColor: kLightBrown,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                  ),

                  Divider(),
                  Row(
                    children: <Widget>[
                      SizedBox(width: imageRightShift.w,),

                      VendorPix(pix:PageConstants.sectaries[index]['pix'] ,pixColor: Colors.transparent,),

                      SizedBox(width: imageRightShift.w,),


                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ReadMoreTextConstruct(title: PageConstants.sectaries[index]['sad'], colorText: kRadioColor),


                          TextWidget(
                            name: PageConstants.sectaries[index]['biz'].toUpperCase(),
                            textColor: kRadioColor,
                            textSize: kFontSize14,
                            textWeight: FontWeight.w500,
                          ),
                          Row(
                            children: [
                              TextWidget(
                                name: 'Sales count'.toUpperCase(),
                                textColor: kTextColor,
                                textSize: kFontSize14,
                                textWeight: FontWeight.w500,
                              ),
                              SizedBox(width: 10,),
                              TextWidget(
                                name: '${PageConstants.sectaries[index]['co']}'.toUpperCase(),
                                textColor: kYellow,
                                textSize: kFontSize,
                                textWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          space(),
                          GestureDetector(
                            onTap: () async {
                              var url =
                                  "tel:${PageConstants.sectaries[index]['ph']}";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: TextWidget(
                              name: PageConstants.sectaries[index]['ph'],
                              textColor: kLighterBlue,
                              textSize: kFontSize,
                              textWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),

                      PageConstants.sectaries[index]['ol'] == true?Icon(Icons.circle,color: kGreenColor,):Icon(Icons.circle,color: kRadioColor,),

                    ],
                  ),



                  Divider(),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),

                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(kLightBrown)

                        ),

                        onPressed:(){
                          removeSales(index);},
                        child:TextWidget(
                          name:'Remove',
                          textColor: kWhiteColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            );
        }
        
    
  


  @override
  Widget build(BuildContext context) {
    Iterable<dynamic> online =  PageConstants.sectaries.where((element) => element['ol'] == true);
    Iterable<dynamic> offline =  PageConstants.sectaries.where((element) => element['ol'] == false);

    return SafeArea(
        child: Scaffold(
            backgroundColor: kWhiteColor,
            bottomNavigationBar: BizBottomBar(
              block: kWhiteColor,
              cancel: kWhiteColor,
              addVendor: kWhiteColor,
              rating: kWhiteColor,
            ),
            appBar: EasyAppBarSecond(),
            body: ModalProgressHUD(
                inAsyncCall: _publishModal,
                child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor: kWhiteColor,
                        pinned: false,
                        automaticallyImplyLeading: false,
                        floating: true,
                        bottom: PreferredSize(
                            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverAppHeight2),
                            child: Text('')
                        ),

                        flexibleSpace: Column(
                          children: <Widget>[
                            space(),

                            BusinessActivityPage(
                              azTextColor: kTextColor,activityTextColor: kTextColor,logTextColor: kWhiteColor,
                              azColor:kDividerColor,activityColor:kDividerColor,logColor: kBlackColor,),
                            space(),


                            AdminLogTabThird(

                              salesName: 'Sales',
                              online: online.length.toString(),
                              offline: offline.length.toString(),
                              title: 'Sales - ${PageConstants.sectaries.length}'.toString(),),
                          ],
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildListDelegate([

                          PageConstants.sectaries.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
                          PageConstants.sectaries.length == 0 && progress == true ?
                          ErrorTitle(errorTitle:'No Sales yet') :

                          ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: PageConstants.sectaries.length,
                              itemBuilder: (context, int index) {
                                return filter == null || filter == "" ?bodyList(index):
                                '${ PageConstants.sectaries[index]['fn']}'.toLowerCase()
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
.collection('userReg')
        .where('sa',isEqualTo: true)
        .where('ca', isEqualTo: PageConstants.companyUD)

        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        setState(() {

          PageConstants.sectaries.add(document.data());
          // PageConstants.getCompanies.clear();


        });
      }
    }
  }

  void removeSales(int index) {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
          title: TextWidget(
            name: kRemoveSales.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
          content:  BizVerifyConstruct(text1:kRemoveAdminText,
            text2: '${PageConstants.sectaries[0]['fn'].toString().toUpperCase()} ${PageConstants.sectaries[0]['ln'].toString().toUpperCase()}',
            text3: kRemoveAdminText3,),

          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),


            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Yes'),
              onPressed: () {
                removeBiz(index);
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidget(
              name:  kRemoveSales.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[

            BizVerifyConstruct(text1:kRemoveAdminText,
              text2: '${PageConstants.sectaries[0]['fn'].toString().toUpperCase()} ${PageConstants.sectaries[0]['ln'].toString().toUpperCase()}',
              text3: kRemoveAdminText3,),
            space(),


            YesNoBtn(no: (){Navigator.pop(context);},yes: (){removeBiz(index);},)

          ],
        ));

  }

  Future<void> removeBiz(int index) async {

    await FirebaseFirestore.instance.collection
('userReg').doc(PageConstants.sectaries[index]['ud'])
        .update({'sa': FieldValue.delete(),
      'sac': FieldValue.delete(),
      'sad': FieldValue.delete(),
      'ca': FieldValue.delete(),
      'co':FieldValue.delete(),
      'cbi':FieldValue.delete(),
    });


  }
 
}
