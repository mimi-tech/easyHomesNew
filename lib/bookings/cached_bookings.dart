import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/bookings/first_check/cylinder_qty.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/delivery_time.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CachedBookings extends StatefulWidget {

  @override
  _CachedBookingsState createState() => _CachedBookingsState();
}

class _CachedBookingsState extends State<CachedBookings> {

  static  List<dynamic> itemsData = <dynamic>[];
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();

  }
bool progress = false;
  List<Widget> getImages(){
    List<Widget> list =  <Widget>[];
    for(var i = 0; i < itemsData[0]['cKG'].length; i++){
      Widget w = Column(
        children: [
          SizedBox(width: 100,),
          TextWidgetAlign(
            name: '${itemsData[0]['cKG'][i].toString()}Kg',
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

  Widget mainBody(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [

            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: ('Dear '),
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kTextColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${Variables.userFN!},',
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kDoneColor,
                        ),
                      ),

                      TextSpan(
                        text: ' would you like to go by your previous order?',
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kTextColor,
                        ),
                      )
                    ]),
              ),
            ),


          ],
        ),
        Column(
          children: [
            AnimationSlide(title: TextWidgetAlign(
              name: kCylinderQtyText,
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
                    name:'${itemsData[0]['ca']}'.toString(),
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


        Wrap(
          alignment: WrapAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: getImages(),

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
                    name:  itemsData[0]['gk'] .toString(),
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            spacer(),
          ],
        ),

        YesNoBtn(no: (){_noNext();}, yes: (){_yesNext();})

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: BookingAppBar(title: Variables.buyingGasType!,),
        body: progress?Center(child: PlatformCircularProgressIndicator()):Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [

                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: ('Dear '),
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize, ),
                          color: kTextColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${Variables.userFN!},',
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize, ),
                              color: kDoneColor,
                            ),
                          ),

                          TextSpan(
                            text: ' would you like to go by your previous order?',
                            style: GoogleFonts.oxanium(
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil()
                                  .setSp(kFontSize, ),
                              color: kTextColor,
                            ),
                          )
                        ]),
                  ),
                ),


              ],
            ),
            Column(
              children: [
                AnimationSlide(title: TextWidgetAlign(
                  name: kCylinderQtyText,
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
                        name:'${itemsData[0]['ca']}'.toString(),
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


            Wrap(
              alignment: WrapAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: getImages(),

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
                        name:  itemsData[0]['gk'] .toString(),
                        textColor: kTextColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                spacer(),
              ],
            ),

YesNoBtn(no: (){_noNext();}, yes: (){_yesNext();})

          ],
        )));
  }

  Future<void> getDetails() async {
   /* final QuerySnapshot result  = await FirebaseFirestore.instance.collection("cachedBookings").where('id',isEqualTo: Variables.userUid).get();
    final List <DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {

    } else {

      for (DocumentSnapshot document in documents) {
        setState(() {
          itemsData.add(document.data());
        });
      }}*/
    try{
setState(() {
  progress = true;
});
      final snapShot = await FirebaseFirestore.instance.collection("cachedBookings").doc(Variables.userUid).get();

      //check if snapshot do exist
if(snapShot.exists == false){
  Navigator.pop(context);

  Platform.isIOS?
  showCupertinoModalPopup(

      context: context, builder: (BuildContext context) {

    return CupertinoActionSheet(
       messageScrollController: ScrollController(),
      message: CylinderQuantity(),

    );
  })
      :

  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) => CylinderQuantity());
}else{

      setState(() {
        itemsData.add(snapShot.data());
      });


setState(() {
  progress = false;
});}
    }catch (e){
         print(e);
         setState(() {
           progress = false;
         });
      _noNext();
    }

}

  void _noNext() {
    VariablesOne.checkOneTrue = true;
    Variables.cylinderCount = 1;

    Variables.numItems.clear();
    Variables.kGItems.clear();
    Variables.selectedAmount.clear();
    Variables.headQuantityText.clear();
    Variables.secondKGItems.clear();
    Variables.cytCounting.clear();
    Variables.totalGasKG = null;
    Variables.sumCylinder = 0;
    Variables.gasEstimatePrice = null;
    Variables.checkRent = false;
    Variables.buyCylinder = false;
    Variables.cylinderCount = 1;
    Variables.cylinderCountSecond = 1;
    Variables.checkCountShow = 0;
    Variables.cytCounting.clear();
    VariablesOne.doubleOrder = false;
    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          CylinderQuantity()
        ],
      );
    })

        : showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => CylinderQuantity()
    );
  }

  void _yesNext() {

    setState(() {


      Variables.totalGasKG = itemsData[0]['gk'];
      Variables.cylinderCount = itemsData[0]['ca'];
      Variables.grandTotal = Variables.totalGasKG * Variables.cloud!['gas'];
      Variables.gasEstimatePrice = Variables.totalGasKG * Variables.cloud!['gas'];
      Variables.headQuantityText =  List.from(itemsData[0]['cQ']);

      Variables.kGItems = List.from(itemsData[0]['cKG']);//widget.docs['cKG'];


      VariablesOne.checkOneTrue = true;
      VariablesOne.checkOneTrue2 = true;
    });

    Platform.isIOS ?
    /*show ios bottom modal sheet*/
    showCupertinoModalPopup(

        context: context, builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          DeliveryTime()
        ],
      );
    })

        : showModalBottomSheet(

        isScrollControlled: true,
        context: context,
        builder: (context) => DeliveryTime()
    );
  }
}
