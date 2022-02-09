import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/cupertinoRadioClass.dart';
import 'package:easy_homes/extacted_classes/date_time/date_time_picker_widget2.dart';
import 'package:easy_homes/extacted_classes/date_time/notifiaction_dialog.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/check_location.dart';
import 'package:easy_homes/reg/screens/select_company.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
class DeliveryTime extends StatefulWidget {
  @override
  _DeliveryTimeState createState() => _DeliveryTimeState();
}

class _DeliveryTimeState extends State<DeliveryTime> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  int? selectedRadio;
  bool date = true;
  bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Timer.periodic(Duration(seconds: 2), (Timer t) => setState((){}));
    bool checkDate = Variables.selectedDate.isAfter(DateTime.now());

if(checkDate) {
  selectedRadio = 2;
}else{
  selectedRadio = 1;

}

    if(selectedRadio == 1){
      date = false;
    }
  }

  Color radioColor1 = kBlackColor;
  Color radioColor2 = kRadioColor;
//bool _moveToNext = false;
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    child: Column(
    children: <Widget>[

      spacer(),
      AnimationSlide(title: TextWidgetAlign(name: 'Date & time of delivery'.toUpperCase(),
        textColor: kLightBrown,
        textSize: 20,
        textWeight: FontWeight.bold,),),

      spacer(),

      /*Time for delivery*/


     /* Row(
        children: [
          PlatformIconButton(
            onPressed: (){
              setState(() {
                radioColor1 = kBlackColor;
                radioColor2 = kRadioColor;
                date = false;
                Variables.selectedDate = DateTime.now();
              });
            },
            cupertinoIcon: Icon(CupertinoIcons.circle),


          ),
          GestureDetector(
            onTap: (){
              setSelectedRadio(1);

              setState(() {
                radioColor2 = kBlackColor;
                radioColor1 = kRadioColor;
                date = false;
              });
            },
            child: TextWidget(
              name: 'Your gas will be delivered now',//kDeliver,
              textColor: radioColor1,
              textSize: kFontSize,
              textWeight: FontWeight.w600,
            ),
          ),

          *//*current date and time*//*


        ]
      ),*/

      Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: kFontSize14.toDouble(),),
        child: Row(
          children: <Widget>[
            Text('${Variables.dateFormat2.format(Variables.selectedDate)} : ${Variables.dateFormat3.format(Variables.selectedDate)}',
                style: GoogleFonts.oxanium(
                    textStyle: TextStyle(
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                    )
                )
            ),

          ],
        ),
      ),
      DividerLine(),

      progress == true?
      PlatformCircularProgressIndicator()
          : Btn(
          bgColor: kLightBrown,
          nextFunction: () {
            /*check if user have selected any cylinder*/
            getLocation();

          }),
      SizedBox(height: 12.0.h),

          /*PlatformIconButton(
            onPressed: (){
              setState(() {
                radioColor2 = kBlackColor;
                radioColor1 = kRadioColor;
                date = true;
              });
              Platform.isIOS?

              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: kWhiteColor,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextWidget(
                              name: 'Select date & time'.toUpperCase(),
                              textColor: kDarkBlue,
                              textSize: kFontSize,
                              textWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            height: 400,
                            child: CupertinoDatePicker(
                              backgroundColor: kWhiteColor,
                              initialDateTime: DateTime.now(),
                              onDateTimeChanged: (dateTime) async {
                                Variables.selectedDate = dateTime ;
                              },
                            ),
                          ),
                          NewBtn(nextFunction:(){
                            Navigator.pop(context);
                          }, bgColor: kLightBrown, title: 'OK')
                        ],
                      ),
                    );})


                  :
              showDateTimeDialog(context, initialDate: Variables.selectedDate,
                  onSelectedDate: (selectedDate) {
                    setState(() {
                      Variables.selectedDate = selectedDate ;
                    });
                  });
            },
            cupertinoIcon: Icon(CupertinoIcons.circle),


          ),*/
          // DateTimePickerWidget2(
          //   title: date ? kLater : kLater,
          //   textColor: radioColor2,
          //   dateCallback: (){
          //
          //     showDateTimeDialog(context, initialDate: Variables.selectedDate,
          //         onSelectedDate: (selectedDate) {
          //
          //           setSelectedRadio(2);
          //
          //           setState(() {
          //             radioColor2 = kBlackColor;
          //             radioColor1 = kRadioColor;
          //             date = true;
          //             Variables.selectedDate = selectedDate ;
          //           });
          //
          //         });
          //   },
          //
          // ),
        ],
      )
          /*:ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Radio(
                value: 1,
                groupValue: selectedRadio,
                activeColor: kBlackColor,
                onChanged: (dynamic val) {
                  setSelectedRadio(val);

                  setState(() {
                    radioColor1 = kBlackColor;
                    radioColor2 = kRadioColor;
                    date = false;
                    Variables.selectedDate = DateTime.now();
                  });
                },
              ),
              GestureDetector(
                onTap: (){
                  setSelectedRadio(1);

                  setState(() {
                    radioColor2 = kBlackColor;
                    radioColor1 = kRadioColor;
                    date = false;
                  });
                },
                child: TextWidget(
                  name: kDeliver,
                  textColor: radioColor1,
                  textSize: kFontSize,
                  textWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 2,
                groupValue: selectedRadio,
                activeColor: kBlackColor,
                onChanged: (dynamic val) {
                  setSelectedRadio(val);

                  setState(() {
                    radioColor2 = kBlackColor;
                    radioColor1 = kRadioColor;
                    date = true;
                  });
                         showDateTimeDialog(context, initialDate: Variables.selectedDate,
                      onSelectedDate: (selectedDate) {
                        setState(() {
                          Variables.selectedDate = selectedDate ;
                        });
                      });
                },
              ),*/
             /* TextWidget(
                name: kLater,
                textColor: radioColor2,
                textSize: kFontSize,
                textWeight: FontWeight.w600,
              ),*/

              // DateTimePickerWidget2(
              //   title: date ? kLater : kLater,
              //   textColor: radioColor2,
              //   dateCallback: (){
              //     showDateTimeDialog(context, initialDate: Variables.selectedDate,
              //         onSelectedDate: (selectedDate) {
              //
              //           setSelectedRadio(2);
              //
              //           setState(() {
              //             radioColor2 = kBlackColor;
              //             radioColor1 = kRadioColor;
              //             date = true;
              //             Variables.selectedDate = selectedDate ;
              //           });
              //
              //         });
              //   },
              //
              // ),

          ));



  }

  Future<void> getLocation() async {
    setState(() {
      progress = true;
    });


      if ((Variables.buyerAddress == null) || (Variables.buyerAddress == '')) {
        setState(() {
          progress = false;
        });
        /*location service not enabled*/
        Navigator.pop(context);

        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CheckLocation()));


      } else {
        setState(() {
          progress = false;
        });
        Navigator.pop(context);

        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SelectCompany()));

        //check if date is true and set
        // if(date == true){
        //   bool checkDate = Variables.selectedDate.isAfter(DateTime.now());
        //
        //     if(checkDate == true){
        //       Navigator.pop(context);
        //
        //       Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SelectCompany()));
        //
        //     }else{
        //       BotToast.showSimpleNotification(title: "Please set the date and time your order would be delivered to you",
        //           duration: Duration(seconds: 10),
        //           backgroundColor: kBlackColor,
        //           titleStyle:TextStyle(
        //
        //             fontWeight: FontWeight.w500,
        //             fontSize: ScreenUtil()
        //                 .setSp(kFontSize, ),
        //             color: kRedColor,
        //           )
        //
        //       );
        //     }
        // }else{
        //   Navigator.pop(context);
        //
        //   Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SelectCompany()));
        //
        // }

      }

    }

  }

