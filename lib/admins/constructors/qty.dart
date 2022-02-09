import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class BookingDetails extends StatelessWidget {
  BookingDetails({required this.kg,
    required this.qty,
    required this.type,
    required this.number,
    required this.rent,

  });

  final dynamic kg;
  final dynamic qty;
  final dynamic type;
  final dynamic number;
  final dynamic rent;


  Widget space(){
    return SizedBox(height:10.h);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal,vertical: 0),
      child: Column(
        children: <Widget>[
          space(),

         /* IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SvgPicture.asset(
                type.toString().trim(),
                height: detailsImageHeight,
                width: detailsImageWidth,
              ),
              Column(
                children: <Widget>[
                  TextWidget(
                    name: 'Type',
                    textColor: kBlackColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.bold,
                  ),
                  space(),
                  TextWidget(
                    name: number.toString(),
                    textColor: kBlackColor,
                    textSize: kFontSize12,
                    textWeight: FontWeight.bold,
                  ),

                ],
              ),
              VerticalLine(),
              SizedBox(width: kImageSpace.w,),
              Column(
                children: <Widget>[
                  TextWidget(
                    name: 'Kg',
                    textColor: kBlackColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.bold,
                  ),
                  space(),
                  TextWidget(
                    name: kg.toString(),
                    textColor: kBlackColor,
                    textSize: kFontSize12,
                    textWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(width: kImageSpace.w,),
              VerticalLine(),
              Column(
                children: <Widget>[
                  TextWidget(
                    name: 'Qty',
                    textColor: kBlackColor,
                    textSize: kFontSize14,
                    textWeight: FontWeight.bold,
                  ),
                  space(),
                  TextWidget(
                    name: qty.toString(),
                    textColor: kBlackColor,
                    textSize: kFontSize12,
                    textWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
      ),
          ),*/
          TextWidget(
            name: rent,
            textColor: kYellow,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),
          TextWidget(
            name: '$kg Tkg'.toUpperCase(),
            textColor: kBlackColor,
            textSize: kFontSize14,
            textWeight: FontWeight.bold,
          ),






        ],
      ),
    );
  }
}


class DateBookings extends StatelessWidget {
  DateBookings({required this.date,required this.time});
  final dynamic date;
  final dynamic time;
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          name: date,
          textColor: kRadioColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),
    TextWidget(
    name: time,
    textColor: kRadioColor,
    textSize: kFontSize14,
    textWeight: FontWeight.w500,
    ),


      ],
    );
  }
}


class CompanyName extends StatelessWidget {

  CompanyName({ required this.title});

  final dynamic title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextWidget(
          name: 'Station: ',
          textColor: kYellow,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),
        Container(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ScreenUtil()
                  .setWidth(200),
              minHeight: ScreenUtil()
                  .setHeight(20),
            ),
            child: ReadMoreText(title,
              trimLines: 1,
              colorClickableText: kLightBrown,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' ...',
              trimExpandedText: '  less',
              style: GoogleFonts.oxanium(
                  fontSize: ScreenUtil().setSp(kFontSize16, ),
                  color: kRadioColor,
                  fontWeight: FontWeight.w500

              ),
            ),
          ),
        ),
      ],
    );
  }
}


class AmountBooking extends StatelessWidget {
  AmountBooking({required this.amount});
  final dynamic amount;
  @override
  Widget build(BuildContext context) {
    return  TextWidget(
      name: '#${amount.toString()}',
      textColor: kSeaGreen,
      textSize: kFontSize14,
      textWeight: FontWeight.w500,
    );
  }
}

class AmountOrders extends StatelessWidget {
  AmountOrders({required this.amount, required this.mop,  required this.gas});
  final dynamic amount;
  final dynamic mop;
  final dynamic gas;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(
                name: 'PM: ',
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
              TextWidget(
                name: '${mop.toString()}',
                textColor: kLightBlue,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ],
          ),

          Row(
            children: [
              TextWidget(
                name: 'Gas: ',
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),

              MoneyFormatColors(
                color: kLightBrown,
                title: TextWidget(
                  name: ' ${VariablesOne.numberFormat.format(gas).toString()}',
                  textColor: kLightBrown,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Row(
            children: [

              TextWidget(
                name: 'gas ch: ',
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.normal,
              ),
              MoneyFormatColors(
                color: kSeaGreen,
                title: TextWidget(
                  name: '${VariablesOne.numberFormat.format(amount).toString()}',
                  textColor: kSeaGreen,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),



        ],
      ),
    );
  }
}



class AmountOrderNew extends StatelessWidget {
  AmountOrderNew({required this.amount,
    required this.mop,
    required this.gas,
    required this.cylinder,
    required this.total,
    required this.cye});
  final dynamic amount;
  final dynamic mop;
  final dynamic gas;
  final dynamic cylinder;
  final dynamic cye;
  final dynamic total;
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              name: 'PM: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),

            TextWidget(
              name: '${mop.toString()}',
              textColor: kLightBlue,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            TextWidget(
              name: 'Gas: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(gas).toString()}',
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          children: [

            TextWidget(
              name: 'Cy: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(cylinder).toString()}',
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          children: [

            TextWidget(
              name: 'Cy Ch: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(cye).toString()}',
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          children: [

            TextWidget(
              name: 'gas Ch: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kLightBrown,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(amount).toString()}',
                textColor: kLightBrown,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          children: [

            TextWidget(
              name: 'Total: ',
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.normal,
            ),
            MoneyFormatColors(
              color: kSeaGreen,
              title: TextWidget(
                name: ' ${VariablesOne.numberFormat.format(total).toString()}',
                textColor: kSeaGreen,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),




      ],
    );
  }
}


class NewBookingDetails extends StatelessWidget {
  NewBookingDetails({required this.kg,
    required this.qty,
    required this.type,
    required this.number,
    required this.kgs,
    required this.amt,
    required this.rent,
    required this.quantity,

  });

  final dynamic kg;
  final dynamic qty;
  final dynamic type;
  final dynamic number;
final dynamic amt;
final dynamic kgs;
final dynamic rent;
final dynamic quantity;


  Widget space(){
    return SizedBox(height:10.h);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextWidget(
          name: 'cy Size(s)'.toUpperCase(),
          textColor: kDoneColor,
          textSize: kFontSize14,
          textWeight: FontWeight.bold,
        ),


        TextWidget(
          name: kgs.toString(),
          textColor: kTextColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),
        SizedBox(height: 4,),
        TextWidget(
          name: 'cy Qty(s)'.toUpperCase(),
          textColor: kDoneColor,
          textSize: kFontSize14,
          textWeight: FontWeight.bold,
        ),
        TextWidget(
          name: quantity.toString(),
          textColor: kTextColor,
          textSize: kFontSize14,
          textWeight: FontWeight.w500,
        ),

      ],
    );
  }
}



