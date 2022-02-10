import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';

import 'package:easy_homes/admins/partners/register_business_bvn.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/NGNbankList.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:http/http.dart' as http;

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';

import 'package:page_transition/page_transition.dart';

class RegisterBusiness extends StatefulWidget {


  @override
  _RegisterBusinessState createState() => _RegisterBusinessState();
}

class _RegisterBusinessState extends State<RegisterBusiness> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);

  bool showName = false;
  bool progress = false;
  TextEditingController _name = new TextEditingController();

  TextEditingController _actName = new TextEditingController();

  TextEditingController _actNumber = new TextEditingController();
  dynamic bankAccountName = '';

  static Geoflutterfire geo = Geoflutterfire();

 /* GeoFirePoint point = geo.point(
      latitude: AdminConstants.lat, longitude: AdminConstants.log);*/
  bool _publishModal = false;

  /*static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd hh:mm:a").format(now);
*/
  String? textCity;
  String? textAddress;
  Color btnColor = kTextFieldBorderColor;

   GeoFirePoint point = geo.point(latitude: AdminConstants.lat!, longitude: AdminConstants.log!);



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
                    children: <Widget>[
                      spacer(),
                      spacer(),
                      LogoDesign(),

                      spacer(),
                      spacer(),
                      TextWidgetAlign(
                        name: 'We need your payment details to pay you'.toUpperCase(),
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),

                      spacer(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: AnimationSlide(
                          title: TextWidget(
                            name: 'Bank Name',
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Platform.isIOS
                          ? GestureDetector(
                              onTap: () {
                                _showBankNames();
                              },
                              child: AbsorbPointer(
                                child: CupertinoTextField(
                                  controller: VariablesOne.name,
                                  autocorrect: true,
                                  cursorColor: (kTextFieldBorderColor),
                                  style: Fonts.textSize,
                                  placeholderStyle: GoogleFonts.oxanium(
                                    fontSize: ScreenUtil().setSp(kFontSize,
                                        ),
                                    color: kHintColor,
                                  ),
                                  placeholder: 'Bank name',
                                  onChanged: (String value) {
                                    VendorConstants.bankName = value;
                                  },
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(kBorder),
                                      border: Border.all(color: kLightBrown)),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _showBankNames();
                              },
                              child: AbsorbPointer(
                                child: TextField(

                                  controller: VariablesOne.name,
                                  autocorrect: true,
                                  cursorColor: (kTextFieldBorderColor),
                                  style: Fonts.textSize,
                                  decoration:
                                      AdminConstants.bankName,
                                  onChanged: (String value) {
                                    VendorConstants.bankName = value;
                                  },
                                ),
                              ),
                            ),
                      spacer(),
                     /* CountryPicked(),
                      spacer(),
                      PickedState(),
                      spacer(),*/

                      /*bank Account Name*/

                      spacer(),

                      /*back account Number*/

                      spacer(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: AnimationSlide(
                          title: TextWidget(
                            name: 'Bank Account Number',
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Platform.isIOS
                          ? CupertinoTextField(
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: false,
                                signed: true,
                              ),
                              inputFormatters: <TextInputFormatter>[
                               FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: _actNumber,
                              autocorrect: true,
                                     maxLength: 10,
                              cursorColor: (kTextFieldBorderColor),
                              style: Fonts.textSize,
                              placeholderStyle: GoogleFonts.oxanium(
                                fontSize: ScreenUtil().setSp(kFontSize,
                                    ),
                                color: kHintColor,
                              ),
                              placeholder: 'Enter your bank account number',
                              onChanged: (String value) {
                                VendorConstants.bankAccountNumber =
                                    int.parse(value);

                                if (_actNumber.text.length == 10) {
                                  setState(() {

                                    btnColor = kLightBrown;
                                  });
                                } else {
                                  setState(() {
                                    btnColor = kTextFieldBorderColor;
                                  });
                                }
                              },
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(kBorder),
                                  border: Border.all(color: kLightBrown)),
                            )
                          : TextField(
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: false,
                                signed: true,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: _actNumber,
                              maxLength: 10,
                              autocorrect: true,
                              cursorColor: (kTextFieldBorderColor),
                              style: Fonts.textSize,
                              decoration:
                                  VendorConstants.bankAccountNumberInput,
                              onChanged: (String value) {
                                VendorConstants.bankAccountNumber =
                                    int.parse(value);
                                if (_actNumber.text.length == 10) {
                                  setState(() {
                                    btnColor = kLightBrown;
                                  });
                                } else {
                                  setState(() {
                                    btnColor = kTextFieldBorderColor;
                                  });
                                }
                              },
                            ),

                       spacer(),


                      Visibility(
                        visible: showName,

                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: AnimationSlide(
                                title: TextWidget(
                                  name: 'Bank Account Name',
                                  textColor: kTextColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            TextField(
                              readOnly: true,
                              controller: _actName,
                              maxLines: null,
                              autocorrect: true,
                              cursorColor: (kTextFieldBorderColor),
                              style: Fonts.textSize,
                              decoration: VendorConstants.bankAccountNumberInput,

                            ),

                          ],
                        ),
                      ),


                      spacer(),



                      showName?SizedBtn(nextFunction: () {
                        moveToNext();
                      }, bgColor: btnColor,title: 'Register',):
                      progress?Center(child: PlatformCircularProgressIndicator()):SizedBtn(nextFunction: () {
                        verify();
                      }, bgColor: btnColor,title: 'verify',),

                      spacer(),

                    ],
                  ),
                ),
              ),
            )));
  }

  Future<void> _showBankNames() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    /*display a modal showing the names of bank in nigeria*/
    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          NGBankList()
        ],
      );
    })

        : showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => NGBankList()
    );

  }



  void getBankName(BuildContext context, String bank, int index) {
    setState(() {
      VendorConstants.bankName = VariablesOne.name.text;
      Navigator.pop(context);
    });
    print( VendorConstants.bankName );
  }

  Future<void> verify() async {
print(VendorConstants.bankAccountName);
if(VariablesOne.name.text.isEmpty){
  Fluttertoast.showToast(
      msg: kInputError,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: kBlackColor,
      textColor: kRedColor);

}else if (_actNumber.text.isEmpty ){
  Fluttertoast.showToast(
      msg: kInputError,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: kBlackColor,
      textColor: kRedColor);

    } else {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }

      setState(() {
        progress = true;
      });
//get the user bank name

      dynamic url = "https://api.paystack.co/bank/resolve?account_number=${_actNumber.text.trim()}&bank_code=${VendorConstants.bankNameCode}";
      http.Response res = await http.get(url,
          headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});
      //headers:{"Authorization: Bearer"});
      //print(res.body);

      if (res.statusCode == 200) {
        final Map<String,dynamic> jsonDecoded = json.decode(res.body);
        setState(() {
          _actName.text = jsonDecoded['data']['account_name'];
          bankAccountName = jsonDecoded['data']['account_name'];
          VendorConstants.bankAccountName = jsonDecoded['data']['account_name'];
          progress = false;

          showName = true;
        });


        //print(jsonDecoded['account_name']);

        //print(jsonDecoded);
        /* setState(() {
          bankAccountName = jsonDecoded['account_name'];
          showName = true;
        });*/

      }else{
        setState(() {
          bankAccountName = "Sorry we could not resolve your bank details";
          progress = false;
          showName = true;


        });
      }

    }
  }

  void moveToNext() {
    //Navigator.push(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.bottomCenter, child: RegisterBusinessBVN()));


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
        'date': date,
        'ph': Variables.userPH,
        'biz': '${AdminConstants.bizName} ${VendorConstants.code}',
        'cat': AdminConstants.category,
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
        'sk':capitalizedValue

      });

      //updating business count
      FirebaseFirestore.instance
          .collection('sessionActivity')
          .doc()
          .get().then((resultData) {
        resultData.reference.set({
          'stc': resultData.data()!['stc'] + 1,
        }, SetOptions(merge: true));
      });

      FirebaseFirestore.instance
          .collection('userReg')
          .doc(AdminConstants.currentUserUid!.trim())
          .update({
        'create': true,
        'ab':AdminConstants.companyCollection[0]['ab'] == null ?0:AdminConstants.companyCollection[0]['ab'] + 1,
        'bN': VendorConstants.bankName!.trim(),
        'bAct': VendorConstants.bankAccountName!.trim(),
        'bAN': VendorConstants.bankAccountNumber,
        'bkc':  VendorConstants.bankNameCode,
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
