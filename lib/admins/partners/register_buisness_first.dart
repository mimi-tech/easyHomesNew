import 'dart:io';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/location_service.dart';
import 'package:easy_homes/admins/partners/biz_code.dart';
import 'package:easy_homes/admins/partners/prize_screen.dart';
import 'package:easy_homes/admins/partners/register_business.dart';
import 'package:easy_homes/bookings/constructors/slide.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class RegisterBusinessScreenOne extends StatefulWidget {


  @override
  _RegisterBusinessScreenOneState createState() => _RegisterBusinessScreenOneState();
}

class _RegisterBusinessScreenOneState extends State<RegisterBusinessScreenOne> {
  TextEditingController _address = new TextEditingController();
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.01);
  }

  String? textAddress;
  Color  btnColor = kLightBrown;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _address.text = AdminConstants.businessLocation;

    _address.addListener(() {
      if(_address.text.isEmpty){
        setState(() {
          btnColor = kTextFieldBorderColor;
        });
      }else{
        setState(() {
          btnColor = kLightBrown;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: PlatformScaffold(
        appBar: PlatformAppBar(
          leading: IconButton(
            icon: SvgPicture.asset('assets/imagesFolder/go_back.svg'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextWidget(
                name:  AdminConstants.bizName!.toUpperCase(),
                textColor: kLightBrown,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        body: Column(
mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
           //SizedBox(height: 2,),
            LogoDesign(),
            AnimationSlide(
              title: TextWidgetAlign(
                name: kTell.toUpperCase(),
                textColor: kDoneColor,
                textSize: kFontSize,
                textWeight: FontWeight.bold,
              ),
            ),

            /*getting the location list*/


            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    name: 'Gas station location',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                    child: Platform.isIOS
                        ? GestureDetector(
                      onTap: () {
                        getMyLocation();
                      },
                      child: AbsorbPointer(
                        child: CupertinoTextField(

                          controller: _address,
                          autocorrect: true,
                          maxLines: null,

                          cursorColor: (kTextFieldBorderColor),
                          style: Fonts.textSize,
                          placeholderStyle: GoogleFonts.oxanium(
                            fontSize: ScreenUtil().setSp(kFontSize,
                                ),
                            color: kHintColor,
                          ),
                          placeholder:
                          'Get address',
                          onChanged: (String value) {
                            AdminConstants.textAddress = value;

                            if(AdminConstants.businessLocation == ''){
                              setState(() {
                                btnColor = kTextFieldBorderColor;
                              });
                            }else{
                              setState(() {
                                btnColor = kLightBrown;
                              });
                            }

                          },
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(kBorder),
                              border: Border.all(color: kLightBrown)),



                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: () {
                        getMyLocation();
                      },
                      child: AbsorbPointer(
                        child: TextField(

                          maxLines: null,
                          controller: _address,
                          autocorrect: true,
                          cursorColor: (kTextFieldBorderColor),
                          style: Fonts.textSize,
                          decoration: InputDecoration(

                              hintText: 'Gas station location address',
                              hintStyle:GoogleFonts.oxanium(
                                fontSize: ScreenUtil().setSp(kFontSize, ),
                                color: kHintColor,
                              ),
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 18.0, 20.0, 18.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      kBorder)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kLightBrown))



                          ),
                          onChanged: (String value) {
                            AdminConstants.textAddress = value;



                          },
                        ),
                      ),
                    )),
              ],
            ),
           // spacer(),

            Btn(nextFunction: () {
              moveToNext();
            }, bgColor: btnColor,),


           // spacer(),

          ],
        ),
      ),
    );
  }

  void getMyLocation() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, alignment: Alignment.bottomCenter, child: BusinessLocationService()));
  }

  void moveToNext() {

    if(( _address.text == '')  || ( _address.text == null)){
      Fluttertoast.showToast(
          msg: 'Please  add your address',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: kBlackColor,
          timeInSecForIosWeb: 6,
          textColor: kRedColor);
    } else{
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: InputGasPrize()));

    }
  }


}
