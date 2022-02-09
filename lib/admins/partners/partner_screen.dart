import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/Partner_company.dart';
import 'package:easy_homes/admins/pages/AllActivities/Partners/Tabs/partner_activity_tabs.dart';
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
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
class PartnerScreen extends StatefulWidget {
  @override
  _PartnerScreenState createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {

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
('vendorCount').orderBy('wky',descending: true)

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
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
            onPressed: () {
              //update admin login time for owner

              if(  AdminConstants.category == AdminConstants.admin.toLowerCase() ) {
                try {
                  FirebaseFirestore.instance.collection
('userReg').doc(
                      AdminConstants.getAdminUid)
                      .set({
                    'lo': DateFormat('a\n h:mm').format(DateTime.now()),
                    'ol': false,
                  },SetOptions(merge: true));
                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreenSecond(),
                    ),
                        (route) => false,
                  );
                } catch (e) {

                }
              }
              Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreenSecond(),
                ),
                    (route) => false,
              );
            },
          ),
          backgroundColor: kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextWidget(
                name:  AdminConstants.bizName!.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
              AdminConstants.category == AdminConstants.admin.toLowerCase()?Text(''):  GestureDetector(
                  onTap: () {
                    Platform.isIOS
                        ? CupertinoActionSheet(
                      actions: <Widget>[SelectType()],
                    )
                        : showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => SelectType());
                  },
                  child: SvgPicture.asset(
                    'assets/imagesFolder/add_circle.svg',
                  )),



            ],
          ),
        ),
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
                  PartnerActivityPage(
                    azTextColor: kWhiteColor,activityTextColor: kTextColor,logTextColor: kTextColor,
                    azColor: kBlackColor,activityColor:kDividerColor,logColor:kDividerColor,),
                  space(),
                  PartnerCompanies(),

                  PartnerCountingPage(),
                ],
              ),

        ),
        SliverList(
            delegate: SliverChildListDelegate([


            StreamBuilder<List<DocumentSnapshot>>(
                  stream: _streamController.stream,
                  builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if(snapshot.data == null){
                      return   ErrorTitle(errorTitle: knoCompanyVendor,);
                    } else {

                      return Column(
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
                                            name: data['biz'].toString().toUpperCase(),
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
                                                text: 'Last dd:',
                                                style: GoogleFonts.oxanium(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ScreenUtil()
                                                      .setSp(kFontSize, ),
                                                  color: kYellow,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:'${data['day']}/${data['mth']}/${data['yr']}',
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
                                      Spacer(),

                                      Container(
                                        height: kContainerHeight.h,
                                        width: kContainerWidth.w,
                                        color:data['ol'] == true?kLightGreen:kWhiteColor,
                                        child:  Column(
                                          children: <Widget>[
                                            TextWidget(
                                              name:   data['day'] == DateTime.now().day&&
                                                  data['wky'] == Jiffy().week?data['dai'].toString():'0',
                                              textColor: kTextColor,
                                              textSize: kFontSize,
                                              textWeight: FontWeight.w500,
                                            ),
                                            data['ol'] == true?SvgPicture.asset('assets/imagesFolder/green_dot.svg',)
                                                : SvgPicture.asset('assets/imagesFolder/grey_dot.svg',)   ,

                                          ],
                                        ),
                                      ),


                                      Container(
                                        height: kContainerHeight.h,
                                        width: kContainerWidth.w,
                                        color:data['ol'] == true?kWhiteColor:kHintColor,
                                        child:  data['ol'] == true?Icon(Icons.check,size: 25,color: kGreenColor,)
                                            :  Center(
                                          child: TextWidgetAlign(
                                            name: data['tm'].toString(),
                                            textColor: kTextColor,
                                            textSize: kFontSize14,
                                            textWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  Divider(),
                                ],
                              ),
                            );
                          }
                          ).toList()
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
      PageConstants.getVendor = PageConstants.vendorCount.where((element) => element['vId'] == data['vid']).toList();

      PageConstants.getVendorCount.clear();
      PageConstants.getVendorCount.add(doc.data);

    });
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: VendorLocationOnMap()));



  }
  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;

      if (_products.isEmpty) {
        querySnapshot = await     FirebaseFirestore.instance.collection
('vendorCount').orderBy('wky',descending: true)

            .limit(Variables.yearLimit)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });

        querySnapshot = await    FirebaseFirestore.instance.collection
('vendorCount').orderBy('wky',descending: true)

            .startAfterDocument(_products[_products.length - 1])
            .limit(Variables.yearLimit)
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
