import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/funds/constants.dart';
import 'package:easy_homes/funds/headings.dart';
import 'package:easy_homes/funds/validator.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';


class UsersAddMinusWalletAmount extends StatefulWidget {
  UsersAddMinusWalletAmount({required this.minusAdd, required this.title, required this.walletText});

  final Function minusAdd;
  final String title;
  final String walletText;
  @override
  _UsersAddMinusWalletAmountState createState() => _UsersAddMinusWalletAmountState();
}

class _UsersAddMinusWalletAmountState extends State<UsersAddMinusWalletAmount> {
  Widget space() {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.02,
    );
  }

  TextEditingController _amount = TextEditingController();

  late int amount;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 600),
            curve: Curves.decelerate,
            child: Column(
                children: <Widget>[

                  space(),
                  space(),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/imagesFolder/wallet3.svg',
                  color: kBlackColor,
                ),
                SizedBox(
                  width: 20,
                ),
                TextWidgetAlign(
                  name: widget.walletText.toUpperCase(),
                  textColor: kTextColor,
                  textSize: 20,
                  textWeight: FontWeight.w600,
                ),
              ],
            ),
                  Divider(),
                  space(),
                  FormHeading(
                    title: widget.title.toUpperCase(),
                  ),

                  Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:50.0),
                          child: TextFormField(
                            controller: _amount,
                            autocorrect: true,
                            cursorColor: (kTextFieldBorderColor),
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: Fonts.textSize,
                            decoration: Variables.amountInputs,
                            onSaved: (String? value) {
                              Deposit.amount = int.parse(value!);

                            },

                            onChanged: (String value) {
                              Deposit.amount = int.parse(value);

                            },
                            validator: Validator.validateWalletAMount,
                          )
                      )
                  ),
                  space(),
                  SizedBtn(nextFunction: widget.minusAdd, bgColor: kLightBrown, title: 'Send'.toUpperCase()),

                  space(),

                ]
            )
        )
    );
  }


}
