import 'dart:io';

import 'package:easy_homes/bookings/constructors/bookings_appbar.dart';
import 'package:easy_homes/bookings/constructors/checkText.dart';
import 'package:easy_homes/bookings/first_check/cylinder_qty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/bookings/cached_bookings.dart';
import 'package:easy_homes/bookings/fifth_check/fifth_cylinder_qty.dart';
import 'package:easy_homes/bookings/fourth_check/fourth_cylinder_qty.dart';
import 'package:easy_homes/bookings/second_check/second_cylinder_qty.dart';
import 'package:easy_homes/bookings/sixth/sisth_cylinder_qty.dart';
import 'package:easy_homes/bookings/third_check/Third_cylinder_qty.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:page_transition/page_transition.dart';
class GasOrderType extends StatefulWidget {
  @override
  _GasOrderTypeState createState() => _GasOrderTypeState();
}

class _GasOrderTypeState extends State<GasOrderType>  {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.04);
  }
  Widget checkSpacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  bool _isChecked = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;
  bool _isChecked6 = false;

  bool progress = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
          bottomNavigationBar:BookingsBottomAppBar(nextColor: Variables.buyingGasType == null?kTextFieldBorderColor:kLightBrown,next: (){_checkType();},),
            appBar: AppBar(
              leading: IconButton(
                icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: kWhiteColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  SvgPicture.asset('assets/imagesFolder/pick_up.svg'),
                  TextWidget(
                    name: kGasTypeText.toUpperCase(),
                    // AdminConstants.bizName!.toUpperCase(),
                    textColor: kLightBrown,
                    textSize: kFontSize,
                    textWeight: FontWeight.w600,
                  ),

                ],
              ),
            ),
            body: ProgressHUDFunction(
              inAsyncCall: progress,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    spacer(),
                    TextWidget(
                      name: kServe.toUpperCase(),
                      // AdminConstants.bizName!.toUpperCase(),
                      textColor: kTextColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w600,
                    ),

                    spacer(),

                    Center(
                      child: TextWidgetAlign(
                        name: kSituation,
                        // AdminConstants.bizName!.toUpperCase(),
                        textColor: kLightBrown,
                        textSize: kFontSize,
                        textWeight: FontWeight.w500,
                      ),
                    ),
                    spacer(),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: CheckText(title: kCheck1,),
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                          _isChecked2 = false;
                          _isChecked3 = false;
                          _isChecked4 = false;
                          _isChecked5 = false;
                          _isChecked6 = false;
                        });
                        if(value!){
                          Variables.buyingGasType = kCheck1;

                        }
                      },
                    ),

                    checkSpacer(),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: CheckTextTwo(title: kCheck2),
                      value: _isChecked2,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked2 = value!;
                          _isChecked = false;
                          _isChecked3 = false;
                          _isChecked4 = false;
                          _isChecked5 = false;
                          _isChecked6 = false;
                        });
                        if(value!){
                          Variables.buyingGasType = kCheck2;

                        }
                      },
                    ),

                    checkSpacer(),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: CheckTextThree(title: kCheck3),
                      value: _isChecked3,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked3 = value!;
                          _isChecked2 = false;
                          _isChecked = false;
                          _isChecked4 = false;
                          _isChecked5 = false;
                          _isChecked6 = false;
                        });
                        if(value!){
                          Variables.buyingGasType = kCheck3;

                        }
                      },
                    ),

                    checkSpacer(),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: CheckTextFour(title: kCheck4),
                      value: _isChecked4,
                      onChanged: (bool? value) {
                        print('bnbn');
                        setState(() {
                          _isChecked4 = value!;
                          _isChecked2 = false;
                          _isChecked3 = false;
                          _isChecked = false;
                          _isChecked5 = false;
                          _isChecked6 = false;
                        });
                        if(value!){
                          Variables.buyingGasType = kCheck4;

                        }
                      },
                    ),

                    checkSpacer(),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: CheckTextFive(title: kCheck5),
                      value: _isChecked5,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked5 = value!;
                          _isChecked2 = false;
                          _isChecked3 = false;
                          _isChecked4 = false;
                          _isChecked = false;
                          _isChecked6 = false;
                        });
                        if(value!){
                          Variables.buyingGasType = kCheck5;

                        }
                      },
                    ),
                    checkSpacer(),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: CheckTextSix(title: kCheck6),
                      value: _isChecked6,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked6 = value!;
                          _isChecked2 = false;
                          _isChecked3 = false;
                          _isChecked4 = false;
                          _isChecked5 = false;
                          _isChecked = false;
                        });
                        if(value!){
                          Variables.buyingGasType = kCheck6;

                        }
                      },
                    ),

                    spacer(),

                  ],
                ),


              ),
            )));
  }

  Future<void> _checkType() async {
    //clear the selected list
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
    Constant1.checkGasService = false;
    VariablesOne.checkOneTrue = false;
    VariablesOne.checkOneTrue2 = false;
    if(Variables.buyingGasType == null){

      Fluttertoast.showToast(
          msg: 'Please select the service you want',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }else{


      if(_isChecked){
        setState(() {
          VariablesOne.checkOne = 'One';
          progress = true;
        });
        //check if customer have selected any of them
        final snapShot = await FirebaseFirestore.instance.collection("cachedBookings").doc(Variables.userUid).get();

        if (snapShot == null || !snapShot.exists) {
          print('jjjjjjjjjjj');
         setState(() {
           progress = false;
           VariablesOne.checkOneTrue = true;

         });

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
        } else {
          //snapshot  exist
          checkSelected(snapShot);
        }
      }else if(_isChecked2){
        Platform.isIOS ?
        /*show ios bottom modal sheet*/
        showCupertinoModalPopup(

            context: context, builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              SecondCylinderQuantity()
            ],
          );
        })

            : showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            context: context,
            builder: (context) => SecondCylinderQuantity()
        );

      }else if(_isChecked3){
        VariablesOne.doubleOrder = true;

        Platform.isIOS ?
        /*show ios bottom modal sheet*/
        showCupertinoModalPopup(

            context: context, builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              ThirdCylinderQuantity()
            ],
          );
        })

            : showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            context: context,
            builder: (context) => ThirdCylinderQuantity()
        );



      }else if(_isChecked4){

        Variables.checkRent = true;

        Platform.isIOS ?
        showCupertinoModalPopup(

            context: context, builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              FourthCylinderQuantity()
            ],
          );
        })

            : showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            context: context,
            builder: (context) => FourthCylinderQuantity()
        );



      }else if(_isChecked5){

        Variables.checkRent = true;
        VariablesOne.doubleOrder = true;
        Platform.isIOS ?
        /*show ios bottom modal sheet*/
        showCupertinoModalPopup(

            context: context, builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              FifthCylinderQuantity()
            ],
          );
        })

            : showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            context: context,
            builder: (context) => FifthCylinderQuantity()
        );



      }else if(_isChecked6){

        Variables.buyCylinder = true;
        Platform.isIOS ?
        showCupertinoModalPopup(

            context: context, builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              SixthCylinderQuantity()
            ],
          );
        })

            : showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            context: context,
            builder: (context) => SixthCylinderQuantity()
        );
      }

  }
  }
void checkSelected(DocumentSnapshot snapShot){

  setState(() {
    progress = false;
   /* VariablesOne.checkOneTrue = true;
    VariablesOne.checkOneTrue2 = true;*/

  });


/*  Navigator.push(context, PageTransition(
      type: PageTransitionType.scale,
      alignment: Alignment.bottomCenter,
      child: CachedBookings(docs:snapShot)));*/
  }

}


