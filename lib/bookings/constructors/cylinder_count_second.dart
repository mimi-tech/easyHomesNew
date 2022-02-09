import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CylinderCountSecond extends StatefulWidget {
  @override
  _CylinderCountSecondState createState() => _CylinderCountSecondState();
}

class _CylinderCountSecondState extends State<CylinderCountSecond> {
  //int _count = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: kLightBrown)
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if( Variables.cylinderCountSecond > 1){
                      Variables.cylinderCountSecond--;
                    }

                  });
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kRadioColor),
                    color: kLightBrown
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: Text(
                      '${Variables.cylinderCountSecond}',
                      key: ValueKey<int>(Variables.cylinderCountSecond),
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil()
                            .setSp(kFontSize14, ),
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    Variables.cylinderCountSecond += 1;
                  });
                },
              ),



            ],
          ),
        ),

      ],
    );
  }
}
