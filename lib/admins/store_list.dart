import 'dart:io';

import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/fonts.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/vendorReg/vendor_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';



class BusinessLocationList extends StatefulWidget {

  @override
  _BusinessLocationListState createState() => _BusinessLocationListState();
}

class _BusinessLocationListState extends State<BusinessLocationList> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  TextEditingController _companyEdit = TextEditingController();
String? editDetails;

  //static  List<String> leading = <String>[ 'City','State', 'country','street'];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[


        Visibility(
          visible:AdminConstants.address.isEmpty ?false:true ,
          child: Container(


            width: double.infinity,

            decoration: BoxDecoration(

              shape: BoxShape.rectangle,

              border: Border.all(

                width: 0.5,

                color: kTurnOnBtn,

              ),

              borderRadius: BorderRadius.circular(10.0),

            ),
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: PlatformButton(
                      color:kRedColor,
                    onPressed: (){
                      setState(() {
                        AdminConstants.city.clear();
                        AdminConstants.state.clear();
                        AdminConstants.country.clear();
                        AdminConstants.address.clear();
                        AdminConstants.latitude.clear();
                        //AdminConstants.latLog.clear();
                        AdminConstants.longitude.clear();
                        AdminConstants.subCity.clear();

                      });
                    },
      child: Text(kCancel,
          style: GoogleFonts.oxanium(
            color: kWhiteColor,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(
                      kFontSize, ),

            )
          ),),
    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: AdminConstants.address.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                        child: Column(
                          children: <Widget>[
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextWidget(
                                name: kCity,
                                textColor: kDoneColor,
                                textSize: kFontSize,
                                textWeight: FontWeight.bold,
                              ),

                              TextWidget(
                                name: AdminConstants.city[index],
                                textColor: kTextColor,
                                textSize: kFontSize,
                                textWeight: FontWeight.w600,
                              ),

                            ],
                          )  ,



                            /*state address*/

                            Row(

                              children: <Widget>[
                                TextWidget(
                                  name: kState,
                                  textColor: kDoneColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.bold,
                                ),

                                TextWidget(
                                  name: AdminConstants.state[index],
                                  textColor: kTextColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.w600,
                                ),

                              ],
                            ),


                            /*country address*/

                            Row(

                              children: <Widget>[
                                TextWidget(
                                  name: kCountry,
                                  textColor: kDoneColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.bold,
                                ),

                                TextWidget(
                                  name: AdminConstants.country[index],
                                  textColor: kTextColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.w600,
                                ),

                              ],
                            ),



                            /* address*/

                            Row(

                              children: <Widget>[

                                TextWidget(
                                  name: kAddress,
                                  textColor: kDoneColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.bold,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: ScreenUtil()
                                        .setWidth(150),
                                    minHeight: ScreenUtil()
                                        .setHeight(10),
                                  ),
                                  child: ReadMoreText(
                                  AdminConstants.address[index],

                                    trimLines: 2,
                                    colorClickableText: Colors.pink,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: ' ..',
                                    trimExpandedText: 'Less',
                                    style: GoogleFonts.oxanium(
                                      fontSize: ScreenUtil().setSp(kFontSize, ),
                                      color: kTextColor,
                                    fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    deleteText(context, AdminConstants.city[index],index);
                                  },
                                  child: Icon(Icons.delete_forever,color:kLightBrown),
                                ),

                              ],
                            ),



                          ],
                        ),
                      );
                    }
                ),


              ],
            ),
          ),
        ),


      ],
    );
  }



  void deleteText(BuildContext context, String item, int index) {
    setState(() {
      VendorConstants.companyStoresAddAll.removeAt(index);

      AdminConstants.city.removeAt(index);
      AdminConstants.state.removeAt(index);
      AdminConstants.country.removeAt(index);
      AdminConstants.address.removeAt(index);
      AdminConstants.latitude.removeAt(index);
      //AdminConstants.latLog.removeAt(index);
      AdminConstants.longitude.removeAt(index);
      AdminConstants.subCity.clear();

    });
  }

  /*void editText(BuildContext context, String item, int index) {
    setState(() {
      _companyEdit.text = item;

    });

    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(


              title: Text('Edit Text',
                textAlign: TextAlign.center,
                style: GoogleFonts.oxanium(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kLightBrown,
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),

                    )
                ),
              ),
            content: Container(
                margin: EdgeInsets.symmetric(horizontal:kHorizontal),
                child: Form(

                  child: Platform.isIOS?
                  CupertinoTextField(
                    controller: _companyEdit,
                    maxLength: 100,
                    maxLines: null,
                    autocorrect: true,
                    autofocus: true,

                    cursorColor: (kLightBrown),
                    style: Fonts.textSize,

                    onChanged: (String value) {
                      editDetails = value;
                    },

                  )
                      :TextField(
                    controller: _companyEdit,
                    maxLength: 100,
                    maxLines: null,
                    autocorrect: true,
                    autofocus: true,

                    cursorColor: (kLightBrown),
                    style: Fonts.textSize,


                    decoration: VendorConstants.kCompanyEditDecoration,

                    onChanged: (String value) {
                      editDetails = value;
                    },

                  ),
                ),
              ),

          actions: <Widget>[



            PlatformDialogAction(
             // color: kLightBrown,
              onPressed: () {
                setState(() {
                  VendorConstants.companyStoresAddAll.removeAt(index);
                  VendorConstants.companyStoresAddAll.insert(
                      index, editDetails);

                  Navigator.pop(context);
                });
              },
              child: Text('Edit',
                  style: GoogleFonts.oxanium(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kLightBrown,
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),

                    ),
                  )
              ),
            ),


            PlatformDialogAction(
              // color: kLightBrown,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel',
                  style: GoogleFonts.oxanium(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kRedColor,
                      fontSize: ScreenUtil().setSp(
                          kFontSize, ),

                    ),
                  )
              ),
            )
          ],
            )



    );
*/





}

/*

ListTile(
leading:  TextWidget(
name: leading[index]+ " "+ ':',
textColor: kBlackColor,
textSize: kFontSize,
textWeight: FontWeight.bold,
),
title: Text(VendorConstants.companyStoresAddAll[index],
style: GoogleFonts.oxanium(
textStyle: TextStyle(
fontWeight: FontWeight.bold,
fontSize: ScreenUtil().setSp(
kFontSize, ),

)
),),
trailing: Stack(
children: <Widget>[
GestureDetector(
onTap: (){
deleteText(context, VendorConstants.companyStoresAddAll[index],index);
},
child: Container(
margin: EdgeInsets.only(left: 30),
child: Icon(Icons.delete_forever,color:kLightBrown)),
),
GestureDetector(
onTap:() async {
editText(context, VendorConstants.companyStoresAddAll[index],index);
},
child: Container(
margin: EdgeInsets.only(right: 30),
width:30,
height:30,
child: Icon(Icons.edit,color:kTurnOnBtn)),
),
],
)
);*/
