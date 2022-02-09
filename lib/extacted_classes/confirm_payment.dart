import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmCustomerPayment extends StatefulWidget {
  ConfirmCustomerPayment({required this.amount, required this.click});
  final dynamic amount;
  final Function click;

  @override
  _ConfirmCustomerPaymentState createState() => _ConfirmCustomerPaymentState();
}

class _ConfirmCustomerPaymentState extends State<ConfirmCustomerPayment> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 600),
              curve: Curves.decelerate,
              child: Container(

              //height: MediaQuery.of(context).size.height * 0.4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextWidgetAlign(
                    name:'Confirm Order'.toUpperCase(),
                    textColor: kLightBrown,
                    textSize: 20,
                    textWeight: FontWeight.bold,
                  ),
                ),
               Divider(),

      Padding(
        padding: const EdgeInsets.all(12.0),
        child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
        text: 'The total amount to be paid is ',
        style: GoogleFonts.oxanium(
        fontWeight: FontWeight.w400,
        fontSize: ScreenUtil()
              .setSp(kFontSize, ),
        color: kTextColor,
        ),
        children: <TextSpan>[
        TextSpan(
        text: 'NGN${widget.amount.toString()}',
        style: GoogleFonts.oxanium(
        fontWeight: FontWeight.w500,
        fontSize: ScreenUtil()
              .setSp(kFontSize, ),
        color: kSeaGreen,
        ),
        ),



        ],
              ),
              ),
      ),
                SizedBox(height:10),

                YesNoBtnDynamic(no: (){Navigator.pop(context);}, yes: widget.click,yesText: 'Proceed',noText: 'Cancel',),
                SizedBox(height:10),
        ],),
          )))
      ]
      ),
    );
  }
}
