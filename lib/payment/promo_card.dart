import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromoConstruct extends StatefulWidget {
  @override
  _PromoConstructState createState() => _PromoConstructState();
}

class _PromoConstructState extends State<PromoConstruct> {
  Widget space() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  Widget spaceWidth() {
    return SizedBox(width: MediaQuery
        .of(context)
        .size
        .width * 0.05);
  }
  var itemsData = <dynamic>[];

  double elevation = 10.0;
  double horizontal = 10.0;
  double left = 70.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){_promo();},

          child: Card(
            elevation: elevation,
            color: kDullBlue,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  space(),
                  Row(
                    children: <Widget>[
                      space(),
                      Variables.currentUser[0]['mp'] == kPromo?
                      IconButton(icon: Icon(
                        Icons.radio_button_checked,color: kBlackColor,
                      ), onPressed: (){})

                          :IconButton(icon: Icon(
                        Icons.radio_button_unchecked,color: kWhiteColor,
                      ), onPressed: (){_promo();}),

                      spaceWidth(),
                      TextWidget(name:'Promo Account',
                        textColor: kWhiteColor,
                        textSize: 25,
                        textWeight: FontWeight.w500,),

                      spaceWidth(),

                      space(),
                    ],
                  ),
                  space(),
                  space(),


                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setSp(30)),
                    child: TextWidget(name:'Promo Balance',
                      textColor: kLightBrown,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,),
                  ),


                  Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setSp(30)),
                      child: MoneyFormatThird(
                        color: kWhiteColor,
                        title: TextWidget(name:VariablesOne.numberFormat.format(Variables.currentUser[0]['refact']).toString(),
                          textColor: kWhiteColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,),
                      )
                  ),

                  space(),
                  space(),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
  void _promo() {
    try{
      FirebaseFirestore.instance.collection('userReg').doc(Variables.userUid).set({
        'mp':kPromo,
      },SetOptions(merge: true));
     setState(() {
       Variables.currentUser[0]['mp'] = kPromo;
       Variables.mop = kPromo;
     });

      Navigator.pop(context);
      BotToast.showSimpleNotification(title: '$kPMtext $kPromo',
          backgroundColor: kBlackColor,
          duration: Duration(seconds: 5),

          titleStyle:TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil()
                .setSp(kFontSize, ),
            color: kGreenColor,
          ));


    }catch (e){
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }

  }

}
