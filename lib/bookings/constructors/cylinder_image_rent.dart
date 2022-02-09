import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/bookings/constructors/new_cylinder_count.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
class CylinderImagesRent extends StatefulWidget {
  @override
  _CylinderImagesRentState createState() => _CylinderImagesRentState();

}

class _CylinderImagesRentState extends State<CylinderImagesRent> with TickerProviderStateMixin{
  double _height = 70.0.h;
  double _width = 50.0.w;
  bool _resized = false;
  static List<String> prices = <String>[];

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < Variables.cylinderImage.length; i++){
      Widget w = Column(
        children: [
          IconButton(

            icon: Variables.numItems.contains(Variables.newItems[i])?
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
                color: Variables.numItems.contains(Variables.newItems[i])?kLightBrown:Colors.transparent,
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


         TextWidgetAlign(
              name: '#${VariablesOne.numberFormat.format(Variables.cloud!['rent'][i])}/Mth',
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
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: getImages(),

    );
  }

  void addItems(int i) {

    if(Variables.cylinderCount > 1){

      if(Variables.numItems.contains(Variables.newItems[i])){
        setState(() {
          Variables.kGItems.remove(Variables.newItems[i]);
          Variables.numItems.remove(Variables.newItems[i]);
          Variables.selectedAmount.removeAt(i);
          Variables.headQuantityText.removeAt(i);
        });

      }else{

        //check the user so that the user will not select more than the number of cylinder
        if(Variables.numItems.length + 1 <= Variables.cylinderCount){
          setState(() {

            Variables.kGItems.add(Variables.newItems[i]);
            Variables.numItems.add(Variables.newItems[i]);

          });
          //this will get the price of the selected cylinder
          Variables.cP = Variables.cloud!['rent'][i];
          //the user will put how many for each

          showModalBottomSheet(
              isDismissible: false,
              isScrollControlled: true,
              context: context,
              builder: (context) => NewCylinderCount(title: 'Please select how many of this ${Variables.newItems[i].toString()}Kg cylinder you want to buy',)
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
          Variables.selectedAmount.remove(Variables.cloud!['rent'][i]);
        });

      }else{
        if(Variables.numItems.length + 1 <= Variables.cylinderCount){
          setState(() {

            Variables.kGItems.add(Variables.newItems[i]);
            Variables.numItems.add(Variables.newItems[i]);
            Variables.selectedAmount.add(Variables.cloud!['rent'][i]);
          });

        }else{
          Fluttertoast.showToast(
              msg: kSelectError,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: kBlackColor,
              textColor: kRedColor);
        }
      }
    }}

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
