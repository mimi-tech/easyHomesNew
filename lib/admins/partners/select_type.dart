import 'dart:io';

import 'package:easy_homes/admins/partners/create_businessPin.dart';
import 'package:easy_homes/admins/partners/verify_sales.dart';
import 'package:easy_homes/admins/partners/verify_user.dart';
import 'package:easy_homes/admins/verify_sec.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SelectType extends StatefulWidget {
  @override
  _SelectTypeState createState() => _SelectTypeState();
}
Widget space(){
  return SizedBox(height:10.h);
}
Widget selectCategory(BuildContext context){
  if( AdminConstants.category == 'owner'){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Platform.isIOS?showCupertinoModalPopup(

                context: context, builder: (BuildContext context) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  VerifySales()
                ],
              );
            }):showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => VerifySales()
            );

          },
          child: TextWidget(name: kCAS,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,),

        ),
        space(),
        GestureDetector(
           onTap: (){
  if (AdminConstants.noAdminCreated >= 2) {
Navigator.pop(context);
  showAnimatedDialog(
  context: context,
  barrierDismissible: true,
  builder: (BuildContext context) {
  return ClassicGeneralDialogWidget(
  titleText: 'Number of secretary exceeded',
  contentText: 'Sorry you have exceeded the number of secretary you are to have Thanks.',
  onPositiveClick: () {
  Navigator.of(context).pop();
  },
  onNegativeClick: () {
  Navigator.of(context).pop();
  },
  actions: [
  NewBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kRedColor, title: 'Ok')
  ],
  );
  },
  animationType: DialogTransitionType.slideFromBottomFade,
  curve: Curves.fastOutSlowIn,
  duration: Duration(seconds: 1),
  );

  } else {
             Navigator.pop(context);
             Platform.isIOS?showCupertinoModalPopup(

                 context: context, builder: (BuildContext context) {
               return CupertinoActionSheet(
                 actions: <Widget>[
                   VerifySec()
                 ],
               );
             }):showModalBottomSheet(
                 isScrollControlled: true,
                 context: context,
                 builder: (context) => VerifySec()
             );

           }},
          child: TextWidget(name: kCAP,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,),

        ),
        space(),
        GestureDetector(
onTap: (){
  Navigator.pop(context);
  Platform.isIOS?showCupertinoModalPopup(

      context: context, builder: (BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CreateBusinessPin()
      ],
    );
  }):showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => CreateBusinessPin()
  );

},
          child: TextWidget(name: kCBs,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,),

        ),
        space(),
        GestureDetector(

          onTap: (){
           Navigator.pop(context);
           Platform.isIOS?showCupertinoModalPopup(

               context: context, builder: (BuildContext context) {
             return CupertinoActionSheet(
               actions: <Widget>[
                 VerifyUser()
               ],
             );
           }):showModalBottomSheet(
               isScrollControlled: true,
               context: context,
               builder: (context) => VerifyUser()
           );

          },

          child: TextWidget(name: kCP,
            textColor: kDoneColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,),

        ),


      ],
    );
  }else if(AdminConstants.category == AdminConstants.partner){
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Platform.isIOS?showCupertinoModalPopup(

                context: context, builder: (BuildContext context) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  VerifySales()
                ],
              );
            }):showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => VerifySales()
            );

          },
          child: TextWidget(name: kCAS,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,),

        ),
        /*create Admin pin from partner*/

        space(),
        GestureDetector(
          onTap: ()
    {
      if (AdminConstants.noAdminCreated >= 20) {

        showAnimatedDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ClassicGeneralDialogWidget(
              titleText: 'Secretary Exceeded',
              contentText: 'Sorry you have exceeded the number of secretary you are to have Thanks.',
              onPositiveClick: () {
                Navigator.of(context).pop();
              },
              onNegativeClick: () {
                Navigator.of(context).pop();
              },
              actions: [
                NewBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kRedColor, title: 'Ok')
              ],
            );
          },
          animationType: DialogTransitionType.slideFromBottomFade,
          curve: Curves.fastOutSlowIn,
          duration: Duration(seconds: 1),
        );

      } else {
        Navigator.pop(context);
        Platform.isIOS ? showCupertinoModalPopup(

            context: context, builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              VerifySec()
            ],
          );
        }): showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => VerifySec()
        );
      }

  },

          child: TextWidget(name: kCAP,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,),

        ),
        space(),
        GestureDetector(
          /*creating  a business pin*/
          onTap: (){
            Navigator.pop(context);
            Platform.isIOS?showCupertinoModalPopup(

                context: context, builder: (BuildContext context) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  CreateBusinessPin()
                ],
              );
            }):showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => CreateBusinessPin()
            );

          },


          child: TextWidget(name: kCBs,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,),

        ),

      ],
    );
  }else if(AdminConstants.category == AdminConstants.business){
    return  Column(
      children: <Widget>[

        space(),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Platform.isIOS?showCupertinoModalPopup(

                context: context, builder: (BuildContext context) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  VerifySales()
                ],
              );
            }):showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => VerifySales()
            );

          },
          child: TextWidget(name: kCAS,
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,),

        ),
        space(),
        GestureDetector(

      onTap: (){
  if (AdminConstants.noAdminCreated >= 20) {

  showAnimatedDialog(
  context: context,
  barrierDismissible: true,
  builder: (BuildContext context) {
  return ClassicGeneralDialogWidget(
  titleText: 'Number of secretary exceeded',
  contentText: 'Sorry you have exceeded the number of secretary you are to have Thanks.',
  onPositiveClick: () {
  Navigator.of(context).pop();
  },
  onNegativeClick: () {
  Navigator.of(context).pop();
  },
  actions: [
  NewBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kRedColor, title: 'Ok')
  ],
  );
  },
  animationType: DialogTransitionType.slideFromBottomFade,
  curve: Curves.fastOutSlowIn,
  duration: Duration(seconds: 1),
  );}else{
        Platform.isIOS?showCupertinoModalPopup(

            context: context, builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              VerifySec()
            ],
          );
        }):showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => VerifySec()
        );

      }},
    child: TextWidget(name: kCAP,
      textColor: kTextColor,
      textSize: kFontSize,
      textWeight: FontWeight.w600,),
  )
  ]
  );

}else{
    return Text('');
  }
}



class _SelectTypeState extends State<SelectType> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 600),
        curve: Curves.decelerate,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              space(),
              space(),
              Platform.isIOS?Container():TextWidgetAlign(name: kAccessType.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,),

              space(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: selectCategory(context),
                  ),
                ],
              ),
              space(),

            ],
          ),
        ),
      ),
    );
  }
}
