import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/bankAccount/ussd_code.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/fund_appbar.dart';
import 'package:easy_homes/funds/headings.dart';
//import 'package:easy_homes/pay_api/core/models/bank_with_ussd.dart';
//import 'package:easy_homes/pay_api/core/models/responses/charge_response.dart';
import 'package:easy_homes/pay_api/models/bank_with_ussd.dart';
//import 'package:easy_homes/pay_api/models/responses/charge_response.dart';

import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/match_vendor.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/admin_header.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sticky_headers/sticky_headers.dart';

class PaymentWithUSSD extends StatefulWidget {


  @override
  _PaymentWithUSSDState createState() => _PaymentWithUSSDState();
}

class _PaymentWithUSSDState extends State<PaymentWithUSSD> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

   BuildContext? loadingDialogContext;
  TextEditingController controller = TextEditingController();

  //ChargeResponse _chargeResponse;
  bool hasInitiatedPay = false;
  bool hasVerifiedPay = false;
  bool isBottomSheetOpen = false;

  final FocusNode focusNode = FocusNode();
   BanksWithUssd? selectedBank;
  final TextEditingController _bankController = TextEditingController();

  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05,);
  }
bool _publishModal = false;
  @override
  Widget build(BuildContext context) {
    this._bankController.text =
    this.selectedBank != null ? this.selectedBank!.bankName : "";
    return SafeArea(
      // debugShowCheckedModeBanner: widget._paymentManager.isDebugMode,
      child: Scaffold(
        key: this._scaffoldKey,
        appBar: CardAppBar(),

        body:ProgressHUDFunction(
          inAsyncCall: _publishModal,
          child: SingleChildScrollView(
            child: Container(
                child: Form(
                  key: this._formState,
                  child:  Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextWidgetAlign(
                            name: 'Payment with USSD',
                            textColor: kTextColor,
                            textSize: kFontSize,
                            textWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 50,),
                      FormHeading(title: 'Select your bank',),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: this._showBottomSheet,
                          child: AbsorbPointer(
                            child: Platform.isIOS?
                                CupertinoTextField(
                                    controller: _bankController,
                                    readOnly: true,

                                    textAlign: TextAlign.center,
                                    style: Fonts.textSize,
                                  placeholderStyle: GoogleFonts.oxanium(
                                    fontSize: ScreenUtil().setSp(kFontSize14,),
                                    color: kBlackColor.withOpacity(0.6),
                                  ),
                                  placeholder: 'Not less than NGN 1000.00',
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(kBorder),
                                      border: Border.all(color: kLightBrown)),
                                )
                                :TextFormField(
                                controller: _bankController,
                                readOnly: true,

                                validator: (value) => value!.isEmpty ? "Please select a bank" : null,
                                textAlign: TextAlign.center,
                                style: Fonts.textSize,
                                decoration: Variables.bankNameInput
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 50,),

                      NewBtn(nextFunction: (){callUssd();}, bgColor: kLightBrown, title: 'Fund NGN ${VariablesOne.numberFormat.format(Deposit.amount)}'.toUpperCase())

                    ],
                  ),
                )
            ),
          ),
        )
      ),
    );
  }



  Widget _getBanksThatAllowsUssd() {
    final banks = BanksWithUssd.getBanks();
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            StickyHeader(
              header:  AdminHeader(title: 'Choose your bank'.toUpperCase(),),


              content:ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: banks
                    .map((bank) =>  GestureDetector(
                  onTap: () => {this._handleBankTap(bank)},
                      child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.ac_unit,color: kLightBrown,),
                                SizedBox(width: 10,),
                                TextWidget(
                                  name: bank.bankName,
                                  textColor: kDoneColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.w500,
                                ),

                              ],
                            ),
                          ),
                        ),

                      ],
                  ),
                    ),
                )
                    .toList(),
              ),)
          ],
        ),
      ),
    );
  }

  void _handleBankTap(final BanksWithUssd selectedBank) {
    this._removeFocusFromView();
    this.setState(() {
      this.selectedBank = selectedBank;
      this.controller.text = selectedBank.bankName;
    });
    Navigator.pop(this.context);
  }

  void _showBottomSheet() {
    Platform.isIOS?showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          this._getBanksThatAllowsUssd()

        ],
      );
    })
    :showModalBottomSheet(
      isDismissible: true,
        context: this.context,
        builder: (context) {
          return this._getBanksThatAllowsUssd();
        });
    this.setState(() {
      this.isBottomSheetOpen = true;
    });
  }

  void _removeFocusFromView() {
    FocusScope.of(this.context).requestFocus(FocusNode());
  }

  Future<void> callUssd() async {
    //call the ussd api

    setState(() {
      _publishModal = true;
    });
//resolve account number
    try{
      String urlCheck = Deposit.checkUSSD;
      Map<String, String> headersCheck = {"Content-type": "application/json",VariablesOne.authorizationBearer: 'Bearer ${Variables.cloud!['fsk']}'};
      var bodyCheck = json.encode ({

        'account_bank': selectedBank!.bankCode,
        "tx_ref":DateTime.now().toIso8601String(),
        "amount":Deposit.amount.toString(),
        "currency":"NGN",
        "email":Variables.currentUser[0]['email'],
        "phone_number":Variables.currentUser[0]['ph'],
        "fullname":Variables.currentUser[0]['fn']

      });
      Response responseCheck = await http.post(Uri.parse(urlCheck), headers: headersCheck, body: bodyCheck);

      if(responseCheck.statusCode == 200) {
        final Map<String,dynamic> jsonDecoded = json.decode(responseCheck.body);
        var mapItems = jsonDecoded['meta'];

        setState(() {
          _publishModal = false;
        });
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: USSDCode(jsonBody:jsonDecoded,mapBody:mapItems)));

      }else{
        setState(() {
          _publishModal = false;
        });
        VariablesOne.notifyErrorBot(title:kResolveBank );
        Navigator.pop(context);
      }
    }catch(e){
      print(e);
      setState(() {
        _publishModal = false;
      });


      VariablesOne.notifyErrorBot(title: kError);

    }

  }


}

