import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class VendorLogsConstruct extends StatefulWidget {

  VendorLogsConstruct({
    required this.dailyNo,
    required this.dailyAmt,
    required this.weekNo,
    required this.weekAmt,
    required this.monthNo,
    required this.monthAmt,
    required this.yearNo,
    required this.yearAmt,

});

  final dynamic dailyNo;
  final dynamic dailyAmt;
  final dynamic weekNo;
  final dynamic weekAmt;
  final dynamic monthNo;
  final dynamic monthAmt;
  final dynamic yearNo;
  final dynamic yearAmt;

  @override
  _VendorLogsConstructState createState() => _VendorLogsConstructState();
}

class _VendorLogsConstructState extends State<VendorLogsConstruct> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DataTable(
          columnSpacing: MediaQuery.of(context).size.width*0.04,
          sortColumnIndex: 1,
          sortAscending: true,
          dataRowHeight: MediaQuery.of(context).size.width*0.2,
          dividerThickness: 5,
          columns: [
            DataColumn(

              label: Container(
                color: kLightBrown.withOpacity(0.2),

                child: Row(
                  children: <Widget>[
                    TextWidget(
                      name:'Periods',
                      textColor: kLightBrown,
                      textSize: kFontSize14,
                      textWeight: FontWeight.bold,
                    ),

                    Icon(Icons.arrow_drop_down,color: kLightBrown,)
                  ],
                ),
              ),),
            DataColumn(label:  Row(
              children: <Widget>[
                SvgPicture.asset('assets/imagesFolder/small_cy.svg',),

                TextWidget(
                  name:'Orders',
                  textColor: kTextColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,
                ),


              ],
            ),),

            DataColumn(label:TextWidget(
              name:'AMOUNT'.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize14,
              textWeight: FontWeight.bold,
            ),)

          ],
          rows: [
            DataRow(cells: [
              DataCell(TextWidget(
                name:'Today',
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),

              ),
              DataCell(TextWidget(
                name:widget.dailyNo,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),

              ),

              DataCell(TextWidget(
                name:widget.dailyAmt,
                textColor: kSeaGreen,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),

              ),
            ]
            ),
            DataRow(cells: [

              DataCell(TextWidget(
                name:kWeekly,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),
              ),
              DataCell(TextWidget(
                name: widget.weekNo,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),
              ),

              DataCell(TextWidget(
                name:widget.weekAmt,
                textColor: kSeaGreen,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),

              )]),

            DataRow(cells: [

              DataCell(TextWidget(
                name:kMonthly,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),
              ),
              DataCell(TextWidget(
                name: widget.monthNo,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),
              ),

              DataCell(TextWidget(
                name:widget.monthAmt,
                textColor: kSeaGreen,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),

              )]),
            DataRow(cells: [

              DataCell(TextWidget(
                name:kYearly,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),
              ),
              DataCell(TextWidget(
                name: widget.yearNo,
                textColor: kTextColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),
              ),

              DataCell(TextWidget(
                name:widget.yearAmt,
                textColor: kSeaGreen,
                textSize: kFontSize14,
                textWeight: FontWeight.w400,
              ),

              )]),



          ],

        ),
 SizedBox(height: 20.h,),
        SizedBtn(title: 'Done',nextFunction: (){Navigator.pop(context);},bgColor: kDoneColor,),
    SizedBox(height: 20.h,),
      ],
    );
  }
}





class SectaryLogs extends StatelessWidget {

  SectaryLogs({
    required this.image,
    required this.fn,
    required this.ln,
    required this.ph,
    required this.delete,
    required this.online,
    required this.biz,
    required this.call,
    required this.show,


  });
  final String image;
  final String fn;
  final String ln;
  final String ph;
  final Function delete;
  final Widget online;
  final String biz;
  final Function call;
  final bool show;


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: <Widget>[
        SizedBox(width:imageRightShift.w),
        ImageScreen(image: image,),
        SizedBox(width:imageRightShift.w),


        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              name: fn,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),

            TextWidget(
              name: ln,
              textColor: kRadioColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),

            TextWidget(
              name: biz.toUpperCase(),
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),


            GestureDetector(
              onTap: call as void Function(),
              child: TextWidget(
                name: ph,
                textColor: kLighterBlue,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Spacer(),

       online,



    AdminConstants.category == AdminConstants.admin.toLowerCase()
    ? Text('')
        : Visibility(
      visible: show,
          child: GestureDetector(
    onTap: delete as void Function(),
    child: Container(
    margin: EdgeInsets.symmetric(
    horizontal: kHorizontal),
    child: Icon(
    Icons.cancel, color: kDarkRedColor,)),
    ),
        )
      ],
    );
  }
}
class SalesLogs extends StatelessWidget {

  SalesLogs({
    required this.image,
    required this.fn,
    required this.ln,
    required this.ph,
    required this.delete,
    required this.online,
    required this.biz,
    required this.call,
    required this.show,
    required this.bizAdd,
    required this.bizCodes,



  });
  final String image;
  final String fn;
  final String ln;
  final String ph;
  final Function delete;
  final Widget online;
  final String biz;
  final String bizAdd;
  final String bizCodes;
  final Function call;
  final bool show;


  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: TextWidget(
            name: '$fn $ln',
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w500,
          ),
        ),
        Divider(),

        Row(
          children: <Widget>[
            SizedBox(width:imageRightShift.w),
            ImageScreen(image: image,),
            SizedBox(width:imageRightShift.w),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ReadMoreTextConstruct(title: biz, colorText: kTextColor),

                ReadMoreTextConstruct(title: bizAdd, colorText: kRadioColor),


                Row(
                  children: [
                    TextWidget(
                      name: 'Sales count'.toUpperCase(),
                      textColor: kTextColor,
                      textSize: kFontSize14,
                      textWeight: FontWeight.w500,
                    ),
                    SizedBox(width: 10,),
                    TextWidget(
                      name: bizCodes..toString().toUpperCase(),
                      textColor: kYellow,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: call as void Function(),
                  child: TextWidget(
                    name: ph,
                    textColor: kLighterBlue,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),


              ],
            ),
            Spacer(),

            online,



          ],
        ),

        Divider(),
        AdminConstants.category == AdminConstants.admin.toLowerCase()
            ? Text(''): Visibility(
          visible: show,

          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),

            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kLightBrown)

                ),

                onPressed:delete as void Function(),
                child:TextWidget(
                  name:'Remove',
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                )),
          ),
        ),
      ],
    );
  }
}


class AdminLogsConstruct extends StatelessWidget {

  AdminLogsConstruct({
    required this.image,
    required this.fn,
    required this.ln,
    required this.ph,
    required this.delete,
    required this.online,
    required this.biz,
    required this.call,
    required this.cancelColor,
  });
  final String image;
  final String fn;
  final String ln;
  final String ph;
  final Function delete;
  final Widget online;
  final String biz;
  final Function call;
  final bool cancelColor;


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: <Widget>[
        SizedBox(width:imageRightShift.w),
        ImageScreen(image: image,),
        SizedBox(width:imageRightShift.w),


        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              name: fn,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.w500,
            ),

            TextWidget(
              name: ln,
              textColor: kRadioColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),

            TextWidget(
              name: biz.toUpperCase(),
              textColor: kTextColor,
              textSize: kFontSize14,
              textWeight: FontWeight.w500,
            ),


            GestureDetector(
              onTap: call as void Function(),
              child: TextWidget(
                name: ph,
                textColor: kLighterBlue,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Spacer(),

        online,



        AdminConstants.category == AdminConstants.admin.toLowerCase()
            ? Text('')
            : Visibility(
          visible: cancelColor,
              child: GestureDetector(
          onTap: delete as void Function(),
          child: Container(

                margin: EdgeInsets.symmetric(
                    horizontal: 4),
                child: Icon(
                  Icons.cancel, color: kDarkRedColor,)),
        ),
            )
      ],
    );
  }
}
