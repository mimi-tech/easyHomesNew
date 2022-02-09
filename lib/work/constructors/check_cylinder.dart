import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/extacted_classes/order_details.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:flutter/material.dart';

class CheckCylinder extends StatefulWidget {

  @override
  _CheckCylinderState createState() => _CheckCylinderState();
}

class _CheckCylinderState extends State<CheckCylinder> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  @override
  Widget build(BuildContext context) {
    return Variables.transit!['acy'] != null
        ? Container(
      //width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius:
          BorderRadius.circular(6.0),
          border: Border.all(
            color: kRadioColor,
            width: 1.0,
          )),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: <Widget>[
          spacer(),

          Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: kPT,
                  textColor: kCartoonColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
                TextWidget(
                  name:
                  Variables.transit!['mp'],
                  textColor: kLightBrown,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          spacer(),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: kNC,
                  textColor: kCartoonColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
                MoneyFormatColors(
                  color: kLightBrown,
                  title: TextWidgetAlign(
                    name: '${VariablesOne.numberFormat.format(Variables.transit!['acy'])}',
                    textColor: kLightBrown,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),
                ),


              ],
            ),
          ),
          spacer(),
          Variables.transit!['aG'] == null ?Text(''):Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: kGP,
                  textColor: kCartoonColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
                MoneyFormatColors(
                  color: kLightBrown,
                  title: TextWidgetAlign(
                    name: '${VariablesOne.numberFormat.format(Variables.transit!['aG'])}',
                    textColor: kLightBrown,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),
          spacer(),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: kDF,
                  textColor: kCartoonColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),
                MoneyFormatColors(
                  color: kLightBrown,
                  title: TextWidgetAlign(
                    name: '${VariablesOne.numberFormat.format(Variables.transit!['df'])}',
                    textColor: kLightBrown,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),
          spacer(),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: kTotal,
                  textColor: kCartoonColor,
                  textSize: kFontSize14,
                  textWeight: FontWeight.w500,
                ),
                MoneyFormatColors(
                  color: kSeaGreen,
                  title: TextWidgetAlign(
                    name: '${VariablesOne.numberFormat.format(Variables.transit!['amt'])}',
                    textColor: kSeaGreen,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),
                ),
                /* TextWidget(
                                                    name: '#${Variables.transit!['amt']}'.toString(),
                                                    textColor: kSeaGreen,
                                                    textSize: kFontSize14,
                                                    textWeight: FontWeight.w500,
                                                  ),*/
              ],
            ),
          ),
          spacer(),
          Center(
            child: GestureDetector(
              onTap: () {
                showDetails();
              },
              child: TextWidget(
                name:
                kViewDetails.toUpperCase(),
                textColor: kLightDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ),
          spacer(),
        ],
      ),
    )
        : Container(
      width:
      MediaQuery.of(context).size.width *
          0.8,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius:
          BorderRadius.circular(6.0),
          border: Border.all(
            color: kRadioColor,
            width: 1.0,
          )

      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: <Widget>[
          spacer(),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: kDF,
                  textColor: kCartoonColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),


                MoneyFormatColors(
                  color: kLightBrown,
                  title: TextWidgetAlign(
                    name: '${VariablesOne.numberFormat.format(Variables.transit!['df'])}',
                    textColor: kLightBrown,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),



          spacer(),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: 'Gas price',
                  textColor: kCartoonColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),


                MoneyFormatColors(
                  color: kLightBrown,
                  title: TextWidgetAlign(
                    name: '${VariablesOne.numberFormat.format(VariablesOne.updatedOrderTrue?VariablesOne.changedGas:Variables.transit!['aG'])}',
                    textColor: kLightBrown,
                    textSize: kFontSize14,
                    textWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),

          spacer(),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: kTotal,
                  textColor: kCartoonColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),
                MoneyFormatColors(
                  color: kSeaGreen,
                  title: TextWidgetAlign(
                    name: '${VariablesOne.numberFormat.format(VariablesOne.updatedOrderTrue?VariablesOne.changedTotal:Variables.transit!['amt'])}',
                    textColor: kSeaGreen,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),
          ),
          spacer(),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: kHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  name: kPM,
                  textColor: kCartoonColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),
                TextWidget(
                  name: Variables.transit!['mp'],
                  textColor: kLightBrown,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          spacer(),

          Center(
            child: GestureDetector(
              onTap: () {
                //getPercentage();
                showDetails();
              },
              child: TextWidget(
                name: kViewDetails.toUpperCase(),
                textColor: kLightDoneColor,
                textSize: kFontSize14,
                textWeight: FontWeight.w500,
              ),
            ),
          ),
          spacer(),
        ],
      ),
    );
  }
  void showDetails() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => OrderVieDetails(docs:Variables.transit!)
    );
  }
}
