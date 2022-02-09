import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/shimmer_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyConstruct extends StatelessWidget {
  VerifyConstruct({required this.title,required this.msg, required this.name});
  final String title;
  final String msg;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        TextWidgetAlign(
          name: '$title gas sell confirmation'.toUpperCase(),
          textColor: kLightBrown,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),


    Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),

      child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(

      text: msg,

      style: GoogleFonts.oxanium(
      fontWeight: FontWeight.w500,
      fontSize: ScreenUtil().setSp(
      kFontSize, ),
      color: kTextColor,
      ),

      children: <TextSpan>[
      TextSpan(text: name,
      style: GoogleFonts.oxanium(
      fontWeight: FontWeight.bold,
      fontSize: ScreenUtil().setSp(
      kFontSize, ),
      color: kDoneColor,
      ),)
      ]
      ),
      ),
    ),


        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

      ],
    );
  }
}


class NoOnGoing extends StatelessWidget {
  NoOnGoing({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextWidgetAlign(
          name:'Hello ${Variables.userFN!}',
          textColor: kLightBrown,
          textSize: 20,
          textWeight: FontWeight.bold,
        ),

        Image.asset(
          "assets/imagesFolder/stop.gif",
          height: 125.0,
          width: 125.0,
        ),



        Center(
            child: ShimmerBgSecond(title: title,)
        ),
        SizedBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kDoneColor, title: 'Close')

      ],
    );
  }
}


class NoEarning extends StatelessWidget {
  NoEarning({required this.title, required this.color1,required this.color2,});
  final String title;
  final Color color1;
  final Color color2;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextWidgetAlign(
          name:'Hello ${Variables.userFN!}',
          textColor: kLightBrown,
          textSize: 20,
          textWeight: FontWeight.bold,
        ),

        Image.asset(
          "assets/imagesFolder/stop.gif",
          height: 125.0,
          width: 125.0,
        ),



        Center(
            child: ShimmerThird(title: title,color1: color1,color2: color2,)
        ),
        SizedBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kDoneColor, title: 'Close')

      ],
    );
  }
}


class OrdersRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          name: 'Date',
          textColor: kLightBrown,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),
        TextWidget(
          name: 'Orders',
          textColor: kLightBrown,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),
        //SizedBox(width: 5,),
        TextWidget(
          name: 'Amount',
          textColor: kLightBrown,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),
        //SizedBox(width: 1,),
      ],
    );


  }
}
