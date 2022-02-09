import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/bookings/first_check/qty_each.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CylinderImages extends StatefulWidget {
  @override
  _CylinderImagesState createState() => _CylinderImagesState();

}

class _CylinderImagesState extends State<CylinderImages> with TickerProviderStateMixin{
  double _height = 70.0.h;
  double _width = 50.0.w;
  bool _resized = false;
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < Variables.cylinderImage.length; i++){
      Widget w = Column(
        children: [
          PlatformIconButton(
          onPressed: () {
        addItems(i);
      },
            materialIcon: Variables.numItems.contains(Variables.newItems[i])?
      Icon(Icons.check_box_outlined,
        color: kLightBrown,
        key: ValueKey<int>(i),
      ):Icon(Icons.check_box_outline_blank,
        key: ValueKey<int>(i),
      ),
            cupertinoIcon: Variables.numItems.contains(Variables.newItems[i])?
    Icon(Icons.check_box_outlined,
    color: kLightBrown,
    key: ValueKey<int>(i),
    ):Icon(Icons.check_box_outline_blank,
    key: ValueKey<int>(i),
    ),
          ),

        GestureDetector(
          onTap: (){
            getSizes(i);
          },
          child: AnimatedSize(
            curve: Curves.easeIn,
            vsync: this,
            duration: Duration(milliseconds: 500),
            child: Container(
              width: _width,
              height:_height,
              color: Variables.numItems.contains(Variables.newItems[i])?kLightBrown:Colors.transparent,
              child: FadeInImage.assetNetwork(

                image: '${Variables.cylinderImage[i]}'.toString(),
                placeholder: 'assets/imagesFolder/loading4.gif',

                //placeholder: (context, url) => SvgPicture.asset('assets/imagesFolder/loading4.gif'),
                imageErrorBuilder: (context, url, error) => SvgPicture.asset('assets/imagesFolder/loading4.gif'),
                width: 50.0.w,
                height: 70.0.h,
                fit: BoxFit.cover,

              ),
            ),
          ),
        ),



          SizedBox(height: 10.h,),
          TextWidgetAlign(
            name: '${Variables.newItems[i].toString()}Kg',
            textColor: kDoneColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),
          SizedBox(width: 100.w,),
          SizedBox(height: 30.h,)
        ],

      );
      list.add(w);
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print()
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: getImages(),

    );
  }

  void addItems(int i) {

    if(Variables.cylinderCount > 1) {

      if(Variables.numItems.contains(Variables.newItems[i])){
      setState(() {
        Variables.kGItems.remove(Variables.newItems[i]);
        Variables.numItems.remove(Variables.newItems[i]);

        Variables.headQuantityText.removeAt(i);
      });

    }else{
      if(Variables.numItems.length + 1 <= Variables.cylinderCount) {
        setState(() {
          Variables.kGItems.add(Variables.newItems[i]);
          Variables.numItems.add(Variables.newItems[i]);
        });


        //ask how many to refill

        Variables.checkCountShow = i;

        showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            enableDrag: false,
            context: context,
            builder: (context) => QuantityEach(title: 'How many ${Variables.newItems[i].toString()}Kg cylinder are you refilling?',)
        );
      }else{
        Fluttertoast.showToast(
            msg: kSelectError,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: kBlackColor,
            textColor: kRedColor);
      }
    }
    }else{
      if(Variables.numItems.contains(Variables.newItems[i])){
        setState(() {
          Variables.kGItems.remove(Variables.newItems[i]);
          Variables.numItems.remove(Variables.newItems[i]);
        });

      }else{
        if(Variables.numItems.length + 1 <= Variables.cylinderCount) {
          setState(() {
            Variables.kGItems.add(Variables.newItems[i]);
            Variables.numItems.add(Variables.newItems[i]);
          });
        }else{
          Fluttertoast.showToast(
              msg: kSelectError,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackColor,
              textColor: kRedColor);
        }
      }
    }
  }

  void getSizes(int i) {
    //reSize.clear();
    if(_resized ){
setState(() {
  _resized = false;
  _height = 70.0;
  _width = 50.0;
});
    }else{

setState(() {
  _resized = true;

  _height = 150.0;
  _width = 100.0;
});
    }
  }
}
