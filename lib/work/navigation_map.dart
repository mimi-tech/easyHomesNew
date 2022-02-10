import 'dart:async';

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_homes/colors/colors.dart';
import 'package:easy_homes/dimes/dimen.dart';
import 'package:easy_homes/reg/constants/btn.dart';
import 'package:easy_homes/reg/constants/constant_1.dart';

import 'package:easy_homes/reg/constants/variables.dart';
import 'package:easy_homes/reg/constants/variables_0ne.dart';

import 'package:easy_homes/work/constructors/check_cylinder.dart';
import 'package:easy_homes/work/constructors/delivered.dart';
import 'package:easy_homes/work/constructors/map_direction.dart';
import 'package:easy_homes/work/constructors/report_station.dart';
import 'package:easy_homes/work/constructors/show_map.dart';
import 'package:easy_homes/work/constructors/text_construct.dart';
import 'package:easy_homes/work/stations/confirm_gas_station.dart';

import 'package:easy_homes/work/vendor_office.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:easy_homes/utils/progressHudFunction.dart';

import 'package:easy_homes/utility/second_screen.dart';
import 'package:easy_homes/strings/strings.dart';
import 'package:easy_homes/utility/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

late NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class NavigationRoute extends StatefulWidget {
  @override
  _NavigationRouteState createState() => _NavigationRouteState();
}

class _NavigationRouteState extends State<NavigationRoute> {
  //static List <dynamic> itemsData;
  Geoflutterfire geo = Geoflutterfire();

  bool checkVerify = false;
  double cameraZoom = 13;
  double cameraTilt = 0;
  double cameraBearing = 30;
  var p2;
  var p3;
  var p1;

  Widget spacer() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
bool verifyBtn = false;
  bool progress = false;
  var date = DateTime.now();
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateUserAcceptance();

    getOrderCancel();
    getVerifyOrder();
    getUpdatedOrder();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }
  dynamic total;
  dynamic gas;
  bool changeStation = false;
void getVerifyOrder(){
  //check if customer has verify the order
  FirebaseFirestore.instance
      .collection('customer').doc(Variables.userUid)
      .snapshots()
      .listen((result) {


      if (result.data()!['vf'] == true) {
        setState(() {
          verifyBtn = true;
        });

      }
   // });
  });

}

void getUpdatedOrder(){
  FirebaseFirestore.instance
      .collection('customer').doc(Variables.userUid)
      //.where('vid', isEqualTo: Variables.userUid)
      .snapshots()
      .listen((result) {
   // result.docs.forEach((result) async {
      if(result.data()!['uo'] == true){
        setState(() {
          VariablesOne.updatedOrderTrue = true;
          VariablesOne.changedTotal = result.data()!['amt'];
          VariablesOne.changedGas = result.data()!['aG'];

        });
      }

   // });
  });
}
 StreamSubscription? stream;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
if(stream != null){
  stream!.cancel();
}
  }

  bool _publishModal = false;

  @override
  Widget build(BuildContext context) {

    Widget spacer() {
      return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
    }

    return SafeArea(
      child: PlatformScaffold(
        backgroundColor: kBlackColor,
          body: progress == true
              ? Center(child: PlatformCircularProgressIndicator())
              : ProgressHUDFunction(
                  inAsyncCall: _publishModal,
                  child: SingleChildScrollView(
                    child: WillPopScope(
                      onWillPop: () => Future.value(false),
                      child: Column(
                        children: <Widget>[
                          ShowMap(),
                          Container(
                            //alignment: Alignment.bottomCenter,

                            width: MediaQuery.of(context).size.width,
                            color: kBlackColor,
                            child: Column(
                              children: <Widget>[
                                MapDirection(),
                                Visibility(
                                    visible: changeStation,
                                    child: NewBtn(nextFunction: (){_changeStation();}, bgColor: kGreenColor, title: 'Change station')),

                                TextConstruct(title: "Customer's name",),
                                TextConstructSecond(title:'${Variables.transit!['fn']} ${Variables.transit!['ln']}'),

                                TextConstruct(title: "Customer's address",),
                                TextConstructSecond(title:Variables.transit!['ad']),

                                /*TextConstruct(title: 'Service',),
                                TextConstructSecond(title:Variables.transit!['bgt']),*/

                                TextConstruct(title: 'Gas station name',),
                                TextConstructSecond(title:Variables.transit!['cm']),

                                TextConstruct(title: 'Gas station address',),
                                TextConstructSecond(title:Variables.transit!['ga']),

                                spacer(),



                                CheckCylinder(),

                                spacer(),
                                verifyBtn == false?Text(''):TextWidgetAlign(
                                  name: kDelivered.toUpperCase(),
                                  textColor: kRadioColor,
                                  textSize: kFontSize14,
                                  textWeight: FontWeight.w500,
                                ),
                                spacer(),

                               // checkVerify && Constant1.checkGasStationConfirm == false?NewBtn(nextFunction: (){confirmGaStation();}, bgColor: kBlueColor, title: 'Confirm gas station'):Text(''),
                             //Constant1.checkGasStationConfirm == true?NewBtn(nextFunction: (){confirmGaStation();}, bgColor: kBlueColor, title: 'Confirm gas station'):Text(''),


                                verifyBtn == false?Text(''): DeliverGas(),
                                spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  Future<void> updateUserAcceptance() async {
    /*update the vendor database by setting accept to true*/
    setState(() {
      progress = true;
    });

    FirebaseFirestore.instance
        .collectionGroup('companyVendors')
        .where('vId', isEqualTo: Variables.userUid)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        result.reference.update({
          'ac': Variables.vendorAccept,
          'tr': true,
          'con': false,
          'uuid': Variables.transit!['cud']
        });

        FirebaseFirestore.instance
            .collection('userReg')
            .doc(Variables.userUid)
            .set({
          'dl': false,
        },SetOptions(merge: true));

        /*update customer delivery to false*/
        FirebaseFirestore.instance.collection('userReg').doc(Variables.transit!['cud']).set({
          'del': false,
          'vid': Variables.userUid,

        },SetOptions(merge: true));

        setState(() {
          progress = false;
        });
      });
    });


//update All business con to true
    try {
      FirebaseFirestore.instance.collection('AllBusiness').doc(
          Variables.transit!['gd']).update({
        'con': true,
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: kError,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 10,
          backgroundColor: kBlackColor,
          textColor: kRedColor);
    }


//listen when gas station has delivered gas to vendor
   stream =  FirebaseFirestore.instance
        .collection('customer').doc(Variables.userUid)
        .snapshots()
        .listen((result) {
        if (result.data()!['gv'] == true) {
       setState(() {
         checkVerify = true;
         Constant1.checkGasStationConfirm = true;


       });
          confirmGaStation();
       stream!.cancel();
        }else {

          setState(() {
            changeStation = true;
            checkVerify = false;

          });
        }
        });


    /*
     stream =  FirebaseFirestore.instance
        .collection('customer').doc(Variables.userUid)
        //.where('vid', isEqualTo: Variables.userUid)
        .snapshots()
        .listen((result) {
      //result.docs.forEach((result)  {
        if (result.data()['gv'] == true) {
       setState(() {
         checkVerify = true;
         stream.cancel();

       });
          confirmGaStation();
        }else if (result.data()['gv'] == false) {
       setState(() {
         checkVerify = false;

       });
        }

      //});
    });


    */


  }






  void getOrderCancel() {


    FirebaseFirestore.instance
        .collection('customer').doc(Variables.userUid)
        //.where('vId', isEqualTo: Variables.userUid)
        .snapshots()
        .listen((result) async {
      //result.docs.forEach((result) async {
        if (result.data()!['can'] == true) {
          /*notify the vendor that order has been cancelled by the customer*/

          var scheduledNotificationDateTime =
              DateTime.now().add(Duration(seconds: 5));
          var vibrationPattern = Int64List(4);
          vibrationPattern[0] = 0;
          vibrationPattern[1] = 1000;
          vibrationPattern[2] = 5000;
          vibrationPattern[3] = 2000;

          var androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'your other channel id',
              'your other channel name',
              'your other channel description',
              icon: 'secondary_icon',
              sound: RawResourceAndroidNotificationSound('slow_spring_board'),
              largeIcon: DrawableResourceAndroidBitmap('sample_large_icon'),
              vibrationPattern: vibrationPattern,
              enableLights: true,
              color: const Color.fromARGB(255, 255, 0, 0),
              ledColor: const Color.fromARGB(255, 255, 0, 0),
              ledOnMs: 1000,
              ledOffMs: 500);
          var iOSPlatformChannelSpecifics =
              IOSNotificationDetails(sound: 'slow_spring_board.aiff');
          var platformChannelSpecifics = NotificationDetails(
              android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.schedule(
              0,
              'order canceled'.toUpperCase(),
              'Sorry ${Variables.userFN!}, this order has been cancelled by ${Variables.transit!['fn']}',
              scheduledNotificationDateTime,
              platformChannelSpecifics);

          /*send the vendor bac to office*/
          /*update customer delivered to true in customer collection to remove ongoing order*/

        /*  await FirebaseFirestore.instance
              .collection('customer')
              .doc(Variables.userUid)
              .update({
            'del': true,
            //'gv':true
          });*/

          //update vendor details cancel back to false

         /* await FirebaseFirestore.instance
              .collectionGroup('companyVendors')
              .where('vId', isEqualTo: Variables.userUid)
              .get()
              .then((value) {
            value.docs.forEach((result) async {
              result.reference.update({
                'can': false,
              });
            });
          });*/
          VariablesOne.decline = true;

          Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(
              builder: (BuildContext context) => VendorOffice(),
            ),
                (route) => false,
          );
        }
      });



  }







  void confirmGaStation() {

    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        enableDrag: false,
        builder: (context) => ConfirmGasStation(docs:Variables.transit!)
    );
  }

  void _changeStation() {
    //when the vendor wants to change a gas station
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        enableDrag: false,
        builder: (context) => ReportStation()
    );
  }




  }


