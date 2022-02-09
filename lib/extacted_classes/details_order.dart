import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';

class DetailsOrder extends StatefulWidget {
  @override
  _DetailsOrderState createState() => _DetailsOrderState();
}

class _DetailsOrderState extends State<DetailsOrder> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  dynamic kgTotal;
dynamic cylinderTotal;

  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < Variables.kGItems.length; i++){
      Widget w = Column(
        children: [
          SizedBox(width: 100,),
          TextWidgetAlign(
            name: '${Variables.kGItems[i].toString()}Kg',
            textColor: kDoneColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),

          Variables.headQuantityText.length == 0 ?Text(''): TextWidgetAlign(
            name: '${Variables.headQuantityText[i].toString()}',
            textColor: kTextColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),
        ],

      );
      list.add(w);
    }
    return list;
  }

  List<Widget> getSecondKG(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < Variables.secondKGItems.length; i++){
      Widget w = Column(
        children: [
          SizedBox(width: 100,),
          TextWidgetAlign(
            name: '${Variables.secondKGItems[i].toString()}Kg',
            textColor: kDoneColor,
            textSize: kFontSize14,
            textWeight: FontWeight.w500,
          ),

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
    getDetails();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: BookingAppBar(title: Variables.buyingGasType!,),
        bottomNavigationBar:BottomAppBar(

          shape: CircularNotchedRectangle(),
          child: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Container(
              height: 56.0,
              color:kLightBrown,
              width: double.infinity,
              child:  Center(
                child: TextWidget(
                  name: 'Done'.toUpperCase(),
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            spacer(),
            Column(
              children: [
                AnimationSlide(title: TextWidgetAlign(
                  name:Variables.buyCylinder?'No of cylinder(s) you are buying': kCylinderQtyText,
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),),
                spacer(),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.065,
                    decoration: BoxDecoration(
                      border: Border.all(color: kRadioColor,),

                    ),

                    child:  Center(
                      child: TextWidgetAlign(
                        name: cylinderTotal.toString(),
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),
                    ),

                  ),
                )
              ],
            ),
      Divider(),
            Center(
              child:  AnimationSlide(title:
              Variables.checkRent?TextWidgetAlign(
                name:   'Rented cylinder sizes & quantity',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ):


              TextWidgetAlign(
                  name:   Variables.headQuantityText.length == 0 ?'Selected  cylinder sizes':'Selected new cylinder sizes & quantity',
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),
              ),
            ),

            Wrap(
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: getImages(),

      ),
            Center(
              child:  AnimationSlide(title:
              TextWidgetAlign(
                name:   Variables.secondKGItems.length == 0 ?'':'Selected own cylinder sizes',
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
              ),
            ),
            Wrap(
        direction: Axis.horizontal,
        children: getSecondKG(),

      ),
            Divider(),
            //spacer(),
           Column(
             children: [
               AnimationSlide(title:
                TextWidgetAlign(
                   name: 'Total gas kg ( LPG )',
                   textColor: kTextColor,
                   textSize: kFontSize,
                   textWeight: FontWeight.w500,
                 ),
               ),
               spacer(),
               Center(
                 child: Container(
                   width: MediaQuery.of(context).size.width * 0.4,
                   height: MediaQuery.of(context).size.height * 0.065,
                   decoration: BoxDecoration(
                     border: Border.all(color: kRadioColor,),

                   ),



                   child:  Center(
                     child: TextWidgetAlign(
                       name: Variables.buyCylinder?'0':Variables.totalGasKG.toString(),
                       textColor: kTextColor,
                       textSize: kFontSize,
                       textWeight: FontWeight.bold,
                     ),
                   ),
                 ),
               ),
               spacer(),
             ],
           )



          ],
        )));
  }

  void getDetails() {
   setState(() {
     if( VariablesOne.doubleOrder == true){
       cylinderTotal =  Variables.cylinderCount + Variables.cylinderCountSecond;

     }else{
       cylinderTotal =  Variables.cylinderCount;
     }
     kgTotal = Variables.kGItems.length + Variables.secondKGItems.length;
   });
  }
}
