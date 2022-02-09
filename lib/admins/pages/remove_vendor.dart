import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class DeleteVendor extends StatefulWidget {
  DeleteVendor({required this.name,required this.confirm, required this.suspended});
  final String name;
  final Function confirm;
  final Function suspended;
  @override
  _DeleteVendorState createState() => _DeleteVendorState();
}

class _DeleteVendorState extends State<DeleteVendor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(

            alignment: Alignment.topRight,
            child: IconButton(
              onPressed:(){Navigator.pop(context);},
              icon: Icon(Icons.cancel,color: kBlackColor,size: 30,)
            )),

          TextWidget(
            name:  kShowDelete,
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          SizedBox(height: 20,),

          TextWidgetAlign(
            name:  "$kRequest ${widget.name}",
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.normal,
          ),



          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                color: kTextFieldBorderColor,
                onPressed: widget.suspended as void Function(),
                child: TextWidget(name: kSuspend.toUpperCase(),
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.normal,),
              ),
              FlatButton(
                color: kRedColor,
                onPressed: widget.confirm as void Function(),
                child: TextWidget(name: 'Remove'.toUpperCase(),
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.normal,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
