import 'dart:io';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
class RegisterBusinessBVN extends StatefulWidget {
  @override
  _RegisterBusinessBVNState createState() => _RegisterBusinessBVNState();
}

class _RegisterBusinessBVNState extends State<RegisterBusinessBVN> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  Color btnColor = kTextFieldBorderColor;
  static Geoflutterfire geo = Geoflutterfire();

  GeoFirePoint point = geo.point(latitude: AdminConstants.lat!, longitude: AdminConstants.log!);

  bool _publishModal = false;

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);

  TextEditingController _bvn = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          leading: IconButton(
            icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
            onPressed: () {
              Navigator.pop(context);
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
            ],
          ),
        ),
        body: ProgressHUDFunction(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  spacer(),
                  spacer(),
                  LogoDesign(),
                  spacer(),
                  spacer(),
                  AnimationSlide(
                    title: TextWidgetAlign(
                      name: 'We need your payment details to pay you'.toUpperCase(),
                      textColor: kDoneColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ),
                  /*getting the bvn*/
                  Platform.isIOS
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: false,
                        signed: true,
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: _bvn,
                      autocorrect: true,
                      autofocus: true,
                      cursorColor: (kTextFieldBorderColor),
                      style: Fonts.textSize,
                      maxLength: 11,
                      placeholderStyle: GoogleFonts.oxanium(
                        fontSize: ScreenUtil().setSp(
                            kFontSize, ),
                        color: kHintColor,
                      ),
                      placeholder: 'Bank Verification Number',
                      onChanged: (String value) {
                        VendorConstants.bvn = value;
                        if (_bvn.text.length < 11) {
                          setState(() {
                            btnColor = kTextFieldBorderColor;
                          });
                        } else {
                          setState(() {
                            btnColor = kLightBrown;
                          });
                        }
                      },
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kBorder),
                          border: Border.all(color: kLightBrown)),
                    ),
                  )
                      : TextField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: _bvn,
                    autocorrect: true,
                    autofocus: true,
                    maxLength: 11,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    decoration: VendorConstants.bvnInput,
                    onChanged: (String value) {
                      VendorConstants.bvn = value;

                      if (_bvn.text.length < 11) {
                        setState(() {
                          btnColor = kTextFieldBorderColor;
                        });
                      } else {
                        setState(() {
                          btnColor = kLightBrown;
                        });
                      }
                    },

                  ),
                  spacer(),


                  spacer(),
                  LocationBtn(
                    title: kVerify,
                    nextFunction: () {
                      moveToNext();
                    },
                    bgColor: btnColor,
                  ),
                  spacer(),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }

  void moveToNext() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    /*validate inputs*/

    if ((VendorConstants.bvn == null) || (VendorConstants.bvn == '')) {
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else {
      setState(() {
        _publishModal = true;
      });
        try {
          var capitalizedValue = Variables.fName!.substring(0, 1).toUpperCase();


          /*putting it in single document*/
          DocumentReference documentReferences =  FirebaseFirestore.instance.collection
('AllBusiness')
            .doc();
          documentReferences.set ({

            'scity': AdminConstants.businessSubLocation,
            'city': Variables.locality,
            //textCity.trim().toLowerCase(),
            'cty': Variables.country,
            //AdminConstants.pickedCountry,
            'st': Variables.administrative,
            //AdminConstants.pickedState,
            'bName': VendorConstants.bankName!.trim(),
            'bAct': VendorConstants.bankAccountName!.trim(),
            'bAN': VendorConstants.bankAccountNumber,
            'date': date,
            'ph': Variables.userPH,
            'biz': '${AdminConstants.bizName} ${VendorConstants.code}',
            'cat': AdminConstants.category,
            'ouid': AdminConstants.ownerUid,
            'ud': AdminConstants.currentUserUid,
            'name': AdminConstants.bizName,
            'ano': 0,
            'add': AdminConstants.businessLocation,
            //AdminConstants.businessLocation,
            'pos': point.data,
            //AdminConstants.businessPosition,
            'lat': AdminConstants.lat,
            //widget.lat,
            'log': AdminConstants.log,
            //widget.log
            'bv': VendorConstants.bvn,
            'ol':false,
            'con':false,
            'tr':false,
            'id':documentReferences.id,
            'fn': Variables.userFN!,
            'ln': Variables.userLN,
            'email': Variables.userEmail ,
            'cc':VendorConstants.code,
            'apr':true,
            're':AdminConstants.companyCollection[0]['so'] == true?true:false,
            'pix': Variables.userPix,
            'wal':0,
            'sk':capitalizedValue

          });

          //updating business count
          FirebaseFirestore.instance
              .collection('sessionActivity')
              .doc().get().then((resultData) {
            resultData.reference.set({
              'stc': resultData.data()!['stc'] + 1,
            }, SetOptions(merge: true));
          });

          FirebaseFirestore.instance
              .collection('userReg')
              .doc(AdminConstants.currentUserUid!.trim())
              .update({
            'create': true,
          });
            setState(() {
              _publishModal = false;
            });

            Fluttertoast.showToast(
                msg: 'Registered Successfully',
                timeInSecForIosWeb: 5,
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: kBlackColor,
                textColor: kGreenColor);
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreenSecond(),
              ),
                  (route) => false,
            );


        } catch (e) {
        VariablesOne.notifyFlutterToastError(title: kError);
        }

    }
  }
}