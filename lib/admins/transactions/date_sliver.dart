import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/transactions/failed_trans.dart';
import 'package:easy_homes/admins/transactions/fromTo.dart';
import 'package:easy_homes/admins/transactions/paymentList.dart';
import 'package:easy_homes/admins/transactions/success_trans.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/reg/constants/btn.dart';

import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SilverAppBarTransDate extends StatefulWidget implements PreferredSizeWidget{

  @override
  _SilverAppBarTransDateState createState() => _SilverAppBarTransDateState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);

}

class _SilverAppBarTransDateState extends State<SilverAppBarTransDate> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedExpiredDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        forceElevated: true,
        shape:  RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0),
            )
        ),
        backgroundColor: kDoneColor,
        pinned: false,
        automaticallyImplyLeading: false,
        floating: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: <Widget>[


             GestureDetector(
               onTap: (){_fromDate(context);},
               child: Row(
                 children: [
                   Icon(Icons.calendar_today,color: kWhiteColor,),

                   TextWidget(
                     name: 'From',
                     textColor: kWhiteColor,
                     textSize: 16,
                     textWeight: FontWeight.bold,
                   ),
                 ],
               ),
             ),

              GestureDetector(
                onTap: (){_toDate(context);},

                child: Row(
                  children: [
                    Icon(Icons.calendar_today,color: kWhiteColor,),
                    TextWidget(
                      name: 'To',
                      textColor: kWhiteColor,
                      textSize: 16,
                      textWeight: FontWeight.bold,
                    ),
                  ],
                ),
              )



            ]
        )
    );
  }

  Future<void> _fromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(2010),
        lastDate: DateTime(2080),
        helpText: 'From',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        fieldLabelText: 'From date',
        fieldHintText: 'Month/Date/Year',

        /*builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.dark(
                primary: kSeaGreen,
                onPrimary: Colors.white,
                surface: kSeaGreen,
                onSurface: kBlackColor,


              ),
              dialogBackgroundColor: kWhiteColor,
            ),
            child: child,
          );
        }*/

    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        /*Timestamp myTimeStamp = Timestamp.fromDate(selectedDate);
        TransactionDate.selectedDateTransFrom = myTimeStamp.millisecondsSinceEpoch as Timestamp;
        print(TransactionDate.selectedDateTransFrom );*/
        TransactionDate.pickedDateTransFrom = "${selectedDate.toLocal()}".split(' ')[0];
print(TransactionDate.pickedDateTransFrom);
      });
  }


  Future<void> _toDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedExpiredDate, // Refer step 1
        firstDate: DateTime(2010),
        lastDate: DateTime(2030),
        helpText: 'To transaction',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        fieldLabelText: 'To date',
        fieldHintText: 'Month/Date/Year',


       /* builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.dark(
                primary: kSeaGreen,
                onPrimary: Colors.white,
                surface: kSeaGreen,
                onSurface: kBlackColor,


              ),
              dialogBackgroundColor: kWhiteColor,
            ),
            child: child,
          );*/


    );
    if (picked != null && picked != selectedExpiredDate)
      setState(() {

        selectedExpiredDate = picked;
        Timestamp myTimeStamp = Timestamp.fromDate(selectedExpiredDate);
        TransactionDate.selectedDateTransTo = myTimeStamp;
        TransactionDate.pickedDateTransTo = "${selectedExpiredDate.toLocal()}".split(' ')[0];

      });
  }


}


class TransactionDate{
  static Timestamp? selectedDateTransFrom;
  static String? pickedDateTransFrom;

  static Timestamp? selectedDateTransTo;
  static String? pickedDateTransTo;

}