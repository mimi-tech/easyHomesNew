import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/withdrawal/bank_details.dart';
import 'package:easy_homes/withdrawal/stored_data.dart';
import 'package:http/http.dart' as http;

import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/screens/successful.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:page_transition/page_transition.dart';
class BvnScreen extends StatefulWidget {
  BvnScreen({required this.verify});
  final Widget verify;
  @override
  _BvnScreenState createState() => _BvnScreenState();
}

class _BvnScreenState extends State<BvnScreen> {
  TextEditingController _bvn = new TextEditingController();
  Color btnColor = kTextFieldBorderColor;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.03);
  }
  bool _publishModal = false;
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(

        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Column(
              children: <Widget>[

                spacer(),

                TextWidgetAlign(
                  name: kBvn,
                  textColor: kLightBrown,
                  textSize: kFontSize,
                  textWeight: FontWeight.w400,
                ),


                spacer(),

                Align(
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    name: kProvideBvn,
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
                   autofocus:  true,
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
                   widget.verify


              ],
            ),



          ),
        ),

    );
  }


  }

