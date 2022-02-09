import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/vendorReg/screens/outlet_form.dart';
import 'package:easy_homes/vendorReg/screens/store_address.dart';
import 'package:easy_homes/vendorReg/screens/vendor_btn.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
class VendorHome extends StatefulWidget {
  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  Widget space(){
    return SizedBox(height:20.h);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: PlatformScaffold(
        body:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            space(),
           BackLogo(),

            space(),
            Column(
              children: <Widget>[
                Center(child:  SvgPicture.asset('assets/imagesFolder/cylinder.svg')),
                space(),
                TextWidget(name: kGasOutlet,
                  textColor: kBlackColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.normal,),

              ],
            ),


            space(),
            VendorBtn(title: kYesIHave,color: kLightBrown,pressed: (){
              setState(() {
                VendorConstants.outLetStore = 'Yes';
              });
              Navigator.push(context, PageTransition(type: PageTransitionType.rotate, duration: Duration(seconds: kTransitionSecs), child: OutLetForm()));

            },),


        space(),
      VendorBtn(title: kNoIDont,color: kVendorBtn,pressed: (){

        setState(() {
        VendorConstants.outLetStore = 'No';
        });
        Navigator.push(context, PageTransition(type: PageTransitionType.rotate, duration: Duration(seconds: kTransitionSecs), child: OutletAddress()));

      },),
          space(),
      ],
        )
      ),
    );
  }

/*

  void getCurrentUser() {
*/
/*getting the list of  partners we have*//*


    FirebaseFirestore.instance.collection
Group('subBiz').getDocuments().then((value) {
      value.documents.forEach((result) {
        setState(() {
          documents.add(result);
          bizName.add(result.data['biz']);
          //AdminConstants.noAdminCreated = result.data['ano'];

        });


      });
    }).whenComplete(() => {
      */
/*getting the list of business we have*//*


      FirebaseFirestore.instance.collection
Group('myBiz').getDocuments().then((value) {
        value.documents.forEach((result) {
          setState(() {
            documents.add(result);
            bizName.add(result.data);
            //AdminConstants.noAdminCreated = result.data['ano'];

          });


        });

      })
    });




  }
*/

}
