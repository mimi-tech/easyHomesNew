
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:easy_homes/extacted_classes/vendor_bappbar.dart';
import 'package:easy_homes/extacted_classes/vendor_close_work.dart';
import 'package:easy_homes/extacted_classes/vendor_map.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';
import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';
import 'package:easy_homes/reg/screens/home2.dart';
import 'package:easy_homes/reg/screens/recover/support.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/logo_design.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:easy_homes/utility/back_icon.dart';
import 'package:easy_homes/utils/back_logo.dart';
import 'package:easy_homes/work/navigation_map.dart';

import 'package:easy_homes/work/show_customer.dart';
import 'package:easy_homes/work/upcoming_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:wakelock/wakelock.dart';
class VendorOffice extends StatefulWidget {
  @override
  _VendorOfficeState createState() => _VendorOfficeState();
}

class _VendorOfficeState extends State<VendorOffice>  with WidgetsBindingObserver{
Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeOlToTrue();
    changeToTrue();

    WidgetsBinding.instance!.addObserver(this);

    Wakelock.enable();
    setToFalse();
    Constant1.rejectedGasDeliveryCount = 0;
  }
  late List<DocumentSnapshot> workingDocument;
  Widget spacer() {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .height * 0.02);
  }
late StreamSubscription stream;

bool progress = false;

List<dynamic> workingDocuments = <dynamic>[];
 var _documents = <DocumentSnapshot>[];
bool continueWork = false;
@override
  void dispose() {
    // TODO: implement dispose

  super.dispose();

  changeToFalse();
    stream.cancel();
    WidgetsBinding.instance!.removeObserver(this);

    Wakelock.disable();
    //update vendor online to false


  }

@override
void didChangeAppLifecycleState(AppLifecycleState state) {

    switch (state) {

      case AppLifecycleState.paused:
        {
          print('paused');

          //changeToFalse();
        }
        break;
      case AppLifecycleState.inactive:
        {
          //changeToFalse();
          print('inactive');
        }
        break;

      case AppLifecycleState.detached:
        {

          //changeToFalse();

          print('detached');
        }
        break;
      case AppLifecycleState.resumed:
        {
          print('resumed');
          changeOlToTrue();
        }
        break;
    }

}



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
       bottomNavigationBar:VendorBottomNavBar(),
        body: WillPopScope(
            onWillPop: () => Future.value(false),

         /* onWillPop: (){
           // Future.value(false);
            Constant1.showSideDialog(no: (){},context: context,yes: (){
              Navigator.pop(context);

              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: HomeScreenSecond()));
              print('hhhh');


             // changeToFalse();

            });

            return Future.value(false);

          },*/
          child: SingleChildScrollView(

            child:  workingDocuments.length == 0 ?Center(child: PlatformCircularProgressIndicator()):
            Column(

              children: <Widget>[


                    Container(
                      //height: MediaQuery.of(context).size.height *0.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(

                              bottomLeft: Radius.circular(kContainerRadius),
                              /*topLeft: Radius.circular(10),*/
                              bottomRight: Radius.circular(kContainerRadius)
                          ),

                          image: DecorationImage(
                              image: AssetImage('assets/imagesFolder/vendor_bg.png'), fit: BoxFit.cover)),

                      child: Column(

                        children: <Widget>[

                          Container(

                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap:(){
                                          Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => HomeScreenSecond(),
                                            ),
                                                (route) => false,
                                          );
                                          changeToFalse();

                                          Wakelock.disable();

                                        },
                                        child: BackIcon()),

                                  ],
                                ),
                                spacer(),
                                TextWidget(
                                  name:  workingDocuments[0]['fn'],
                                  textColor: kLightDoneColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.bold,
                                ),

                                TextWidget(
                                  name: workingDocuments[0]['ln'],
                                  textColor: kLightDoneColor,
                                  textSize: kFontSize,
                                  textWeight: FontWeight.bold,
                                ),
                                spacer(),


                                    Row(
                                  children: [
                                    Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(

                                          color: kLightBrown,

                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(kContainerRadius),
                                              bottomLeft: Radius.circular(kContainerRadius),
                                              /*topLeft: Radius.circular(10),*/
                                              bottomRight: Radius.circular(kContainerRadius)
                                          )

                                      ),


                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset('assets/imagesFolder/star.svg',),

                                          TextWidget(
                                            name: workingDocuments[0]['rate'].toString(),
                                            textColor: kWhiteColor,
                                            textSize: kFontSize,
                                            textWeight: FontWeight.bold,
                                          ),


                                        ],
                                      ),



                                    ),
                                       SizedBox(width: 10,),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      //radius: 32,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(

                                          imageUrl:  workingDocuments[0]['pix'],
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => SvgPicture.asset('assets/imagesFolder/user.svg'),
                                          fit: BoxFit.cover,
                                          width: 55.w,
                                          height: 60.h,

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                spacer(),
                              ],
                            ),
                          ),

                          /* Align(
              alignment: Alignment.bottomRight,
              child: PopupMenuButton(

                    child: Icon(Icons.more_vert,color: kRadioColor,),

            itemBuilder: (
            context) =>
            [
            //ToDo:Edit details
            PopupMenuItem(
            child: GestureDetector(
            child: TextWidget(
              name: kAccessVendor,
              textColor: kTextColor,
              textSize: kFontSize,
              textWeight: FontWeight.bold,
            ),
            ),
            ),



            ]
              )
              )*/
                        ],
                      ),
                    ),


                    VendorMap()


                  ],
                ),
              ))
    ));





            }


  void closeWork() {
    showDialog(
        context: context,
        builder: (context) => Platform.isIOS ?
        CupertinoAlertDialog(
          content: VendorCloseWork(),
        )
            : SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,

          children: <Widget>[
            VendorCloseWork(),
          ],
        )

    );

  }

  void setToFalse() {
    Future.delayed(const Duration(seconds: 22), () async {
      VariablesOne.playState = false;
    });
  }

  void changeToFalse() {
    FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('vId', isEqualTo: Variables.userUid)
        .get().then((value) {
      value.docs.forEach((result) {
        result.reference.update({
          'ol': false,

        });
      });
    });

    FirebaseFirestore.instance
        .collection("vendorCount")
        .doc(Variables.userUid).set({
      'ol':false
    },SetOptions(merge: true));

    //updating vendors count
    FirebaseFirestore.instance
        .collection('sessionActivity')
        .doc()
        .get().then((resultData) {
      resultData.reference.set({
        'olv': resultData.data()!['olv'] - 1,
      }, SetOptions(merge: true));
    });
  }


  void changeOlToTrue(){
    FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('vId', isEqualTo: Variables.userUid)
        .get().then((value) {
      value.docs.forEach((result) {
        result.reference.update({
          'ol': true,

        });
      });
    });

    FirebaseFirestore.instance
        .collection("vendorCount")
        .doc(Variables.userUid).set({
      'ol':true
    },SetOptions(merge: true));

    //updating vendors count
    FirebaseFirestore.instance
        .collection('sessionActivity')
        .doc()
        .get().then((resultData) {
      resultData.reference.set({
        'olv': resultData.data()!['olv'] + 1,
      }, SetOptions(merge: true));
    });
  }


  void changeToTrue() {
    try{
      stream = FirebaseFirestore.instance
          .collectionGroup('companyVendors')
          .where('vId',isEqualTo:  Variables.userUid )
          .where('appr',isEqualTo: true).snapshots().listen((result) async {


        final List <DocumentSnapshot> documents = result.docs;

        if(documents.length == 0){
          SupportVendor();
          stream.cancel();

        }else {
          workingDocuments.clear();
         for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {_documents.add(document);
              workingDocuments.add(document.data());
              Constant1.venLat = data['lat'];
              Constant1.venLog = data['log'];
              // PageConstants.getCompanies.clear();
            });

            //check if tr is true, in case if the vendors phone dies off and he ons it again
            if(data['tr'] == true && VariablesOne.orderEnded  == false){
              Constant1.showContinueBooking(context: context, submit: () async {
                final QuerySnapshot result = await FirebaseFirestore.instance
                    .collection('customer')
                    .where('vid', isEqualTo: Variables.currentUser[0]['ud'])
                    .get();

                final List <DocumentSnapshot> documents = result.docs;
                if (documents.length != 0) {

                 for (DocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {Variables.itemsData.clear();
                      Variables.itemsData.add(document.data());

                      Variables.transit = document;
                    });
                  }
                }
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => NavigationRoute(),
                  ),
                      (route) => false,
                );
              });
              stream.cancel();
            }



            if(workingDocuments[0]['con'] == true){

              Constant1.audioPlayer = await AudioCache().play("r1.mp3");
               stream.cancel();
              Future.delayed(Duration.zero, () {
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ShowCustomer(pix:workingDocuments[0]['pix']),
                  ),
                      (route) => false,
                );

              });



              //updating ongoing order count
              FirebaseFirestore.instance
                  .collection('sessionActivity')
                  .doc()
                  .get().then((resultData) {
                resultData.reference.set({
                  'ong': resultData.data()!['ong'] + 1,
                }, SetOptions(merge: true));
              });

              Future.delayed(const Duration(seconds: kCallDuration), () async {
                if(VariablesOne.playState == false){
                  Constant1.audioPlayer.stop();
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






                      });
                    });



                }

              });


            }
            //check if vendor has upcoming booking

            if(workingDocuments[0]['ue'] == true){
              Future.delayed(Duration.zero, () {

                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => UpcomingScreen(dv:workingDocuments[0]['dv']),
                  ),
                      (route) => false,
                );



              });
            }
          }

        }
        });



  }catch(e){
      print(e);
    }
  }





}
class SupportVendor extends StatefulWidget {
  @override
  _SupportVendorState createState() => _SupportVendorState();
}

class _SupportVendorState extends State<SupportVendor> with SingleTickerProviderStateMixin {

  var _visible = true;

  late AnimationController animationController;
 late  Animation<double> animation;
 Timer? _timer;
  @override
  void initState() {
    super.initState();
   setToTrue();

  }


  @override
  void dispose() {
    //animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30,),
    Stack(
    alignment: Alignment.center,
    children: <Widget>[

    Container(
    alignment: Alignment.topLeft,
    margin: EdgeInsets.symmetric(horizontal: kHorizontal),
    child:IconButton(
    icon: Icon(Icons.arrow_back_ios),
    onPressed: () {
      setState(() {
        VariablesOne.offline = false;
      });
    Navigator.pop(context);
    },),),

    LogoDesign(),
    ],
    ),
        SizedBox(height: 30,),

        Image.asset(
          "assets/imagesFolder/stop.gif",
          height: 125.0,
          width: 125.0,
        ),


        SizedBox(height: 30,),


    GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: SupportScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kHorizontal),
        child: RichText(

              textAlign: TextAlign.center,
              text: TextSpan(
                  text:'Sorry ${Variables.userFN!} ${Variables.userLN} , your account has been suspended from receiving bookings as a vendor until further notice. Please ',
                  style: GoogleFonts.oxanium(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil()
                        .setSp(kFontSize, ),
                    color: kListTileColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'contact support',
                      style: GoogleFonts.oxanium(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil()
                            .setSp(kFontSize, ),
                        color: kDoneColor,
                      ),
                    )
                  ]),
            ),
      ),
    ),
      ],
    );
  }

  void setToTrue() {
    setState(() {
      VariablesOne.offline = true;
    });

      print(VariablesOne.offline );
  }
}
