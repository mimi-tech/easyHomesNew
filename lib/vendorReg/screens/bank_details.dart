import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/NGNbankList.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/utility/profile_pix.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/screens/store_address.dart';
import 'package:easy_homes/vendorReg/screens/successful.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class PaymentDetails extends StatefulWidget {
  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }

bool showName = false;
bool progress = false;
  TextEditingController _actName = new TextEditingController();

  TextEditingController _actNumber = new TextEditingController();
  //TextEditingController _actName = new TextEditingController();

  Color btnColor = kTextFieldBorderColor;

   dynamic bankAccountName = '';
   String errorText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getYourBank();

  }
  Future<void> getYourBank() async {
    String url = "https://api.paystack.co/bank?country=nigeria";

    http.Response res = await http.get(Uri.parse(url),
        headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});

    if (res.statusCode == 200) {


      final Map<String, dynamic> jsonDecoded = json.decode(res.body);
      var videos = jsonDecoded['data'];
      //iterate over the list

      for (var item in videos){
        Map myMap = item;
        setState(() {
          VariablesOne.banksLists.add(myMap['name']);
          VariablesOne.banksListsCode.add(myMap['code']);
        });
      }

    }else{
      setState(() {
        errorText = kErrorText;
      });
    }
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

            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 50,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: Variables.userPix!,
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      SvgPicture.asset(
                          'assets/imagesFolder/user.svg'),
                  fit: BoxFit.cover,
                  width: 200.w,
                  height: 200.h,
                ),
              ),
            ),

            spacer(),
            Center(
              child: GestureDetector(

                child: TextWidget(
                  name: kPaymentDetails.toUpperCase(),
                  textColor: kLightBrown,
                  textSize: 20,
                  textWeight: FontWeight.w600,
                ),
              ),
            ),



            spacer(),
            Center(
              child: TextWidgetAlign(
                name: kPaymentDetails2,
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.normal,
              ),
            ),

spacer(),
            Align(
              alignment: Alignment.topLeft,
              child: TextWidget(
                name: 'Bank Name',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),


            Platform.isIOS
                ? GestureDetector(
              onTap: (){_showBankNames();},
                  child: AbsorbPointer(
                    child: CupertinoTextField(

                      controller: VariablesOne.name,
              autocorrect: true,
              cursorColor: (kTextFieldBorderColor),
              style: Fonts.textSize,
              placeholderStyle: GoogleFonts.oxanium(
                    fontSize: ScreenUtil().setSp(
                        kFontSize, ),
                    color: kHintColor,
              ),
              placeholder: 'Bank name',
              onChanged: (String value) {
                    VendorConstants.bankName = value;
              },
              decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorder),
                      border: Border.all(color: kLightBrown)),
            ),
                  ),
                )
                : GestureDetector(
              onTap: (){_showBankNames();},
                  child: AbsorbPointer(
                    child: TextField(
                      onTap: (){_showBankNames();},
              controller: VariablesOne.name,
              autocorrect: true,
              cursorColor: (kTextFieldBorderColor),
              style: Fonts.textSize,
              decoration: VendorConstants.bankNameInput,
              onChanged: (String value) {
                    VendorConstants.bankName = value;
              },

            ),
                  ),
                ),

/*bank Account Name*/


            /*spacer(),
            Align(
              alignment: Alignment.topLeft,
              child: TextWidget(
                name: 'Bank Account Name',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w600,
              ),
            ),
            Platform.isIOS
                ? CupertinoTextField(
              controller: _actName,
              autocorrect: true,
              cursorColor: (kTextFieldBorderColor),
              style: Fonts.textSize,
              placeholderStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kHintColor,
              ),
              placeholder: 'Enter your bank account name',
              onChanged: (String value) {
                VendorConstants.bankAccountName = value;
              },
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorder),
                  border: Border.all(color: kLightBrown)),
            )
                : TextField(
              controller: _actName,
              autocorrect: true,

              cursorColor: (kTextFieldBorderColor),
              style: Fonts.textSize,
              decoration: VendorConstants.bankAccountNameInput,
              onChanged: (String value) {
                VendorConstants.bankAccountName = value;
              },

            ),
*/

            /*back account Number*/

            spacer(),
            Align(
              alignment: Alignment.topLeft,
              child: TextWidget(
                name: 'Bank Account Number',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
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
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: kHintColor,
              ),
              placeholder: 'Enter your bank account number',
              onChanged: (String value) {
                VendorConstants.bankAccountNumber = int.parse(value);;

                if ( _actNumber.text.length ==10) {
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
              decoration: VendorConstants.bankAccountNumberInput,
              onChanged: (String value) {
                VendorConstants.bankAccountNumber = int.parse(value);
                if ( _actNumber.text.length ==10) {
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
              child:Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextWidget(
                      name: 'Bank Account Name',
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w600,
                    ),
                  ),
                  Platform.isIOS?
                      CupertinoTextField(
                        readOnly: true,
                        controller: _actName,
                        maxLines: null,
                        autocorrect: true,
                        cursorColor: (kTextFieldBorderColor),
                        style: Fonts.textSize,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorder),
                            border: Border.all(color: kLightBrown)),

                      )
                      :TextField(
                    readOnly: true,
                    controller: _actName,
                    maxLines: null,
                    autocorrect: true,
                    cursorColor: (kTextFieldBorderColor),
                    style: Fonts.textSize,
                    decoration: VendorConstants.bankAccountNumberInput,

                  ),




                ],
              )
            ),
                spacer(),



            showName?Btn(nextFunction: () {
              moveToNext();
            }, bgColor: btnColor,):
            progress?Center(child: PlatformCircularProgressIndicator()):SizedBtn(nextFunction: () {
              verify();
            }, bgColor: btnColor,title: 'verify',),
            spacer(),

          ],
        )

      ),
    )));
  }

  Future<void> verify() async {
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
    }

    else {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      setState(() {
  progress = true;
});
//get the user bank name

      String url = "https://api.paystack.co/bank/resolve?account_number=${_actNumber.text.trim()}&bank_code=${VendorConstants.bankNameCode}";
      http.Response res = await http.get(Uri.parse(url),
          headers: {VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['sk']}'});
      //headers:{"Authorization: Bearer"});
      //print(res.body);

      if (res.statusCode == 200) {
        final Map<String,dynamic> jsonDecoded = json.decode(res.body);
        setState(() {
          bankAccountName = jsonDecoded['data']['account_name'];
          _actName.text = jsonDecoded['data']['account_name'];
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
         _actName.text = "No name found";
         progress = false;
         showName = true;


       });
      }

    }


  }

  void _showBankNames() {
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
        isScrollControlled: true,
        context: context,
        builder: (context) => NGBankList()
    );

  }

  void moveToNext() {
     Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OutletAddress()));

  }


}
