import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/fund_appbar.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';

class RequestForOTP extends StatefulWidget {
  RequestForOTP({required this.next});
  final Function next;
  @override
  _RequestForOTPState createState() => _RequestForOTPState();
}

class _RequestForOTPState extends State<RequestForOTP> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 600),
            curve: Curves.decelerate,
          child: Column(

            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextWidgetAlign(
                  name: 'Please enter the OTP sent \nto your mobile or email',
                  textColor: kDoneColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),
              ),


              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: this._formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [


                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        cursorColor: kLightBrown,
                        decoration: Variables.cardOTPInput,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        autocorrect: false,
                        style: Fonts.textSize,
                        controller: this._otpController,
                        validator: this._pinValidator,
                        onChanged: (String value){
                          Deposit.otpText = value;
                        },
                      ),
                    ),
                    SizedBox(height: 30,),
                    SizedBtn(nextFunction:widget.next, bgColor: kLightBrown, title: 'Verify'),
                    SizedBox(height: 30,),


                  ],
                ),
              ),
            ],
          ),
        ),

    );
  }

  String? _pinValidator(String? value) {
    return value!.trim().isEmpty ? "Otp is required" : null;
  }


}
