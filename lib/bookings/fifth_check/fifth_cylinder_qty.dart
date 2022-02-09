import 'package:easy_homes/bookings/constructors/cylinder_count.dart';
import 'package:easy_homes/bookings/first_check/cylinder_size.dart';
import 'package:easy_homes/bookings/constructors/gas_type_title.dart';
import 'package:easy_homes/bookings/constructors/cylinder_count_second.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/bookings/fifth_check/fifth_cylinder_size.dart';
import 'package:easy_homes/bookings/second_check/second_cylinder_size.dart';
import 'package:easy_homes/bookings/third_check/New_third_cylinder_size.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class FifthCylinderQuantity extends StatefulWidget {

  @override
  _FifthCylinderQuantityState createState() => _FifthCylinderQuantityState();
}

class _FifthCylinderQuantityState extends State<FifthCylinderQuantity> {
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _crossFadeState = CrossFadeState.showFirst;
      });
    });
  }

  bool check = true;
  bool navigate = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AnimatedPadding(
          padding: MediaQuery
              .of(context)
              .viewInsets,
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
          child: Column(
              children: [
                GasTypeTitle(title: Variables.buyingGasType!),
                Divider(),
                spacer(),
                TextWidgetAlign(
                  name: kCylinderQty,
                  textColor: kTextColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),
                check ? AnimationSlide(
                  title: TextWidgetAlign(
                    name: 'Enter for your new cylinder(s)',
                    textColor: kDoneColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.normal,
                  ),

                ) :
                Column(
                  children: [
                    spacer(),

                    AnimationSlide(
                      title: TextWidgetAlign(
                        name: 'Enter for your own cylinder(s)',
                        textColor: kDoneColor,
                        textSize: kFontSize,
                        textWeight: FontWeight.normal,
                      ),

                    )

                  ],
                ),
                AnimatedCrossFade(
                  crossFadeState: _crossFadeState,
                  duration: const Duration(seconds: 1),
                  firstCurve: Curves.bounceInOut,
                  secondCurve: Curves.easeInBack,
                  firstChild: CylinderCount(),
                  secondChild: CylinderCountSecond(),
                ),

                //CylinderCountSecond(),
                spacer(),
                //CylinderCount(),
                //spacer(),

                navigate?SizedBtn(nextFunction: (){_nextFunction();},title: kNextBtn,bgColor: kLightBrown,):
                SizedBtn(nextFunction: (){_moveFunction();},title: kNextBtn,bgColor: kLightBrown,),
                spacer(),
              ]
          ),
        )
    );
  }

  void _nextFunction() {

    setState(() {
      _crossFadeState = CrossFadeState.showSecond;
      navigate = false;

    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        check = false;
      });
    });
  }

  void _prevFunction() {
    setState(() {
      _crossFadeState = CrossFadeState.showFirst;
      check = true;
    });

  }

  void _moveFunction() {
    Navigator.pop(context);
    Navigator.push(context, PageTransition(
        type: PageTransitionType.scale,
        alignment: Alignment.bottomCenter,
        child: FifthCylinderSize()));
  }
}

