import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BackCreditCard extends StatefulWidget {
  BackCreditCard({required this.cardCvv,    required this.cIcon,
  });
  final String cardCvv;
  final Widget cIcon;

  @override
  _BackCreditCardState createState() => _BackCreditCardState();
}

class _BackCreditCardState extends State<BackCreditCard> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
    Container(

      margin: EdgeInsets.symmetric(horizontal: 12),

    child: Image.asset('assets/imagesFolder/creditBg2.png',),),
    Column(
        children: [

          Container(
            margin: EdgeInsets.symmetric(vertical: 15,horizontal: 12),
            height:MediaQuery.of(context).size.height * 0.07,
            //width: double.infinity,
            color: kBlackColor,
          ),

          Padding(
            padding: const EdgeInsets.only(right:50.0),
            child: Container(
              //width: MediaQuery.of(context).size.width * 0.7,
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
              height:MediaQuery.of(context).size.height * 0.07,
              color: kRadioColor,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text( widget.cardCvv,
                    style: GoogleFonts.pacifico(
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kBlackColor,

                    ),
                  ),
                ),
              ),
            ),
          ),




          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: widget.cIcon,
            ),
          )

      ])]);
    }
}
