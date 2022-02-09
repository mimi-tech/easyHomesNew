import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class PopOut extends StatefulWidget {
  PopOut({required this.pop});
  final Function pop;
  @override
  _PopOutState createState() => _PopOutState();
}

class _PopOutState extends State<PopOut> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right:18.0,left:18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              color:kLightBrown,
              child: Text('Cancel',
                  style:TextStyle(
                    fontSize: ScreenUtil()
                        .setSp(20,
                        ),
                    color: kBlackColor,
                    fontFamily: 'Rajdhani',

                  )),
              shape: RoundedRectangleBorder(
                borderRadius:
                new BorderRadius.circular(4.0),),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text('Done',
                  style:TextStyle(
                    fontSize: ScreenUtil()
                        .setSp(20,
                        ),
                    color: kBlackColor,
                    fontFamily: 'Rajdhani',

                  )),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.circular(4.0),
                  side:
                  BorderSide(color: kRadioColor)),
              onPressed: widget.pop as void Function(),
            )
          ],
        )
    );
  }
}

