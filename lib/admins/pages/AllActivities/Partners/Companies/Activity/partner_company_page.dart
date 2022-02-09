import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Companies/Tab/partner_com_count.dart';

import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_company_tabs.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_counting.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_location.dart';

import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
class PartnerCompanyDailyAnalysis extends StatefulWidget {
  @override
  _PartnerCompanyDailyAnalysisState createState() => _PartnerCompanyDailyAnalysisState();
}

class _PartnerCompanyDailyAnalysisState extends State<PartnerCompanyDailyAnalysis> {

  StreamController<List<DocumentSnapshot>> _streamController =
  StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool isLoading = false;

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else {
        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
           _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if (isChange) {
      _streamController.add(_products);
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance.collection
('vendorDaily')
        .where('gd', isEqualTo:  PageConstants.companyUD )
        .orderBy('dt',descending: false)
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    PageConstants.allVendorCount.clear();
    return
      NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
              requestNextPage();
            }
            return true;
          },
          child: SafeArea(child: Scaffold(
            backgroundColor: kWhiteColor,
              bottomNavigationBar: PageAddVendor(
                block: kYellow,
                cancel: kWhiteColor,
                addVendor: kWhiteColor,
                rating: kWhiteColor,
              ),
              appBar: EasyAppBarSecond(),
              body: WillPopScope(
                onWillPop: () => Future.value(false),
                child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(

                        backgroundColor: kWhiteColor,
                        pinned: false,
                        automaticallyImplyLeading: false,
                        floating: true,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * kSliverAppHeight),
                          child: Text(''),
                        ),
                        flexibleSpace: Column(
                          children: <Widget>[
                            PartnerCompanyActivityTab(
                              azTextColor: kWhiteColor,activityTextColor: kTextColor,logTextColor: kTextColor,
                              azColor: kBlackColor,activityColor:kDividerColor,logColor:kDividerColor,),
                            space(),
                            PartnerCompaniesTabs(),

                            PartnerCompanyCountingPage(),
                          ],
                        ),

                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([


                            StreamBuilder<List<DocumentSnapshot>>(
                                stream: _streamController.stream,
                                builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                                  if(snapshot.data == null){
                                    return   TextWidget(
                                      name: knoCompanyVendor,
                                      textColor: kTextColor,
                                      textSize: kFontSize,
                                      textWeight: FontWeight.w500,
                                    );
                                  } else {

                                    return Card(
                                      elevation: kEle,
                                      child: Column(
                                          children: snapshot.data!.map((doc) {
                                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                            PageConstants.allVendorCount.add(doc.data);

                                            return GestureDetector(
                                              onTap: (){getVendor(doc);},
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      SizedBox(width:imageRightShift.w),
                                                      ImageScreen(image: data['pi'],),
                                                      SizedBox(width:imageRightShift.w),


                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          TextWidget(
                                                            name: data['fn'],
                                                            textColor: kTextColor,
                                                            textSize: kFontSize,
                                                            textWeight: FontWeight.w500,
                                                          ),

                                                          TextWidget(
                                                            name: data['ln'].toString().toUpperCase(),
                                                            textColor: kRadioColor,
                                                            textSize: kFontSize14,
                                                            textWeight: FontWeight.w500,
                                                          ),

                                                          space(),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              var url =
                                                                  "tel:${data['ph']}";
                                                              if (await canLaunch(url)) {
                                                                await launch(url);
                                                              } else {
                                                                throw 'Could not launch $url';
                                                              }
                                                            },
                                                            child: TextWidget(
                                                              name: data['ph'],
                                                              textColor: kLighterBlue,
                                                              textSize: kFontSize,
                                                              textWeight: FontWeight.normal,
                                                            ),
                                                          ),

                                                          RichText(
                                                            text: TextSpan(
                                                                text: 'Arrived:',
                                                                style: GoogleFonts.oxanium(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: ScreenUtil()
                                                                      .setSp(kFontSize, ),
                                                                  color: kYellow,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: '${DateFormat('EE d MMM,yyyy').format(DateTime.parse(data['dt']))}',
                                                                    style: GoogleFonts.oxanium(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(kFontSize, ),
                                                                      color: kDarkRedColor,
                                                                    ),
                                                                  )
                                                                ]),
                                                          )


                                                        ],
                                                      ),

                                                     /* Container(
                                                        height: kContainerHeight.h,
                                                        width: kContainerWidth.w,
                                                        color:doc.data['ol'] == true?kLightGreen:kWhiteColor,
                                                        child:  Column(
                                                          children: <Widget>[
                                                            TextWidget(
                                                              name:  doc.data['day']==DateTime.now().day?doc.data['dai'].toString():'0',
                                                              textColor: kTextColor,
                                                              textSize: kFontSize,
                                                              textWeight: FontWeight.w500,
                                                            ),
                                                            doc.data['ol'] == true?SvgPicture.asset('assets/imagesFolder/green_dot.svg',)
                                                                : SvgPicture.asset('assets/imagesFolder/grey_dot.svg',)   ,

                                                          ],
                                                        ),
                                                      ),


                                                      Container(
                                                        height: kContainerHeight.h,
                                                        width: kContainerWidth.w,
                                                        color:doc.data['ol'] == true?kWhiteColor:kHintColor,
                                                        child:  doc.data['ol'] == true?Icon(Icons.check,size: 25,color: kGreenColor,)
                                                            :  Center(
                                                          child: TextWidgetAlign(
                                                            name: doc.data['tm'].toString(),
                                                            textColor: kTextColor,
                                                            textSize: kFontSize14,
                                                            textWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      )*/
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            );
                                          }
                                          ).toList()
                                      ),
                                    );
                                  }
                                }
                            ),

                            _isFinish == false?
                            isLoading == true ?Center(child: PlatformCircularProgressIndicator()):Text('')

                                :Text(''),

                          ] )

                      )
                    ]
                ),
              )
          )
          )
      );
  }

  void getVendor(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


    setState(() {
      PageConstants.getVendor = PageConstants.vendorCount.where((element) => element['vId'] == data['id']).toList();

      PageConstants.getVendorCount.clear();
      PageConstants.getVendorCount.add(doc.data);

    });

    Navigator.push(context,
        PageTransition(
            type: PageTransitionType
                .scale,
            alignment: Alignment
                .bottomCenter,
            child: VendorLocationOnMap()));

  }
  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;

      if (_products.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance.collection
('vendorDaily')
            .where('gd', isEqualTo:  PageConstants.companyUD )
            .orderBy('dt',descending: false)
            .limit(Variables.limit)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });

        querySnapshot = await FirebaseFirestore.instance.collection
('vendorDaily')
            .where('gd', isEqualTo:  PageConstants.companyUD )
            .orderBy('dt',descending: false)

            .startAfterDocument(_products[_products.length - 1])
            .limit(Variables.limit)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _products.length;
        _products.addAll(querySnapshot.docs);
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          setState(() {
            _isFinish = true;
            isLoading = false;
          });
        }
      }
      _isRequesting = false;
    }
  }
}
