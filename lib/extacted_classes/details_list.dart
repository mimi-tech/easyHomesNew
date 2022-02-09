import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DetailsList extends StatefulWidget {
  DetailsList({required this.length,
    required this.image,
    required this.kg,
    required this.quantity});

  final List image;
  final List kg;
  final List quantity;
  final List length;

  @override
  _DetailsListState createState() => _DetailsListState();
}

class _DetailsListState extends State<DetailsList> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
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
                      name: widget.kg[index].toString(),
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
    );

  }
}


class DetailsBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: RaisedButton(
        color: kDoneColor,
        onPressed: (){Navigator.pop(context);},
        child: TextWidget(
          name: kDone,
          textColor: kWhiteColor,
          textSize: kFontSize,
          textWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



