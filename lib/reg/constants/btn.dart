import 'dart:io';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Btn extends StatelessWidget {
  Btn({required this.nextFunction, required this.bgColor,});
  final Function nextFunction;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 60.h,
      child:Platform.isIOS?

          CupertinoButton(
            onPressed: nextFunction as void Function(),
            color:bgColor,
            child: Text(kNextBtn,

              style:GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(22, ),
                color: kWhiteColor,
              ),
            ),
            borderRadius:  BorderRadius.circular(6.0),)

      :ElevatedButton(
        onPressed: nextFunction as void Function(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bgColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
              )
          )
        ),

        child: Text(kNextBtn,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),

      ),
    );
  }
}





class DoneBtn extends StatelessWidget {
  DoneBtn({required this.done, required this.bgColor,});
  final Color bgColor;
  final Function done;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 60.h,
      child:Platform.isIOS?

      CupertinoButton(
        onPressed: done as void Function(),
        color:bgColor,
        child: Text(kDone,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),
        borderRadius:  BorderRadius.circular(6.0),)

          :ElevatedButton(
        onPressed: done as void Function(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                )
            )
        ),
        child: Text(kDone,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),

      ),
    );
  }
}



class PopUpBtn extends StatelessWidget {
  PopUpBtn({required this.done, required this.bgColor,});
  final Color bgColor;
  final Function done;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.w,
      height: 40.h,
      child:Platform.isIOS?

      CupertinoButton(
        onPressed: done as void Function(),
        color:bgColor,
        child: Text(kDone,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),
        borderRadius:  BorderRadius.circular(6.0),)

          :ElevatedButton(
        onPressed: done as void Function(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                )
            )
        ),
        child: Text(kDone,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),

      ),
    );
  }
}


/*large buttons*/

class LocationBtn extends StatelessWidget {
  LocationBtn({required this.nextFunction, required this.bgColor,required this.title});
  final Function nextFunction;
  final Color bgColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.h,
      child:Platform.isIOS?

      CupertinoButton(
        onPressed: nextFunction as void Function(),
        color:bgColor,
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
          ),
        ),
        borderRadius:  BorderRadius.circular(6.0),)

          :ElevatedButton(
        onPressed: nextFunction as void Function(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                )
            )
        ),
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
          ),
        ),

      ),
    );
  }
}


class SizedBtn extends StatelessWidget {
  SizedBtn({required this.nextFunction, required this.bgColor,required this.title});
  final Function nextFunction;
  final Color bgColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200.w,
      height: 60.h,
      child:Platform.isIOS?

      CupertinoButton(
        onPressed: nextFunction as void Function(),
        color:bgColor,
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        borderRadius:  BorderRadius.circular(6.0),)

          :ElevatedButton(
        onPressed: nextFunction as void Function(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                )
            )
        ),
        child: Text(title,
           textAlign: TextAlign.center,
          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(20, ),
            color: kWhiteColor,
            fontWeight: FontWeight.w900,
          ),
        ),

      ),
    );
  }
}


class DoneVendor extends StatelessWidget {
  DoneVendor({required this.nextFunction, required this.bgColor,required this.title});
  final Function nextFunction;
  final Color bgColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 60.h,
      child:Platform.isIOS?

      CupertinoButton(
        onPressed: nextFunction as void Function(),
        color:bgColor,
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        borderRadius:  BorderRadius.circular(6.0),)

          :ElevatedButton(
        onPressed: nextFunction as void Function(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                )
            )
        ),
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontSize: ScreenUtil().setSp(kFontSize, ),
            color: kWhiteColor,
            fontWeight: FontWeight.w900,
          ),
        ),

      ),
    );
  }
}





class CylinderBtn extends StatelessWidget {
  CylinderBtn({required this.title, });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 100.w,
      decoration: BoxDecoration(

        shape: BoxShape.rectangle,

        border: Border.all(

          width: 2.0,

          color: kStatusColor,

        ),

        borderRadius: BorderRadius.circular(kKGBorder),

      ),
      child: Center(
        child: TextWidget(name: title,
          textColor: KkGColor,
          textSize: kKGSize,
          textWeight: FontWeight.w600,),
      ),
    );
  }
}




class ViewSelection extends StatelessWidget {
  ViewSelection({required this.title, });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 100.w,

      decoration: BoxDecoration(

        shape: BoxShape.rectangle,
        color: kDoneColor,
        border: Border.all(

          width: 2.0,

          color: kStatusColor,

        ),

        borderRadius: BorderRadius.circular(kKGBorder),

      ),
      child: Center(
        child: TextWidget(name: title,
          textColor: kWhiteColor,
          textSize: kKGSize,
          textWeight: FontWeight.w600,),
      ),
    );
  }
}






class BtnSecond extends StatelessWidget {
  BtnSecond({required this.nextFunction, required this.bgColor, required this.title});
  final Function nextFunction;
  final Color bgColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 60.h,
      child:Platform.isIOS?

      CupertinoButton(
        onPressed: nextFunction as void Function(),
        color:bgColor,
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),
        borderRadius:  BorderRadius.circular(6.0),)

          :ElevatedButton(
        onPressed: nextFunction as void Function(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                )
            )
        ),
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),

      ),
    );
  }
}



class BtnThird extends StatelessWidget {
  BtnThird({required this.nextFunction, required this.bgColor, required this.title});
  final Function nextFunction;
  final Color bgColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kHorizontal),
      width: double.infinity,
      height: 50.h,
      child:Platform.isIOS?

      CupertinoButton(
        onPressed: nextFunction as void Function(),
        color:bgColor,
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),
        borderRadius:  BorderRadius.circular(6.0),)

          :ElevatedButton(
        onPressed: nextFunction as void Function(),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                )
            )
        ),
        child: Text(title,

          style:GoogleFonts.oxanium(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(22, ),
            color: kWhiteColor,
          ),
        ),

      ),
    );
  }
}


class NewBtn extends StatelessWidget {
  NewBtn({required this.nextFunction, required this.bgColor, required this.title});
  final Function nextFunction;
  final Color bgColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS?

    CupertinoButton(
      onPressed: nextFunction as void Function(),
      color:bgColor,
      child: Text(title,

        style:GoogleFonts.oxanium(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(kFontSize ),
          color: kWhiteColor,
        ),
      ),
      borderRadius:  BorderRadius.circular(6.0),)

        :ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor)

        ),

        onPressed:nextFunction as void Function(),
        child:TextWidgetAlign(
          name:title,
          textColor: kWhiteColor,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ));

  }
}
