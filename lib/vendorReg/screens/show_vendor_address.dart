import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/constructors/error.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowVendorAddress extends StatefulWidget {
  @override
  _ShowVendorAddressState createState() => _ShowVendorAddressState();
}

class _ShowVendorAddressState extends State<ShowVendorAddress> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVendor();
  }
  var itemsData = <dynamic>[];
bool progress = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body:

   Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

        BackLogo(),
        itemsData.length == 0 && progress == false ?Center(child: PlatformCircularProgressIndicator()):
        itemsData.length == 0 && progress == true ? ErrorTitle(errorTitle:'Sorry we could not find your details, please call support'):
        Card(
          elevation: 20,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: kHorizontal),

            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: RichText(
          textAlign: TextAlign.justify,

          text: TextSpan(
            text: 'Dear ',
            style:GoogleFonts.oxanium(
              fontWeight:FontWeight.w400,
              color:kTextColor,
              fontSize: ScreenUtil()
                  .setSp(kFontSize,
              ),

            ),
            children: <TextSpan>[

              TextSpan(text:'${Variables.currentUser[0]['fn']} ${Variables.currentUser[0]['ln']} ',

                style:GoogleFonts.pacifico(
                  fontWeight:FontWeight.bold,
                  color:kLightBrown,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize,
                  ),
                ),
              ),


              TextSpan(text:'you have already applied to become a vendor, and we have successfully submitted your details to ',

                style:GoogleFonts.oxanium(
                  fontWeight:FontWeight.w400,
                  color:kTextColor,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize,
                  ),
                ),
              ),

              TextSpan(text:'${itemsData[0]['biz']} ${itemsData[0]['cad']}',

                style:GoogleFonts.oxanium(
                  fontWeight:FontWeight.w400,
                  color: kDoneColor,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize,
                  ),
                ),
              ),

              TextSpan(text: '. Tel ',
                style:GoogleFonts.oxanium(
                  fontWeight:FontWeight.w400,
                  color: kTextColor,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize,
                  ),
                ),
              ),
              TextSpan(text:itemsData[0]['cph'],
                style:GoogleFonts.oxanium(
                  fontWeight:FontWeight.w400,
                  color: kDoneColor,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize,
                  ),
                ),
              ),

              TextSpan(text: '. $kThanks3' ,
                style:GoogleFonts.oxanium(
                  fontWeight:FontWeight.w400,
                  color: kTextColor,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize,
                  ),
                ),
              ),
            ],
          ),
        ),))),

        SizedBtn(nextFunction: (){Navigator.pop(context);}, bgColor: kDoneColor,title: 'Ok',),

      ],
    )));
  }

  Future<void> getVendor() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
.collectionGroup('companyVendors')
        .where('vId', isEqualTo: Variables.userUid)
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      setState(() {
        progress = true;

      });

    } else {
      for (DocumentSnapshot document in documents) {
setState(() {
  itemsData.add(document.data());

});

      }
    }
  }
}
