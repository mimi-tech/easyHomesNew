import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/biz_bottombar.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/admins/constructors/verify_construct.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_activity_tab.dart';
import 'package:easy_homes/admins/pages/AllActivities/Business/Tab/biz_vendors.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/vendor_location.dart';
import 'package:easy_homes/admins/pages/vendor_pix.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessScreen extends StatefulWidget {
  @override
  _BusinessScreenState createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {

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
    FirebaseFirestore.instance.collection('userReg')
        .where('cbi', isEqualTo:  Variables.userUid )
        .where('sa', isEqualTo: true)
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
        bottomNavigationBar: BizBottomBar(
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
              if (AdminConstants.category == AdminConstants.admin.toLowerCase()) {
                try {
                  FirebaseFirestore.instance.collection('userReg').doc(
                      AdminConstants.getAdminUid)
                      .set({
                    'lo': DateFormat('a\n h:mm').format(DateTime.now()),
                    'ol': false,
                  },SetOptions(merge: true));
                } catch (e) {}
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreenSecond(),
                  ),
                      (route) => false,
                );
              }else{
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreenSecond(),
                  ),
                      (route) => false,
                );
              }
            }
    ),




          backgroundColor: kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextWidget(name: AdminConstants.bizName!.toUpperCase(),// AdminConstants.bizName!.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),

        AdminConstants.category == AdminConstants.admin.toLowerCase()?Text(''): GestureDetector(
                  onTap: (){

                    Platform.isIOS?CupertinoActionSheet(

                      actions: <Widget>[
                        SelectType()
                      ],
                    ):showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => SelectType()
                    );
                    },
                  child: SvgPicture.asset('assets/imagesFolder/add_circle.svg',)),




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
                  flexibleSpace:  Column(
                      children: <Widget>[
                        SizedBox(height: 10,),
                        BusinessActivityPage(
                          azTextColor: kWhiteColor,activityTextColor: kTextColor,logTextColor: kTextColor,
                          azColor: kBlackColor,activityColor:kDividerColor,logColor:kDividerColor,),

                        BizVendors(),


                      ],
                    )

                ),
          SliverList(
            delegate: SliverChildListDelegate([

              StreamBuilder<List<DocumentSnapshot>>(
                    stream: _streamController.stream,
                    builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                      if(snapshot.data == null){
                        return  ErrorTitle(errorTitle: knoCompanyVendor2,);
                      } else {

                        return Column(
                            children: snapshot.data!.map((doc) {
                                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                              PageConstants.allVendorCount.add(doc.data);

                              return
                              Card(
                                elevation: kEle,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: TextWidget(
                                        name: '${data['fn']} ${data['ln']}'.toUpperCase(),
                                        textColor: kLightBrown,
                                        textSize: kFontSize,
                                        textWeight: FontWeight.w500,
                                      ),
                                    ),

                                    Divider(),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(width: imageRightShift.w,),

                                        VendorPix(pix:data['pix'] ,pixColor: Colors.transparent,),

                                        SizedBox(width: imageRightShift.w,),


                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ReadMoreTextConstruct(title: data['sad'], colorText: kRadioColor),


                                            TextWidget(
                                              name: data['biz'].toUpperCase(),
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
                                                  name: '${data['co']}'.toUpperCase(),
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
                                          ],
                                        ),
                                        Spacer(),

                                        data['ol'] == true?Icon(Icons.circle,color: kGreenColor,):Icon(Icons.circle,color: kRadioColor,),

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
                                            removeSales(doc);},
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
                            ).toList()
                        );
                      }
                    }
                ),

                _isFinish == false?
                isLoading == true ?Center(child: PlatformCircularProgressIndicator()):Text('')

                    :Text('')

                // PartnerCountingPage(),
              ],
            ),
          )

    ]),
        ))));
  }


  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;

      if (_products.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance.collection('userReg')
            .where('cbi', isEqualTo:  Variables.userUid )
            .where('sa', isEqualTo: true)
            .orderBy('date',descending: true)
            .limit(Variables.monthsLimit)
            .get();
      } else {
        setState(() {
          isLoading = true;
        });

        querySnapshot = await FirebaseFirestore.instance.collection('userReg')
            .where('cbi', isEqualTo:  Variables.userUid )
            .where('sa', isEqualTo: true)
            .orderBy('date',descending: true)
            .startAfterDocument(_products[_products.length - 1])
            .limit(Variables.monthsLimit)
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

  void removeSales(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
                removeBiz(doc);
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
              text2: '${data['fn'].toString().toUpperCase()} ${data['ln'].toString().toUpperCase().toString().toUpperCase()}',
              text3: kRemoveAdminText3,),

            space(),


            YesNoBtn(no: (){Navigator.pop(context);},yes: (){removeBiz(doc);},)

          ],
        ));

  }

  Future<void> removeBiz(DocumentSnapshot doc) async {

    await FirebaseFirestore.instance.collection
('userReg').doc(doc['ud'])
        .update({'sa': FieldValue.delete(),
      'sac': FieldValue.delete(),
      'sad': FieldValue.delete(),
      'ca': FieldValue.delete(),
      'co':FieldValue.delete(),
      'cbi':FieldValue.delete(),
    });


  }



}
