
import 'package:easy_homes/admins/pages/page_constants.dart';
import 'package:easy_homes/admins/pages/tabs/show_company_admins.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class AdminLogTabSecond extends StatefulWidget {
  AdminLogTabSecond({

    required this.online,
    required this.offline,
    required this.title,

    required this.secName,


  });

 final String title;
  final String online;
  final String offline;
  final String secName;


  @override
  _AdminLogTabSecondState createState() => _AdminLogTabSecondState();
}

class _AdminLogTabSecondState extends State<AdminLogTabSecond> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          space(),
          space(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[



              GestureDetector(

                child: TextWidget(
                  name: widget.secName.toUpperCase(),
                  textColor: kHintColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  elevation: kLogsElevation,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset('assets/imagesFolder/green_dot.svg'),
                        SizedBox(width: 10,),
                        TextWidget(
                          name: widget.online,
                          textColor: kDoneColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        ),


                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  elevation: kLogsElevation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset('assets/imagesFolder/grey_dot.svg'),
                      SizedBox(width: 10,),
                      TextWidget(
                        name: widget.offline,
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),


                    ],
                  ),
                ),
              )
            ],
          ),
          space(),
          Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextWidget(
                name: widget.title,
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
              Spacer(),
              SvgPicture.asset('assets/imagesFolder/clock.svg',color: kDoneColor,),
              SizedBox(width: 40.w,),
              Icon(Icons.remove_circle,color: kDoneColor,size: 18,)
            ],
          ),
          Divider()
        ],
      ),
    );
  }


}




class AdminLogTabThird extends StatefulWidget {
  AdminLogTabThird({

    required this.title,
    required this.online,
    required this.offline,
    required this.salesName,





  });

  final String title;
  final String online;
  final String offline;
  final String salesName;

  @override
  _AdminLogTabThirdState createState() => _AdminLogTabThirdState();
}

class _AdminLogTabThirdState extends State<AdminLogTabThird> {
  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          space(),
          space(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[


              GestureDetector(
                child: TextWidget(
                  name: widget.salesName.toUpperCase(),
                  textColor: kLightBrown,
                  textSize: kFontSize14,
                  textWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  elevation: kLogsElevation,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset('assets/imagesFolder/green_dot.svg'),
                        SizedBox(width: 10,),
                        TextWidget(
                          name: widget.online,
                          textColor: kDoneColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        ),


                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Card(
                  elevation: kLogsElevation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset('assets/imagesFolder/grey_dot.svg'),
                      SizedBox(width: 10,),
                      TextWidget(
                        name: widget.offline,
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),


                    ],
                  ),
                ),
              )
            ],
          ),
          space(),
          Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextWidget(
                name: widget.title,
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
              Spacer(),
              SvgPicture.asset('assets/imagesFolder/clock.svg',color: kDoneColor,),
              SizedBox(width: 40.w,),
              Icon(Icons.remove_circle,color: kDoneColor,size: 18,)
            ],
          ),
          Divider()
        ],
      ),
    );
  }


}

