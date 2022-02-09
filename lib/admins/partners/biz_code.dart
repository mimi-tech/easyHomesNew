import 'dart:io';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/partners/register_business.dart';
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
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
class RegisterBusinessCode extends StatefulWidget {
  @override
  _RegisterBusinessCodeState createState() => _RegisterBusinessCodeState();
}

class _RegisterBusinessCodeState extends State<RegisterBusinessCode> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  Color btnColor = kTextFieldBorderColor;
 bool _publishModal = false;
  TextEditingController _code = new TextEditingController();
  GeoFirePoint point = geo.point(latitude: AdminConstants.lat!, longitude: AdminConstants.log!);
  dynamic bankAccountName = '';

  static Geoflutterfire geo = Geoflutterfire();
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
        body: ModalProgressHUD(
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
                    title: TextWidget(
                      name: 'Please give us the street name where your gas station is located',
                      textColor: kDoneColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ),

                  spacer(),
                  spacer(),
                  /*getting the code*/
                  Platform.isIOS
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,

                      controller: _code,
                      autocorrect: true,
                      autofocus: true,
                      cursorColor: (kTextFieldBorderColor),
                      style: Fonts.textSize,
                      maxLength: 10,
                      placeholderStyle: GoogleFonts.oxanium(
                        fontSize: ScreenUtil().setSp(
                            kFontSize, ),
                        color: kHintColor,
                      ),
                      placeholder: 'Enter street name',
                      onChanged: (String value) {
                        VendorConstants.code = value;
                        if (_code.text.length <= 0) {
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
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,

                    controller: _code,
                    autocorrect: true,
                    autofocus: true,
                    maxLength: 10,

                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    decoration: VendorConstants.codeInput,
                    onChanged: (String value) {
                      VendorConstants.code = value;

                      if (_code.text.length <= 0) {
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
                    title: AdminConstants.companyCollection[0]['ab'] == null?'Next':'Submit',
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

    /*validate inputs*/

    if ((VendorConstants.code == null) || (VendorConstants.code == '')) {
      Fluttertoast.showToast(
          msg: kInputError,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    } else if (_code.text.length > 10) {
      Fluttertoast.showToast(
          msg: 'Gas station name should not exceed 10 characters',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else{

      if(AdminConstants.companyCollection[0]['ab'] == null){
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: RegisterBusiness()));
      }else{
      //this user have registered his business before

      setState(() {
        _publishModal = true;
      });
      try {


        /*putting it in single document*/
        DocumentReference documentReferences =  FirebaseFirestore.instance.collection('AllBusiness')
            .doc();
        documentReferences.set ({

          'scity': AdminConstants.businessSubLocation,
          'city': Variables.locality,
          //textCity.trim().toLowerCase(),
          'cty': Variables.country,
          //AdminConstants.pickedCountry,
          'st': Variables.administrative,
          //AdminConstants.pickedState,

          'date': DateFormat("yyyy-MM-dd hh:mm:a").format(DateTime.now()),
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
          'gas':VendorConstants.gasPrize,

        });



        FirebaseFirestore.instance
            .collection('userReg')
            .doc(AdminConstants.currentUserUid!.trim())
            .update({
          'create': true,
          'ab':AdminConstants.companyCollection[0]['ab'] + 1,


        }).whenComplete(() {
          setState(() {
            _publishModal = false;
          });

          VariablesOne.notify(title: 'Thank you, you have successfully registered your gas station.');


          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreenSecond(),
            ),
                (route) => false,
          );

        });
      } catch (e) {
      VariablesOne.notifyFlutterToastError(title: kError);
      }

    }}
  }
}