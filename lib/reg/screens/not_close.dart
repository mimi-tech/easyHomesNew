import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/shimmer_bg.dart';
import 'package:easy_homes/work/constructors/verify_construct.dart';
import 'package:flutter/material.dart';

class NotClose extends StatefulWidget {
  @override
  _NotCloseState createState() => _NotCloseState();
}

class _NotCloseState extends State<NotClose> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body:WillPopScope(
      onWillPop: () => Future.value(false),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextWidgetAlign(
            name:'${Variables.userFN!} ${Variables.userLN}',
            textColor: kLightBrown,
            textSize: 20,
            textWeight: FontWeight.bold,
          ),

          Image.asset(
            "assets/imagesFolder/stop.gif",
            height: 125.0,
            width: 125.0,
          ),



          Center(
              child: ShimmerBgSecond(title: 'Sorry please try again later',)
          ),
          SizedBtn(nextFunction: (){Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreenSecond(),
            ),
                (route) => false,
          );}, bgColor: kDoneColor, title: 'Ok')

        ],
      ),
    )
    ));
  }
}
