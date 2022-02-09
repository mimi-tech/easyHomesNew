import 'package:easy_homes/bookings/constructors/cylinder_count.dart';
import 'package:easy_homes/bookings/first_check/cylinder_size.dart';
import 'package:easy_homes/bookings/constructors/gas_type_title.dart';
import 'package:easy_homes/bookings/constructors/cylinder_count.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CylinderQuantityConstruct extends StatefulWidget {
  CylinderQuantityConstruct({required this.qty,required this.title});
  final int qty;
  final String title;

  @override
  _CylinderQuantityConstructState createState() => _CylinderQuantityConstructState();
}

class _CylinderQuantityConstructState extends State<CylinderQuantityConstruct> with TickerProviderStateMixin {



  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;


  initState() {
    super.initState();
    //for sliding
    _controller = AnimationController(
      vsync:this,
      value: 0.1,
      duration: const Duration(milliseconds: 1000),
    );

    _offsetFloat = Tween<Offset>(begin: Offset(2.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _offsetFloat.addListener((){
      setState((){});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        TextWidgetAlign(
          name: widget.title,
          textColor: kTextColor,
          textSize: kFontSize,
          textWeight: FontWeight.w500,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        /*Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: kRadioColor)
          ),
          child:Center(
            child: FadeTransition(
              opacity: animation,

              child: TextWidgetAlign(
                name: widget.qty.toString(),
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              ),
            ),
          ),
        ),*/
        CylinderCount(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Divider(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        SlideTransition(
          position: _offsetFloat,
          child: TextWidgetAlign(
            name: Variables.cylinderCount > 1?'Please select cylinder size and enter quantity':'What is your cylinder size ?'.toUpperCase(),
            textColor: kTextColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        SlideTransition(
          position: _offsetFloat,
          child: TextWidgetAlign(
            name: 'Click box to check, click image to zoom',
            textColor: kLightBrown,
            textSize: 15,
            textWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
