import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/admins/admin_constants.dart';
import 'package:easy_homes/admins/constructors/easy_appbar.dart';


import 'package:easy_homes/admins/pages/activity.dart';
import 'package:easy_homes/admins/pages/page_bottombar.dart';
import 'package:easy_homes/admins/pages/page_constants.dart';

import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/admins/pages/tabs/company_tabs.dart';
import 'package:easy_homes/admins/pages/tabs/counting_tab.dart';
import 'package:easy_homes/reg/constants/variables.dart';

import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/yesNo_btn.dart';
import 'package:easy_homes/utils/admin_appBar.dart';
import 'package:easy_homes/utils/image_screen.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_homes/admins/partners/select_type.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';


class UnBlockUsers extends StatefulWidget {
  @override
  _UnBlockUsersState createState() => _UnBlockUsersState();
}

class _UnBlockUsersState extends State<UnBlockUsers> {


  Widget space() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }


   var _documents = <DocumentSnapshot>[];
  var itemsData = <dynamic>[];
  bool progress = false;
  String? filter;
  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.08);
  }

  Widget bodyList(int index){
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Row(

            children: <Widget>[
              ImageScreen(image: itemsData[index]['pix'],),
              SizedBox(width:imageRightShift.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    name: '${itemsData[index]['fn']} ${  itemsData[index]['ln']}',
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),


                  GestureDetector(
                    onTap:() async {
                      var url = "tel:${  itemsData[index]['ph']}";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },

                    child: TextWidget(
                      name:   itemsData[index]['ph'],
                      textColor: kDoneColor,
                      textSize: kFontSize,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),


              Spacer(),

              AdminConstants.category == AdminConstants.owner!.toLowerCase()?  RaisedButton(
                onPressed: (){

                  unblockUser(context, index);
                },
                color: kLightBrown,
                child: TextWidget(
                  name: 'Unblock',
                  textColor: kWhiteColor,
                  textSize: kFontSize,
                  textWeight: FontWeight.w500,
                ),
              ):Text('')
            ],
          ),



          Divider(),
          itemsData[index]['ven'] == true?Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child:TextWidget(
                name:   itemsData[index]['biz'],
                textColor: kTextColor,
                textSize: kFontSize,
                textWeight: FontWeight.w500,
              )
          ):Text(''),

          RichText(
            text: TextSpan(
                text: ('Joined: '),
                style: GoogleFonts.oxanium(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil()
                      .setSp(kFontSize2, ),
                  color: kDarkRedColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:   itemsData[index]['date'],
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kProfile,
                    ),
                  )
                ]),
          ),

          space()



        ],
      ),
    );
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBlocked();
    PageConstants.searchController.addListener(() {
      setState(() {
        filter = PageConstants.searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //PageConstants.allVendorCount.clear();
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: PageAddVendor(
          block: kWhiteColor,
          cancel: kYellow,
          rating: kWhiteColor,
          addVendor: kWhiteColor,
        ),
        appBar:CancelAppBar(title: kBlocked.toUpperCase(),),
        body: CustomScrollView(
          slivers: <Widget>[
          SilverAppBarCancel(
          block: kLightBrown,
          editPin: kBlackColor,
          remove: kBlackColor,
          suspend: kBlackColor,

        ),

        SliverList(
            delegate: SliverChildListDelegate([

              SizedBox(height: 10,),
                  itemsData.length == 0 && progress == false
                      ? Center(child: PlatformCircularProgressIndicator())
                      : itemsData.length == 0 && progress == true
                      ? Center(
                        child: TextWidget(
                    name: 'No blocked user'.toString(),
                    textColor: kTextColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.w500,
                  ),
                      )
                      : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:   _documents.length,
                      itemBuilder: (context, int index) {

                        return filter == null || filter == "" ?bodyList(index):
                        '${itemsData[index]['fn']}'.toLowerCase()
                            .contains(filter!.toLowerCase())

                            ?bodyList(index):Container();
                      }),

                ])),
        ]
      ),
    )
    );
  }

  void unblockUser(BuildContext context,int index) {


    showDialog(
        context: context,
        builder: (context) => Platform.isIOS ?
        CupertinoAlertDialog(
          title: TextWidget(
            name: kCancelOrder.toUpperCase(),
            textColor: kLightBrown,
            textSize: kFontSize,
            textWeight: FontWeight.bold,
          ),

          content: Column(
            children: <Widget>[],
          ),


          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                unblock(index);
              },
            ),
          ],
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          title: Center(
            child: TextWidget(
              name: kCancelOrder.toUpperCase(),
              textColor: kLightBrown,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
          )
          ,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: kHorizontal),
              child:  RichText(
                text: TextSpan(
                    text: ('Are you sure you want to unblock '),
                    style: GoogleFonts.oxanium(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil()
                          .setSp(kFontSize, ),
                      color: kTextColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${  itemsData[index]['fn']} ${  itemsData[index]['ln']}',
                        style: GoogleFonts.oxanium(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil()
                              .setSp(kFontSize2, ),
                          color: kLightBrown,
                        ),
                      )
                    ]),
              ),
            ),
            spacer(),
            YesNoBtn(no: (){Navigator.pop(context);},yes: (){unblock(index);},),
          ],
        )

    );


  }

  void unblock(int index) {
    //Unblock the user account
Navigator.pop(context);
   try{
     FirebaseFirestore.instance.collection
('userReg').doc(itemsData[index]['ud']).update({
     'bl':false,
       'blt':true,
     });

     Fluttertoast.showToast(
         msg: 'Unblocked successfully',
         toastLength: Toast.LENGTH_LONG,
         backgroundColor: kBlackColor,
         textColor: kGreenColor);
     setState(() {
       _documents.removeAt(index);
       itemsData.removeAt(index);
     });
   }catch (e){
   VariablesOne.notifyFlutterToastError(title: kError);
   }

  }

  Future<void> getBlocked() async {
    PageConstants.blockedUsers.clear();
      itemsData.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('userReg').where('bl',isEqualTo: true).get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {
      setState(() {
        progress = true;
      });
    } else {
      for (DocumentSnapshot document in documents) {
        setState(() {
          _documents.add(document);
          itemsData.add(document.data());
            PageConstants.blockedUsers.add(document.data());

        });
        
      }
    }
  }
  }


  



