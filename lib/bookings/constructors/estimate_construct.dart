import 'dart:io';

import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/bookings/constructors/total_cy.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EstimateConstruct extends StatefulWidget {
  EstimateConstruct({required this.kgTotal,required this.title, required this.size});
  final String kgTotal;
  final String title;
  final String size;
  @override
  _EstimateConstructState createState() => _EstimateConstructState();
}

class _EstimateConstructState extends State<EstimateConstruct> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  bool readOnly = false;
  bool checkList = false;
  TextEditingController _quantity = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        spacer(),
        AnimationSlide(
          title: Center(
            child: TextWidgetAlign(
              name: kEstimate.toUpperCase(),

              textColor: kDoneColor,
              textSize: 22,
              textWeight: FontWeight.bold,
            ),
          ),
        ),
        spacer(),
        SelectedRep(),
        spacer(),

        TotalCylinderConstruct(title: widget.size.toString(),),


        spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: AnimationSlide(
            title: Center(
              child: TextWidgetAlign(
                name: widget.title,

                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),

          ),
        ),

        /*AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: checkList?0.2 : 1.0,
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: RichText(
              text: TextSpan(
                  text: kFillUp,
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize, ),
                    color: kTextColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.kgTotal,
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil()
                            .setSp(kFontSize, ),
                        color: kLightBrown,
                      ),
                    ),

                        TextSpan(
    text: ' )',
    style: GoogleFonts.oxanium(
    fontWeight: FontWeight.w500,
    fontSize: ScreenUtil()
          .setSp(kFontSize, ),
    color: kTextColor,
    ),)

                  ]),
            ),
            value: Variables.isCheckedFill,
            onChanged: (bool value) {
              setState(() {
                Variables.isCheckedFill = value;

              });
              if(value){
                //Variables.buyingGasType = kCheck1;
               setState(() {
                 readOnly = true;
               });
              }else{
                setState(() {
                  readOnly = false;
                });
              }
              if(checkList == true){
                setState(() {
                  _quantity.text = '';
                  Variables.totalGasKG = '';
                  checkList = false;
                });
              }
            },
          ),
        ),
*/
        spacer(),
        Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),
            child: Platform.isIOS
                ? CupertinoTextField(
              controller: _quantity,
              autocorrect: true,
              readOnly: readOnly,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]'))
              ],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              cursorColor: (kTextFieldBorderColor),
              style: Fonts.textSize,
              placeholderStyle: GoogleFonts.oxanium(
                fontSize: ScreenUtil().setSp(
                    kFontSize, ),
                color: Variables.isCheckedFill?kHintColor: kRadioColor,
              ),
              placeholder: 'Total gas kg ( LPG )',
              onChanged: (String value) {
                Variables.totalGasKG = int.parse(value);
                if(_quantity.text.length != 0) {}
                },
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorder),
                  border: Border.all(color: kLightBrown)),
            )
                : TextField(
              controller: _quantity,
              autocorrect: true,
              readOnly: readOnly,
              cursorColor: (kTextFieldBorderColor),
              style: Fonts.textSize,
              keyboardType: TextInputType.numberWithOptions(decimal: true),

              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]'))
              ],
              decoration: InputDecoration(

                  hintText: 'Total gas kg ( LPG )',

                  hintStyle:GoogleFonts.oxanium(

                    textStyle: TextStyle(

                      fontSize: ScreenUtil().setSp(15, ),
                      color: Variables.isCheckedFill?kHintColor: kRadioColor,
                    )
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Variables.isCheckedFill?kHintColor:kRadioColor,width: 2),
                      borderRadius: BorderRadius.circular(kBorder)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: checkList?kHintColor:kLightBrown))



              ),
              onChanged: (String value) {
                Variables.totalGasKG = double.parse(value);
                /*if(_quantity.text.length == 0){
                  setState(() {
                    checkList = false;

                  });
                }else{
                  setState(() {
                    checkList = true;
                  });
                }*/
              },
            )),


      ],
    );
  }
}


class SelectedRep extends StatefulWidget {
  @override
  _SelectedRepState createState() => _SelectedRepState();
}

class _SelectedRepState extends State<SelectedRep> {

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
  @override
  Widget build(BuildContext context) {
    return   Wrap(
      alignment: WrapAlignment.spaceBetween,
      direction: Axis.horizontal,
      children: getImages(),

    );
  }
}
