import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/vendorReg/screens/drive.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/vendorReg/screens/successful.dart';

import 'package:easy_homes/vendorReg/screens/vendor_location.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:page_transition/page_transition.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';


class OutletAddress extends StatefulWidget {
  @override
  _OutletAddressState createState() => _OutletAddressState();
}

class _OutletAddressState extends State<OutletAddress> {
  TextEditingController _companyAddress = TextEditingController();


  String? state;
  Color btnColor = kTextFieldBorderColor;

  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.05);
  }

  bool isSwitched = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _companyAddress.text = Variables.buyerAddress!;
  }

  Geoflutterfire geo = Geoflutterfire();
  late StreamSubscription subscription;


  @override
  bool progress = false;

  updateMarkers(List<DocumentSnapshot> documentList) {

    documentList.forEach((DocumentSnapshot document) {
     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      GeoPoint pos = data['pos']['geopoint'];
      double distance = data['distance'];
      setState(() {
        progress = false;
      });
      print(pos);
      print(distance);
      /* var marker = Marker(
          position: LatLng(pos.latitude, pos.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindowText: InfoWindowText('Magic Marker', '$distance kilometers from query center')
      );
*/

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: SingleChildScrollView(

      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: Column(
            children: <Widget>[
              spacer(),
             BackLogo(),

              spacer(),
              TextWidgetAlign(
                name: VendorConstants.outLetStore == 'No' ? kGasOs2 : kGasOS,
                textColor: kBlackColor,
                textSize: kFontSize,
                textWeight: FontWeight.w600,
              ),

              spacer(),
              Platform.isIOS
                  ? GestureDetector(
                child: AbsorbPointer(
                  child: CupertinoTextField(
                    controller: _companyAddress,
                    autocorrect: true,
                    autofocus: true,
                    maxLines: null,
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    placeholderStyle: GoogleFonts.oxanium(
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),
                      color: kHintColor,
                    ),
                    placeholder: kGasOS + " " + 'street',
                    onChanged: (String value) {
                      Variables.buyerAddress = value;
                    },
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorder),
                        border: Border.all(color: kLightBrown)),


                  ),
                ),
              )
                  : GestureDetector(

                child: AbsorbPointer(
                  child: TextField(
                    readOnly: true,
                    controller: _companyAddress,
                    autocorrect: true,
                    autofocus: true,
                    maxLines: null,
                    cursorColor: (kTextFieldBorderColor),
                    keyboardType: TextInputType.text,
                    style: Fonts.textSize,
                    decoration: VendorConstants.companyAddressInput,
                    onChanged: (String value) {
                      Variables.buyerAddress = value;
                    },

                  ),
                ),
              ),

              spacer(),
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => VendorLocationService()));
                    },
                    child: RichText(
                      text: TextSpan(
                          text: (kCurrentLocation),
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(
                                kFontSize, ),
                            color: kProfile,
                          ),

                          children: <TextSpan>[
                            TextSpan(
                              text: kCurrentLocation2,
                              style: GoogleFonts.oxanium(
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(
                                    kFontSize, ),
                                color: kDoneColor,
                              ),
                            )
                          ]
                      ),
                    ),
                  )


              ),


              spacer(),
              progress == true ? PlatformCircularProgressIndicator() : Btn(
                nextFunction: () {
                  moveToNext();
                }, bgColor: kLightBrown,),
              spacer(),
            ]),


      ),
    ),


    ));
  }

  /*void moveToNext() {

    if( VendorConstants.companyStoresAddAll.isEmpty){
      Fluttertoast.showToast(
          msg: kAddError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else {

      Navigator.push(context, PageTransition(type: PageTransitionType.rotate, duration: Duration(seconds: kTransitionSecs), child: VendorDriving()));


    }



  }*/

  void moveToNext() {


    /*check if all input are filled*/
    setState(() {
      VendorConstants.companyAddress =  _companyAddress.text;
    });
    print(  Variables.buyerAddress);
    if ((VendorConstants.companyAddress == null) ||
        (VendorConstants.companyAddress == '')) {
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {

      /*check if it is a company registering the vendor*/
      if (
      Variables.userCat == AdminConstants.admin ||
      Variables.userCat == AdminConstants.partner ||
          Variables.userCat == AdminConstants.business
          || Variables.userCat == AdminConstants.owner) {

        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SuccessFulScreen()));



      } else {
        setState(() {
          progress = true;
        });


        try {
// Create a geoFirePoint
          /* GeoFirePoint center = geo.point(
            latitude: AdminConstants.businessPosition.latitude,
            longitude: AdminConstants.businessPosition.longitude);
*/
          // ignore: close_sinks
          var radius = BehaviorSubject<int>.seeded(Variables.radius!);
          var ref = FirebaseFirestore.instance.collection
('AllBusiness').where('re',isEqualTo: true)

              .limit(1);

          GeoFirePoint centers = geo.point(
              latitude: Variables.latPosition!.latitude,
              longitude: Variables.latPosition!.longitude);

          // subscribe to query
          subscription = radius.switchMap((rad) {
            return geo.collection(collectionRef: ref).within(
                center: centers,
                radius: rad.toDouble(),
                field: 'pos',
                strictMode: true
            );
          }).listen(_updateMarkers);
        } catch (e) {
          setState(() {
            progress = false;
          });
        VariablesOne.notifyFlutterToastError(title: kError);
        }
      }
    }
    }

    void _updateMarkers(List<DocumentSnapshot> documentList) {
      documentList.forEach((DocumentSnapshot document) async {
        /*GeoPoint pos = document.data()[
'vPos']['geopoint'];
      double distance = document.data()[
'distance'];*/

      });

      if (documentList.length == 0) {
        setState(() {
          progress = false;
        });
        Fluttertoast.showToast(
            msg: kMatchVendorError,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 10,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      } else {
        VendorConstants.bizId = (documentList[0]['ud']);
        VendorConstants.bizName = (documentList[0]['biz']);
        VendorConstants.address = (documentList[0]['add']);
        VendorConstants.city = (documentList[0]['id']);
        VendorConstants.state = (documentList[0]['st']);
        VendorConstants.country = (documentList[0]['cty']);
        VendorConstants.lat = (documentList[0]['lat']);
        VendorConstants.log = (documentList[0]['log']);
        VendorConstants.ph = (documentList[0]['ph']);


        setState(() {
          progress = false;
        });
        subscription.cancel();

        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SuccessFulScreen()));



      }
    }
  }




