import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/screens/bank_details.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/vendorReg/screens/trans.dart';
import 'package:easy_homes/vendorReg/screens/vendor_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:page_transition/page_transition.dart';
class VendorDriving extends StatefulWidget {
  @override
  _VendorDrivingState createState() => _VendorDrivingState();
}

class _VendorDrivingState extends State<VendorDriving> {
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.05);
  }  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(body: SingleChildScrollView(

      child: Column(

        children: <Widget>[
          spacer(),
         BackLogo(),

          spacer(),
          Center(child: SvgPicture.asset('assets/imagesFolder/car.svg')),
      SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          TextWidget(
            name: kCanUDrive,
            textColor: kBlackColor,
            textSize: kFontSize,
            textWeight: FontWeight.w600,
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          VendorBtn(title: kYesD,color: kLightBrown,pressed: (){

            setState(() {
              VendorConstants.vendorDriving = 'Yes';
            });
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Transport()));


          },),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),

      VendorBtn(title: kNoD,color: kVendorBtn,pressed: (){

        /*setState(() {
          VendorConstants.vendorDriving = 'No';
        });*/
           VariablesOne.notifyErrorBot(title: 'Sorry we need only drivers.Thanks');
           Navigator.pop(context);

        //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PaymentDetails()));

      },)
        ],
      ),
    )
    )
    );
  }
}
