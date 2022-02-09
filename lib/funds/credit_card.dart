import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MineCreditCard extends StatefulWidget {
  MineCreditCard({required this.cNumber,
    required this.cDate,
    required this.cName,
    required this.cIcon,

  });
  final String cNumber;
  final String cDate;
  final String cName;
  final Widget cIcon;

  @override
  _MineCreditCardState createState() => _MineCreditCardState();
}

class _MineCreditCardState extends State<MineCreditCard> {
  Widget space(){
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02,);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12),

          child: Image.asset(
            'assets/imagesFolder/creditBg2.png',
            //height: MediaQuery.of(context).size.height * 0.25,
            //width:double.infinity ,
          ),
        ),
        Column(

          children: [

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:47.0,vertical: 10),
                child: TextWidget(
                  name: 'Debit',
                  textColor: kWhiteColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,
                ),
              ),
            ),

            space(),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/imagesFolder/chip.svg',
                    height: 40,
                    width: 40,
                  ),
                  SizedBox(width: 20,),
                  SvgPicture.asset(
                    'assets/imagesFolder/wifi.svg',
                    height: 30,
                    width: 30,
                  ),
                ],
              ),
            ),
            space(),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    name: widget.cNumber,
                    textColor: kWhiteColor,
                    textSize: 20,
                    textWeight: FontWeight.bold,
                  ),



                  space(),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            TextWidget(
                              name: 'Valid'.toUpperCase(),
                              textColor: kWhiteColor,
                              textSize: 8,
                              textWeight: FontWeight.w400,
                            ),

                            TextWidget(
                              name: 'Thru'.toUpperCase(),
                              textColor: kWhiteColor,
                              textSize: 8,
                              textWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        SizedBox(width: 5,),

                        TextWidget(
                          name: widget.cDate,
                          textColor: kWhiteColor,
                          textSize: 16,
                          textWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),

                  /*Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Valid\n'.toUpperCase(),
                          style: GoogleFonts.oxanium(
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil()
                                .setSp(9, ),
                            color: kWhiteColor,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'nnn',
                              style: GoogleFonts.oxanium(
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenUtil()
                                    .setSp(9, ),
                                color: kWhiteColor,
                              ),
                            ),
                            TextSpan(
                              text: widget.cDate,
                              style: GoogleFonts.oxanium(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil()
                                    .setSp(kFontSize, ),
                                color: kWhiteColor,
                              ),
                            )
                          ]),
                    ),
                  ),*/
                  space(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        name: widget.cName.toUpperCase(),
                        textColor: kWhiteColor,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                      ),

                      widget.cIcon

                    ],
                  ),


                ],
              ),
            ),
          ],
        ),

      ],
    );
  }
}
