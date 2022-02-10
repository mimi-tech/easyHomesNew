
import 'dart:async';

import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/utils/money_format.dart';
import 'package:easy_homes/utils/progressHudFunction.dart';
import 'package:easy_homes/utils/read_more.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';

import 'package:easy_homes/reg/constants/divider.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/strings/strings.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/work/navigation_map.dart';
import 'package:easy_homes/work/vendor_office.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock/wakelock.dart';

enum PlayerState { stopped, playing, paused }
class ShowCustomer extends StatefulWidget {


  ShowCustomer({required this.pix});
  final String pix;
  @override
  _ShowCustomerState createState() => _ShowCustomerState();
}

class _ShowCustomerState extends State<ShowCustomer> {

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }

  Widget spacerWidth() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.03);
  }

  var itemsData = <dynamic>[];
  late List<dynamic> loadImages;
  late List<dynamic> loadKg;
  late List<dynamic> loadQuantity;

late DocumentSnapshot document;

  AudioPlayer audioPlayer = AudioPlayer();





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCustomerDetails();
    //getMusic();
  }





  void getMusic() async {

    audioPlayer = await AudioCache().play("r1.mp3");




    Future.delayed(const Duration(seconds: kCallDuration), () async {

if(VariablesOne.playState == false){
  audioPlayer.stop();
  try {
    FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('vId', isEqualTo: Variables.userUid)
        .get().then((value) {
      value.docs.forEach((result) {
        result.reference.update({
          'con': false,
          'ac': ""
        });


        setState(() {
          Variables.missedCall++;
        });
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (BuildContext context) => VendorOffice(),
          ),
              (route) => false,
        );




//print('ddddddddddddd${ VariablesOne.decline}');


      });
    });


  } catch (e) {

  }
}


        });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    Wakelock.disable();


    audioPlayer.dispose();
  }

bool _publishModal = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: PlatformScaffold(

      body: ProgressHUDFunction(
        inAsyncCall: _publishModal,
        child: WillPopScope(
          onWillPop: () => Future.value(false),
          child: SingleChildScrollView(
          child: itemsData.length == 0?Center(child: PlatformCircularProgressIndicator()):Column(
            children: <Widget>[

              Stack(
                   //alignment: Alignment.bottomRight,
                   children: <Widget>[

                     Container(
                       child: SvgPicture.asset('assets/imagesFolder/call_bg.svg',
                         width: MediaQuery
                             .of(context)
                             .size
                             .width,
                         //height: MediaQuery.of(context).size.height*1.5,
                       ),
                     ),

                     Container(
                       margin: EdgeInsets.symmetric(horizontal: 10,),
                       child: Column(
                         //mainAxisAlignment: MainAxisAlignment.end,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           spacer(),
                           TextWidget(
                             name: 'Gas Order'.toUpperCase(),
                             textColor: kLightBrown,
                             textSize: kFontSize,
                             textWeight: FontWeight.w900,
                           ),
                           spacer(),
                           TextWidget(
                             name:itemsData[0]['ad'],
                             textColor: kWhiteColor,
                             textSize: kFontSize14,
                             textWeight: FontWeight.w500,
                           ),
                           spacer(),
                           TextWidget(
                             name:'${itemsData[0]['dt'].toString()} ( ${itemsData[0]['tm'].toString()} )',

                             textColor: kYellow,
                             textSize: kFontSize,
                             textWeight: FontWeight.w400,
                           ),
                           spacer(),
                           TextWidget(
                             name:itemsData[0]['fn'],
                             textColor: kWhiteColor,
                             textSize: kFontSize14,
                             textWeight: FontWeight.bold,
                           ),

                           TextWidget(
                             name:itemsData[0]['ln'],
                             textColor: kWhiteColor,
                             textSize: kFontSize14,
                             textWeight: FontWeight.bold,
                           ),


                         ],


                       ),
                     ),

                   ],
                 ),



                 Container(

                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height*0.22,

                   color:kBlackColor,
                   child: AspectRatio(
                     aspectRatio: 3 / 2,

                     child: CachedNetworkImage(

                       imageUrl:itemsData[0]['px'],
                       placeholder: (context, url) => Center(child: PlatformCircularProgressIndicator()),
                       errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
                       fit: BoxFit.cover,


                     ),
                   ),
                 ),

                 spacer(),


              Container(
                margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: TextWidgetAlign(
                  name: itemsData[0]['bgt'],
                  textColor: kLightBrown,
                  textSize: kFontSize,
                  textWeight: FontWeight.bold,
                ),
              ),
              Divider(),
              spacer(),
              IntrinsicHeight(
                   child: Row(
                     //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: <Widget>[
                       spacerWidth(),
                       SvgPicture.asset('assets/imagesFolder/pick_up.svg'),
                       spacerWidth(),

                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           TextWidget(
                             name: 'Delivery: '+itemsData[0]['wd'],
                             textColor: kTextColor,
                             textSize: kFontSize14,
                             textWeight: FontWeight.bold,
                           ),
                           spacer(),
                           TextWidget(
                             name: 'Payment: '+itemsData[0]['mp'],
                             textColor: kTextColor,
                             textSize: kFontSize14,
                             textWeight: FontWeight.bold,
                           ),

                         ],
                       ),
                       VerticalLine(),


                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: <Widget>[
                               TextWidget(
                                 name: '$kGP',
                                 textColor: kTextColor,
                                 textSize: kFontSize14,
                                 textWeight: FontWeight.bold,
                               ),
                                  spacerWidth(),
                               MoneyFormatColors(
                                 color: kLightBrown,
                                 title: TextWidgetAlign(
                                   name: Variables.transit!['by'] == true?(VariablesOne.numberFormat.format(0).toString()):'${VariablesOne.numberFormat.format(itemsData[0]['aG'])}',
                                   textColor: kLightBrown,
                                   textSize: kFontSize14,
                                   textWeight: FontWeight.w500,
                                 ),
                               ),



                             ],
                           ),
                           spacer(),
                          itemsData[0]['acy'] == null?Visibility(
                              visible: false,
                              child: Text('')): Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextWidget(
                                name: kNC,
                                textColor: kTextColor,
                                textSize: kFontSize14,
                                textWeight: FontWeight.bold,
                              ),
                              spacerWidth(),
                              MoneyFormatColors(
                                color: kLightBrown,
                                title: TextWidgetAlign(
                                  name: '${VariablesOne.numberFormat.format(itemsData[0]['acy'])}',
                                  textColor: kLightBrown,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                              ),


                            ],
                          ),
                           Row(
                             children: <Widget>[
                               TextWidget(
                                 name: '$kDF',
                                 textColor: kTextColor,
                                 textSize: kFontSize14,
                                 textWeight: FontWeight.bold,
                               ),
                               spacerWidth(),
                               MoneyFormatColors(
                                 color: kLightBrown,
                                 title: TextWidgetAlign(
                                   name: '${VariablesOne.numberFormat.format(itemsData[0]['df'])}',
                                   textColor: kLightBrown,
                                   textSize: kFontSize14,
                                   textWeight: FontWeight.w500,
                                 ),
                               ),

                             ],
                           ),
                           spacer(),



                         ],
                       )

                ],
                ),
                 ),


                 DividerLine(),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextWidgetAlign(
                    name: 'Total: ',
                    textColor: kBlackColor,
                    textSize: kFontSize,
                    textWeight: FontWeight.bold,
                  ),
                  MoneyFormatColors(
                    color: kSeaGreen,
                    title: TextWidgetAlign(
                      name: '${VariablesOne.numberFormat.format(itemsData[0]['amt'])}',
                      textColor: kSeaGreen,
                      textSize: kFontSize,
                      textWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              DividerLine(),

              Container(
                //margin: EdgeInsets.symmetric(horizontal: kHorizontal),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[

    GestureDetector(
            onTap:()  {
                Constant1.audioPlayer.stop();
                setState(() {
                  VariablesOne.playState = true;
                  //VariablesOne.decline = false;
                });


             notifyCustomer();


                  },
            child: SvgPicture.asset('assets/imagesFolder/decline.svg',)),


    GestureDetector(
        onTap:()  {

          Constant1.audioPlayer.stop();
          setState(() {
            VariablesOne.playState = true;
          });
          goToNext();
          },

        child: SvgPicture.asset('assets/imagesFolder/accept.svg',)),


    spacer(),


  ],
  ),
              )
               ],

             ),
          ),
        ),
      ),
    )
    );
  }

  Future<void> notifyCustomer() async {
/*update customer details to cancel true*/

  setState(() {
    _publishModal = true;
  });
  try{
      /*update vendor connection false*/
    /*FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('vId', isEqualTo: Variables.userUid)
        .get().then((value) {
               value..update({
        'con': false,
        'tr': ""
      });
        });*/

    FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('vId', isEqualTo: Variables.userUid)
        .get().then((value) {
      value.docs.forEach((result) {
        result.reference.update({
          'con': false,
          'ac': ""
        });
      });
    });
    Future.delayed(const Duration(seconds: 5), ()  {

    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(
        builder: (BuildContext context) => VendorOffice(),
      ),
          (route) => false,
    );});



    }catch (e){
      setState(() {
        _publishModal = false;
      });
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }
  }

  Future<void> getCustomerDetails() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('customer')
        .where('vid', isEqualTo: Variables.currentUser[0]['ud'])
        .get();

    final List <DocumentSnapshot> documents = result.docs;
if (documents.length == 0) {

    } else {

       for (document in documents) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          Variables.itemsData.clear();
          Variables.itemsData.add(document.data());
          itemsData.add(document.data());
           Variables.transit = document;
          loadImages = data['cyt'];
          loadKg = data['cKG'];
          loadQuantity = data['cQ'];


        });
      }
    }
  }

  void goToNext() {
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(
        builder: (BuildContext context) => NavigationRoute(),
      ),
          (route) => false,
    );
  }
}
