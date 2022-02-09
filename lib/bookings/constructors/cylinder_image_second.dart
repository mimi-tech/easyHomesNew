import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SecondCylinderImages extends StatefulWidget {
  @override
  _SecondCylinderImagesState createState() => _SecondCylinderImagesState();

}

class _SecondCylinderImagesState extends State<SecondCylinderImages> with TickerProviderStateMixin{
  double _height = 70.0.h;
  double _width = 50.0.w;
  bool _resized = false;
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < Variables.cylinderImage.length; i++){
      Widget w = Column(
        children: [
          IconButton(

            icon: Variables.secondNumItems.contains(Variables.newItems[i])?
            Icon(Icons.check_box_outlined,
              color: kLightBrown,
              key: ValueKey<int>(i),
            ):Icon(Icons.check_box_outline_blank,
              key: ValueKey<int>(i),
            ),
            onPressed: () {
              addItems(i);
            },
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
                color: Variables.secondNumItems.contains(Variables.newItems[i])?kLightBrown:Colors.transparent,
                child: CachedNetworkImage(

                  imageUrl: '${Variables.cylinderImage[i]}'.toString(),
                  placeholder: (context, url) => SvgPicture.asset('assets/imagesFolder/loading4.gif'),
                  errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/loading4.gif'),
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
    if(Variables.secondNumItems.contains(Variables.newItems[i])){
      setState(() {
        Variables.secondKGItems.remove(Variables.newItems[i]);
        Variables.secondNumItems.remove(Variables.newItems[i]);
      });

    }else{
      if(Variables.secondNumItems.length + 1 <= Variables.cylinderCountSecond) {
        setState(() {
          Variables.secondKGItems.add(Variables.newItems[i]);
          Variables.secondNumItems.add(Variables.newItems[i]);
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
