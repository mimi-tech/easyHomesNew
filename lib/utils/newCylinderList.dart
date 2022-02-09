import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DetailsListNew extends StatefulWidget {
  DetailsListNew({required this.length,
    required this.image,
    required this.kg,
    required this.amt,
    required this.quantity});

  final List image;
  final List kg;
  final List quantity;
  final List length;
  final List amt;

  @override
  _DetailsListNewState createState() => _DetailsListNewState();
}

class _DetailsListNewState extends State<DetailsListNew> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        DividerLine(),
    spacer(),
        TextWidget(
          name: 'New Cylinder' ,
          textColor: kLightBrown,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),
        spacer(),
        ListView.builder(
            shrinkWrap: true,
            physics:  BouncingScrollPhysics(),
            itemCount: widget.length.length,
            itemBuilder: (context, int index) {


              return Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Column(
                  children: <Widget>[



                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Image(
                          image: AssetImage(widget.image[index].toString()),
                          width: MediaQuery.of(context).size.width *0.05,
                        ),


                        TextWidget(
                          name: widget.kg[index].toString()+'kg' + '  @ #'+ widget.amt[index].toString() ,
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        ),


                        TextWidget(
                          name: widget.quantity[index].toString(),
                          textColor: kTextColor,
                          textSize: kFontSize,
                          textWeight: FontWeight.bold,
                        ),
                      ],
                    ),

                    spacer(),
                  ],
                ),
              );


            }
        ),
      ],
    );

  }
}


class HeadRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextWidget(
            name: kHead,
            textColor: kDoneColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          TextWidget(
            name: kKg,
            textColor: kDoneColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          TextWidget(
            name: kQty,
            textColor: kDoneColor,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}



